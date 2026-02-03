#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import argparse
import json
import logging
import re
import sys
from collections import defaultdict
from concurrent.futures import ProcessPoolExecutor, as_completed
from dataclasses import dataclass
from pathlib import Path
from typing import Callable

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%H:%M:%S",
)
logger = logging.getLogger(__name__)


@dataclass(frozen=True)
class RuleConfig:
    """Configuration for rule processing."""

    valid_prefixes: tuple[str, ...] = (
        "DOMAIN,",
        "DOMAIN-SUFFIX,",
        "DOMAIN-KEYWORD,",
        "DOMAIN-WILDCARD,",
        "IP-CIDR,",
        "IP-CIDR6,",
        "IP-ASN,",
    )
    ip_cidr_prefixes: tuple[str, ...] = ("IP-CIDR,", "IP-CIDR6,", "IP-ASN,")
    no_resolve_suffix: str = ",no-resolve"


@dataclass
class FileFilter:
    """Filter configuration for specific files."""

    exclude_lines: list[str] | None = None
    exclude_prefixes: tuple[str, ...] | None = None
    replace_map: dict[str, str] | None = None


class RuleParser:
    """Parser for rule lines with comment removal."""

    # Regex to match comments (// not preceded by :)
    COMMENT_REGEX = re.compile(r"(?<!:)//.*$")

    def __init__(self, config: RuleConfig | None = None):
        self.config = config or RuleConfig()

    def parse(self, line: str) -> str | None:
        """Parse a single line, removing comments and whitespace."""
        line = line.strip()
        if not line or line.startswith("#"):
            return None

        # Remove // comments (but not http://)
        line = self.COMMENT_REGEX.sub("", line).strip()

        # Remove inline # comments
        if "#" in line:
            line = line.split("#")[0].strip()

        return line if line else None

    def is_valid_rule(self, line: str) -> bool:
        """Check if line starts with a valid rule prefix."""
        return any(line.startswith(prefix) for prefix in self.config.valid_prefixes)

    def add_no_resolve(self, line: str) -> str:
        """Add no-resolve suffix to IP CIDR rules if missing."""
        if line.startswith(self.config.ip_cidr_prefixes) and not line.endswith(
            self.config.no_resolve_suffix
        ):
            return line + self.config.no_resolve_suffix
        return line


class RuleProcessor:
    """Main processor for rule files."""

    # File-specific filter configurations
    FILE_FILTERS: dict[str, FileFilter] = {
        "Ads_AWAvenue.list": FileFilter(exclude_prefixes=("DOMAIN-KEYWORD,",)),
        "Reject.list": FileFilter(
            exclude_lines=["ad.12306.cn", "118.89.204.198"],
            replace_map={"DOMAIN,": "DOMAIN-SUFFIX,"},
        ),
        "adrules.list": FileFilter(exclude_lines=["ad.12306.cn"]),
    }

    def __init__(self, parser: RuleParser | None = None):
        self.parser = parser or RuleParser()

    @staticmethod
    def deduplicate(lines: list[str]) -> list[str]:
        """Remove duplicates while preserving order."""
        return list(dict.fromkeys(lines))

    def apply_filters(self, lines: list[str], file_name: str) -> list[str]:
        """Apply file-specific filters."""
        filter_config = self.FILE_FILTERS.get(file_name)
        if not filter_config:
            return lines

        result = lines

        # Exclude lines containing specific strings
        if filter_config.exclude_lines:
            result = [
                line
                for line in result
                if not any(exclude in line for exclude in filter_config.exclude_lines)
            ]

        # Exclude lines with specific prefixes
        if filter_config.exclude_prefixes:
            result = [
                line
                for line in result
                if not line.startswith(filter_config.exclude_prefixes)
            ]

        # Apply replacements
        if filter_config.replace_map:
            for old, new in filter_config.replace_map.items():
                result = [line.replace(old, new) for line in result]

        return result

    def process_surge_file(self, file_path: Path) -> tuple[Path, int]:
        """Process a single Surge .list file."""
        file_name = file_path.name

        try:
            content = file_path.read_text(encoding="utf-8")
            lines = content.splitlines()

            processed = []
            for line in lines:
                parsed = self.parser.parse(line)
                if not parsed or not self.parser.is_valid_rule(parsed):
                    continue
                processed.append(self.parser.add_no_resolve(parsed))

            # Apply file-specific filters
            processed = self.apply_filters(processed, file_name)

            # Deduplicate
            processed = self.deduplicate(processed)

            # Build output with header
            header = [f"# Name: {file_path.stem}", f"# Count: {len(processed)}", ""]

            file_path.write_text("\n".join(header + processed) + "\n", encoding="utf-8")
            logger.info(f"  {file_name}: {len(processed)} rules")
            return file_path, len(processed)

        except Exception as e:
            logger.error(f"  Failed to process {file_name}: {e}")
            raise


