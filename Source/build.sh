#!/bin/bash  

mkdir -p Tool-repo/{Surge/rules,QuantumultX/Script,SingBox/RuleSet}

# Ads_AWAvenue.list
curl -L -o Tool-repo/Surge/rules/Ads_AWAvenue.list "https://raw.githubusercontent.com/TG-Twilight/AWAvenue-Ads-Rule/main/Filters/AWAvenue-Ads-Rule-Surge-RULE-SET.list"

# resource-parser.js
curl -L -o Tool-repo/QuantumultX/Script/resourse-parser.js "https://raw.githubusercontent.com/KOP-XIAO/QuantumultX/master/Scripts/resource-parser.js"

# adrules.list
{
    curl -L "https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/Ads.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanAD.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Ads_limbopro.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanProgramAD.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanEasyListChina.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/Ads_AWAvenue.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/ConnersHua/RuleGo/master/Surge/Ruleset/Extra/Reject/Advertising.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/ConnersHua/RuleGo/master/Surge/Ruleset/Extra/Reject/Malicious.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/ConnersHua/RuleGo/master/Surge/Ruleset/Extra/Reject/Tracking.list"
} > Tool-repo/Surge/rules/adrules.list

# Reject.list
{
    curl -L "https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/adrules.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Cats-Team/AdRules/main/adrules.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Ads_SukkaW.list"
    #echo ""
    #curl -L "https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/master/anti-ad-surge.txt"
} > Tool-repo/Surge/rules/Reject.list

# GFW.list
{
    curl -L "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Google/Google.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/GitHub+.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Telegram.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/Porn+.list"
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
} > Tool-repo/Surge/rules/GFW.list

# GitHub+.list
{
    curl -L "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/GitLab/GitLab.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/GitHub/GitHub.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Gitee/Gitee.list"
} > Tool-repo/Surge/rules/GitHub+.list

# Porn+.list
{
    curl -L "https://raw.githubusercontent.com/Centralmatrix3/Scripts/refs/heads/master/Ruleset/18comic.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Repcz/Tool/X/Surge/Rules/Porn.list"
    echo ""
    curl -L "https://raw.githubusercontent.com/Centralmatrix3/Scripts/master/Ruleset/PornHub.list"
} >> Tool-repo/Surge/rules/Porn+.list

curl -L -o Tool-repo/SingBox/RuleSet/Reject.json "https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/Reject.list"

curl -L -o Tool-repo/SingBox/RuleSet/Apple.json "https://github.com/Repcz/Tool/raw/X/Clash/Rules/Apple.list"

curl -L -o Tool-repo/SingBox/RuleSet/AppleProxy.json "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Clash/AppleProxy/AppleProxy.list"

curl -L -o Tool-repo/SingBox/RuleSet/YouTube.json "https://github.com/Repcz/Tool/raw/X/Clash/Rules/YouTube.list"

curl -L -o Tool-repo/SingBox/RuleSet/Google.json "https://github.com/Repcz/Tool/raw/X/Clash/Rules/Google.list"

curl -L -o Tool-repo/SingBox/RuleSet/Telegram.json "https://github.com/Repcz/Tool/raw/X/Clash/Rules/Telegram.list"

curl -L -o Tool-repo/SingBox/RuleSet/Twitter.json "https://github.com/Repcz/Tool/raw/X/Clash/Rules/Twitter.list"

curl -L -o Tool-repo/SingBox/RuleSet/AI.json "https://github.com/Repcz/Tool/raw/X/Clash/Rules/AI.list"

curl -L -o Tool-repo/SingBox/RuleSet/GitHub.json "https://raw.githubusercontent.com/Irrucky/Tool/main/Surge/rules/GitHub+.list"

curl -L -o Tool-repo/SingBox/RuleSet/Speedtest.json "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Clash/Speedtest/Speedtest.list"

curl -L -o Tool-repo/SingBox/RuleSet/Porn.json "https://raw.githubusercontent.com/Irrucky/Tool/refs/heads/main/Surge/rules/Porn%2B.list"

curl -L -o Tool-repo/SingBox/RuleSet/Instagram.json "https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Surge/Instagram/Instagram.list"