#!/usr/bin/env bash

mkdir -p {Surge/rules,QuantumultX/Script,sing-box/rule}

# Ads_AWAvenue.list
curl -L -o Surge/rules/Ads_AWAvenue.list "https://raw.githubusercontent.com/TG-Twilight/AWAvenue-Ads-Rule/main/Filters/AWAvenue-Ads-Rule-Surge-RULE-SET.list"

# resource-parser.js
curl -L -o QuantumultX/Script/resourse-parser.js "https://raw.githubusercontent.com/KOP-XIAO/QuantumultX/master/Scripts/resource-parser.js"

# adrules.list
{
    curl -L "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanAD.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanProgramAD.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/TG-Twilight/AWAvenue-Ads-Rule/main/Filters/AWAvenue-Ads-Rule-Surge-RULE-SET.list"
    echo ""
} >> Surge/rules/adrules.list

# Reject.list
{
    curl -L "https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/adrules.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Cats-Team/AdRules/main/adrules.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Ads_SukkaW.list"
} > Surge/rules/Reject.list

# GFW.list
{
    curl -L "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Google/Google.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/GitHub+.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Telegram.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/YouTube/YouTube.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Spotify.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Microsoft/Microsoft.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Twitter/Twitter.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Instagram/Instagram.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Speedtest/Speedtest.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Pinterest/Pinterest.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ProxyGFWlist.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Loyalsoldier/surge-rules/release/ruleset/gfw.txt"
    echo ""
} > Surge/rules/GFW.list

# GitHub+.list
{
    curl -L "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/GitLab/GitLab.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/GitHub/GitHub.list"
} > Surge/rules/GitHub+.list

# Porn+.list
{
    curl -L "https://raw.githubusercontent.com/Centralmatrix3/Scripts/refs/heads/master/Ruleset/18comic.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Porn.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Centralmatrix3/Scripts/master/Ruleset/PornHub.list"
} >> Surge/rules/Porn+.list

curl -L -o sing-box/rule/AppleProxy.json "https://github.com/Repcz/Tool/raw/X/Surge/Rules/AppleProxy.list"
curl -L -o sing-box/rule/Goole.json "https://github.com/blackmatrix7/ios_rule_script/raw/master/rule/Surge/Google/Google.list"
curl -L -o sing-box/rule/YouTube.json "https://github.com/blackmatrix7/ios_rule_script/raw/master/rule/Surge/YouTube/YouTube.list"
curl -L -o sing-box/rule/AI.json "https://github.com/Repcz/Tool/raw/X/Surge/Rules/AI.list"
curl -L -o sing-box/rule/Twitter.json "https://github.com/Repcz/Tool/raw/X/Surge/Rules/Twitter.list"
curl -L -o sing-box/rule/Porn.json "https://github.com/Irrucky/Tool/raw/main/Surge/rules/Porn%2B.list"
curl -L -o sing-box/rule/GitHub.json "https://github.com/Irrucky/Tool/raw/main/Surge/rules/GitHub%2B.list"
curl -L -o sing-box/rule/AD.json "https://github.com/Irrucky/Tool/raw/main/Surge/rules/adrules.list"
curl -L -o sing-box/rule/Pinterest.json "https://github.com/blackmatrix7/ios_rule_script/raw/master/rule/Surge/Pinterest/Pinterest.list"
curl -L -o sing-box/rule/Telegram.json "https://github.com/Repcz/Tool/raw/X/Surge/Rules/Telegram.list"
