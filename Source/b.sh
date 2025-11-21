#!/bin/bash  

mkdir -p Tool-repo/{Surge/rules,Surge/rules/RuleSet,QuantumultX/Script,Surge/rules/domainset}

# single rule
# Ads_AWAvenue.list
curl -L -o Tool-repo/Surge/rules/Ads_AWAvenue.list "https://raw.githubusercontent.com/TG-Twilight/AWAvenue-Ads-Rule/main/Filters/AWAvenue-Ads-Rule-Surge-RULE-SET.list"

# resource-parser.js
curl -L -o Tool-repo/QuantumultX/Script/resourse-parser.js "https://raw.githubusercontent.com/KOP-XIAO/QuantumultX/master/Scripts/resource-parser.js"

# diverse rule
declare -A matrix=(
    # adrules.list
    ["Tool-repo/Surge/rules/adrules.list"]="https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/Ads.list \
        https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanAD.list \
        https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Ads_limbopro.list \
        https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanProgramAD.list \
        https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanEasyListChina.list \
        https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/Ads_AWAvenue.list \
        https://raw.githubusercontent.com/ConnersHua/RuleGo/master/Surge/Ruleset/Extra/Reject/Advertising.list \
        https://raw.githubusercontent.com/ConnersHua/RuleGo/master/Surge/Ruleset/Extra/Reject/Malicious.list \
        https://raw.githubusercontent.com/ConnersHua/RuleGo/master/Surge/Ruleset/Extra/Reject/Tracking.list"

    # Reject.list
    ["Tool-repo/Surge/rules/Reject.list"]="https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/adrules.list \
        https://raw.githubusercontent.com/Cats-Team/AdRules/main/adrules.list"

    # GFW.list
    ["Tool-repo/Surge/rules/RuleSet/GFW.list"]="https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Google/Google.list \
        https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/GitHub+.list \
        https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Telegram.list \
        https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/Porn+.list \
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/YouTube/YouTube.list \
        https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Spotify.list \
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Microsoft/Microsoft.list \
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Twitter/Twitter.list \
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Instagram/Instagram.list \
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Speedtest/Speedtest.list \
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Pinterest/Pinterest.list \
        https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ProxyGFWlist.list \
        https://raw.githubusercontent.com/Loyalsoldier/surge-rules/release/ruleset/gfw.txt"

    # GitHub+.list
    ["Tool-repo/Surge/rules/GitHub+.list"]="https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/GitLab/GitLab.list \
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/GitHub/GitHub.list \
        https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Gitee/Gitee.list"

    # Porn+.list
    ["Tool-repo/Surge/rules/Porn+.list"]="https://raw.githubusercontent.com/Centralmatrix3/Scripts/refs/heads/master/Ruleset/18comic.list \
        https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Porn.list \
        https://raw.githubusercontent.com/Centralmatrix3/Scripts/master/Ruleset/PornHub.list"
)

for output in "${!matrix[@]}"; do
    urls=(${matrix[$output]})
    for url in "${urls[@]}"; do
        echo "下载: $url"
        curl -L "$url" >> "$output" || { echo "下载失败: $url"; exit 1; }
        echo "" >> "$output"
    done
done

# reject.list && reject_or.list
curl -L -o Tool-repo/Surge/rules/domainset/reject.list "https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/Reject.list"

curl -L -o Tool-repo/Surge/rules/RuleSet/reject_or.list "https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/Reject.list"