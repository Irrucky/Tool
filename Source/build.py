#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import re
from collections import defaultdict
from pathlib import Path

def process_surge():
    rules_folder = Path("../Surge/rules")

    if not rules_folder.exists():
        print(f"Error: Folder {rules_folder} does not exist")
        return

    list_files = list(rules_folder.glob("*.list"))

    if not list_files:
        print(f"Warning: No .list files found in {rules_folder}")
        return

    print(f"Found {len(list_files)} .list files")

    for file_path in list_files:
        print(f"\nProcessing file: {file_path.name}")
        process_single_file(file_path)

    print("\nAll files processed successfully!")


def process_single_file(file_path):
    file_name = file_path.name

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()

        processed_lines = []
        for line in lines:
            line = line.strip()
            if not line or line.startswith('#'):
                continue

            line = re.sub(r'(?<!:)//.*$', '', line).strip()
            if '#' in line:
                line = line.split('#')[0].strip()

            if not line:
                continue

            valid_prefixes = [
                'DOMAIN,', 'DOMAIN-SUFFIX,', 'DOMAIN-KEYWORD,',
                'DOMAIN-WILDCARD,', 'IP-CIDR,', 'IP-CIDR6,', 'IP-ASN,'
            ]

            if not any(line.startswith(prefix) for prefix in valid_prefixes):
                continue

            if line.startswith(('IP-CIDR,', 'IP-CIDR6,', 'IP-ASN,')):
                if not line.endswith(',no-resolve'):
                    line = line + ',no-resolve'

            processed_lines.append(line)

        if file_name == 'Ads_AWAvenue.list':
            processed_lines = [line for line in processed_lines
                               if not line.startswith('DOMAIN-KEYWORD,')]

        elif file_name == 'Reject.list':
            processed_lines = [line for line in processed_lines
                               if 'ad.12306.cn' not in line and '118.89.204.198' not in line]
            processed_lines = [line.replace('DOMAIN,', 'DOMAIN-SUFFIX,')
                               for line in processed_lines]

        elif file_name == 'adrules.list':
            processed_lines = [line for line in processed_lines
                               if 'ad.12306.cn' not in line]

        processed_lines = sorted(set(processed_lines))

        name = file_path.stem
        count = len(processed_lines)

        header = [
            f"# Name: {name}",
            f"# Count: {count}",
            ""
        ]

        final_lines = header + processed_lines

        with open(file_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(final_lines))
            f.write('\n')

        print(f"Completed: {count} rules")

    except Exception as e:
        print(f"Failed: {str(e)}")


def process_sing_box():
    rules_folder = Path("../sing-box/rule")

    if not rules_folder.exists():
        print(f"Error: Folder {rules_folder} does not exist")
        return

    json_files = list(rules_folder.glob("*.json"))

    if not json_files:
        print(f"Warning: No .json files found in {rules_folder}")
        return
    print(f"Found {len(json_files)} .json files")

    for file_path in json_files:
        print(f"\nProcessing file: {file_path.name}")
        process_single_json(file_path)

    print("\nAll JSON files processed successfully!")


def process_single_json(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()

        rules_dict = defaultdict(list)

        for line in lines:
            line = line.strip()

            if not line or line.startswith('#'):
                continue

            line = re.sub(r'(?<!:)//.*$', '', line).strip()
            if '#' in line:
                line = line.split('#')[0].strip()

            if not line:
                continue

            if line.startswith('DOMAIN,'):
                domain = line.replace('DOMAIN,', '').split(',')[0].strip()
                if domain:
                    rules_dict['domain'].append(domain)

            elif line.startswith('DOMAIN-SUFFIX,'):
                suffix = line.replace('DOMAIN-SUFFIX,', '').split(',')[0].strip()
                if suffix:
                    rules_dict['domain_suffix'].append(suffix)

            elif line.startswith('DOMAIN-KEYWORD,'):
                keyword = line.replace('DOMAIN-KEYWORD,', '').split(',')[0].strip()
                if keyword:
                    rules_dict['domain_keyword'].append(keyword)

            elif line.startswith('IP-CIDR,') or line.startswith('IP-CIDR6,'):
                if line.startswith('IP-CIDR,'):
                    cidr = line.replace('IP-CIDR,', '').split(',')[0].strip()
                else:
                    cidr = line.replace('IP-CIDR6,', '').split(',')[0].strip()

                if cidr:
                    rules_dict['ip_cidr'].append(cidr)

        for rule_type in rules_dict:
            rules_dict[rule_type] = sorted(set(rules_dict[rule_type]))

        json_output = {
            "version": 3,
            "rules": []
        }

        rule_order = ['domain', 'domain_keyword', 'domain_suffix', 'ip_cidr']

        for rule_type in rule_order:
            if rule_type in rules_dict and rules_dict[rule_type]:
                json_output["rules"].append({
                    rule_type: rules_dict[rule_type]
                })

        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(json_output, f, ensure_ascii=False, indent=2)
            f.write('\n')

        total_rules = sum(len(rules) for rules in rules_dict.values())
        print(f"Completed: {total_rules} rules")

    except Exception as e:
        print(f"Failed: {str(e)}")


def main():
    print("=" * 20)
    process_surge()
    print("=" * 20)
    process_sing_box()


if __name__ == "__main__":
    main()