class SingBoxConverter:
    """Converter for sing-box JSON format."""

    RULE_TYPE_MAP: dict[str, str] = {
        "DOMAIN,": "domain",
        "DOMAIN-SUFFIX,": "domain_suffix",
        "DOMAIN-KEYWORD,": "domain_keyword",
        "IP-CIDR,": "ip_cidr",
        "IP-CIDR6,": "ip_cidr",
    }

    RULE_ORDER = ["domain", "domain_keyword", "domain_suffix", "ip_cidr"]

    def __init__(self, parser: RuleParser | None = None):
        self.parser = parser or RuleParser()

    @staticmethod
    def deduplicate(items: list[str]) -> list[str]:
        """Remove duplicates while preserving order."""
        return list(dict.fromkeys(items))

    def extract_value(self, line: str, prefix: str) -> str | None:
        """Extract value after prefix, handling trailing options."""
        value = line[len(prefix) :].split(",")[0].strip()
        return value if value else None

    def process_file(self, file_path: Path) -> tuple[Path, int]:
        """Process a single JSON file."""
        try:
            content = file_path.read_text(encoding="utf-8")
            lines = content.splitlines()

            rules_dict: defaultdict[str, list[str]] = defaultdict(list)

            for line in lines:
                parsed = self.parser.parse(line)
                if not parsed:
                    continue

                for prefix, rule_type in self.RULE_TYPE_MAP.items():
                    if parsed.startswith(prefix):
                        value = self.extract_value(parsed, prefix)
                        if value:
                            rules_dict[rule_type].append(value)
                        break

            # Deduplicate each rule type
            for rule_type in rules_dict:
                rules_dict[rule_type] = self.deduplicate(rules_dict[rule_type])

            # Build JSON output
            json_output = {"version": 3, "rules": []}
            for rule_type in self.RULE_ORDER:
                if rule_type in rules_dict and rules_dict[rule_type]:
                    json_output["rules"].append({rule_type: rules_dict[rule_type]})

            file_path.write_text(
                json.dumps(json_output, ensure_ascii=False, indent=2) + "\n",
                encoding="utf-8",
            )

            total = sum(len(rules) for rules in rules_dict.values())
            logger.info(f"  {file_path.name}: {total} rules")
            return file_path, total

        except Exception as e:
            logger.error(f"  Failed to process {file_path.name}: {e}")
            raise


class BuildRunner:
    """Main runner for the build process."""

    def __init__(self, base_dir: Path, max_workers: int | None = None):
        self.base_dir = base_dir
        self.max_workers = max_workers
        self.parser = RuleParser()
        self.processor = RuleProcessor(self.parser)
        self.converter = SingBoxConverter(self.parser)

    def find_files(self, folder: str, pattern: str) -> list[Path]:
        """Find files matching pattern in folder."""
        target_dir = self.base_dir / folder
        if not target_dir.exists():
            logger.warning(f"Directory not found: {target_dir}")
            return []

        files = list(target_dir.glob(pattern))
        if not files:
            logger.warning(f"No {pattern} files in {target_dir}")
        return files

    def process_parallel(
        self, files: list[Path], processor: Callable[[Path], tuple[Path, int]]
    ) -> list[tuple[Path, int]]:
        """Process files in parallel."""
        if not files:
            return []

        if len(files) == 1 or self.max_workers == 1:
            return [processor(f) for f in files]

        results = []
        with ProcessPoolExecutor(max_workers=self.max_workers) as executor:
            futures = {executor.submit(processor, f): f for f in files}
            for future in as_completed(futures):
                try:
                    results.append(future.result())
                except Exception as e:
                    logger.error(f"Processing failed: {e}")
        return results

    def run_surge(self) -> int:
        """Process all Surge rule files."""
        files = self.find_files("Surge/rules", "*.list")
        if not files:
            return 0

        logger.info(f"Processing {len(files)} Surge files...")
        results = self.process_parallel(files, self.processor.process_surge_file)
        return sum(count for _, count in results)

    def run_sing_box(self) -> int:
        """Process all sing-box JSON files."""
        files = self.find_files("sing-box/rule", "*.json")
        if not files:
            return 0

        logger.info(f"Processing {len(files)} sing-box files...")
        results = self.process_parallel(files, self.converter.process_file)
        return sum(count for _, count in results)

    def run(self) -> int:
        """Run the complete build process."""
        logger.info("=" * 40)
        total_rules = self.run_surge()
        logger.info("-" * 40)
        total_rules += self.run_sing_box()
        logger.info("=" * 40)
        logger.info(f"Total rules processed: {total_rules}")
        return 0 if total_rules > 0 else 1


def main():
    parser = argparse.ArgumentParser(
        description="Build and optimize Surge and sing-box rule files.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s                    # Run with default settings
  %(prog)s -j 4               # Use 4 parallel workers
  %(prog)s -d /path/to/rules  # Specify base directory
  %(prog)s -v                 # Enable verbose logging
        """,
    )
    parser.add_argument(
        "-d",
        "--directory",
        type=Path,
        default=Path(__file__).resolve().parent.parent,
        help="Base directory containing Surge/ and sing-box/ folders (default: parent of script)",
    )
    parser.add_argument(
        "-j",
        "--workers",
        type=int,
        default=None,
        help="Number of parallel workers (default: auto)",
    )
    parser.add_argument(
        "-v", "--verbose", action="store_true", help="Enable verbose logging"
    )

    args = parser.parse_args()

    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)

    runner = BuildRunner(args.directory, max_workers=args.workers)
    sys.exit(runner.run())


if __name__ == "__main__":
    main()
