#!/bin/bash  

mkdir -p Tool-repo/{Surge/rules,Surge/rules/RuleSet,QuantumultX/Script}

# single rule
# Ads_AWAvenue.list
curl -L -o Tool-repo/Surge/rules/Ads_AWAvenue.list "https://raw.githubusercontent.com/TG-Twilight/AWAvenue-Ads-Rule/main/Filters/AWAvenue-Ads-Rule-Surge-RULE-SET.list"

# resource-parser.js
curl -L -o Tool-repo/QuantumultX/Script/resourse-parser.js "https://raw.githubusercontent.com/KOP-XIAO/QuantumultX/master/Scripts/resource-parser.js"

# diverse rule
declare -A matrix=(
    # adrules.list
    ["Tool-repo/Surge/rules/adrules.list"]="https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/Ads.list
        https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanAD.list
        https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Ads_limbopro.list
        https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanProgramAD.list
        https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanEasyListChina.list
        https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/Ads_AWAvenue.list
        https://raw.githubusercontent.com/ConnersHua/RuleGo/master/Surge/Ruleset/Extra/Reject/Advertising.list
        https://raw.githubusercontent.com/ConnersHua/RuleGo/master/Surge/Ruleset/Extra/Reject/Malicious.list
        https://raw.githubusercontent.com/ConnersHua/RuleGo/master/Surge/Ruleset/Extra/Reject/Tracking.list"

    # Reject.list
    ["Tool-repo/Surge/rules/Reject.list"]="https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/adrules.list
        https://raw.githubusercontent.com/Cats-Team/AdRules/main/adrules.list"

    # GFW.list && GFW_ip.list
    ["Tool-repo/Surge/rules/RuleSet/GFW.list"]="https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Google/Google.list
        https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/GitHub+.list
        https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Telegram.list
        https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/Porn+.list
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/YouTube/YouTube.list
        https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Spotify.list
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Microsoft/Microsoft.list
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Twitter/Twitter.list
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Instagram/Instagram.list
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Speedtest/Speedtest.list
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Pinterest/Pinterest.list
        https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ProxyGFWlist.list
        https://raw.githubusercontent.com/Loyalsoldier/surge-rules/release/ruleset/gfw.txt"
    
    ["Tool-repo/Surge/rules/RuleSet/GFW_ip.list"]="https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Google/Google.list
        https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/GitHub+.list
        https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Telegram.list
        https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/Porn+.list
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/YouTube/YouTube.list
        https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Spotify.list
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Microsoft/Microsoft.list
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Twitter/Twitter.list
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Instagram/Instagram.list
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Speedtest/Speedtest.list
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Pinterest/Pinterest.list
        https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ProxyGFWlist.list
        https://raw.githubusercontent.com/Loyalsoldier/surge-rules/release/ruleset/gfw.txt"

    # GitHub+.list
    ["Tool-repo/Surge/rules/GitHub+.list"]="https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/GitLab/GitLab.list
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/GitHub/GitHub.list
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Gitee/Gitee.list"

    # Porn+.list
    ["Tool-repo/Surge/rules/Porn+.list"]="https://raw.githubusercontent.com/Centralmatrix3/Scripts/refs/heads/master/Ruleset/18comic.list
        https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Porn.list
        https://raw.githubusercontent.com/Centralmatrix3/Scripts/master/Ruleset/PornHub.list"
)

for output in "${!matrix[@]}"; do
    urls=${matrix[$output]}
    if [[ "$output" == "Tool-repo/Surge/rules/Porn+.list" ]]; then
        for url in $urls; do
            curl -L "$url" >> "$output"  
            echo "" >> "$output"        
        done
    elif [[ "$urls" == *@* ]]; then
        input=${urls#@}
        cp "$input" "$output"
    else
        {
            for url in $urls; do
                curl -L "$url"
                echo ""
            done
        } > "$output"
    fi
done

cd Tool-repo/Surge/rules || { echo "目录 Tool-repo/Surge/rules 不存在"; exit 1; }

for file in *.list; do
  if [ -f "$file" ]; then
    sed -i -e 's/IP-CIDR,[[:space:]]*/IP-CIDR,/g' \
           -e 's/DOMAIN-WILDCARD,[[:space:]]*/DOMAIN-WILDCARD,/g' \
           -e 's/DOMAIN,[[:space:]]*/DOMAIN,/g' \
           -e 's/IP-CIDR6,[[:space:]]*/IP-CIDR6,/g' \
           -e 's/DOMAIN-SUFFIX,[[:space:]]*/DOMAIN-SUFFIX,/g' \
           -e 's/DOMAIN-KEYWORD,[[:space:]]*/DOMAIN-KEYWORD,/g' \
           -e 's/,REJECT$//g' \
           -e 's/,DIRECT$//g' \
           -e 's/,reject$//g' \
           -e 's/,direct$//g' \
           -e 's/,[[:space:]]*/,/g' \
           -e '/PROCESS-NAME\|URL-REGEX\|DOMAIN-WILDCARD/d' \
           -e '/404: Not Found/d' \
           "$file"
  else
    echo "$file not found."
  fi
done

for file in Reject.list Ads_AWAvenue.list; do
  if [ -f "$file" ]; then
    if [ "$file" = "Ads_AWAvenue.list" ]; then
      sed -i -e '/DOMAIN-KEYWORD/d' "$file"
    else
      sed -i -e 's/DOMAIN,/DOMAIN-SUFFIX,/g' \
             -e '/DOMAIN-SUFFIX,ad.12306.cn/d' \
             "$file"
    fi
  else
    echo "$file not found."
  fi
done

cd RuleSet || { echo "目录 RuleSet 不存在"; exit 1; }
for file in *.list; do
  if [ "$file" = "GFW.list" ]; then
    sed -i -e '/IP-CIDR\|IP-CIDR6\|IP-ASN/d' "$file"
  else
    sed -i -e '/IP-CIDR\|IP-CIDR6\|IP-ASN/!d' "$file"
  fi
done