#!/bin/bash

# 检查目录是否存在，如果不存在则创建目录
if [ ! -d "/www/googlebot_ips/" ]; then
  mkdir -p /www/googlebot_ips/
fi

# 检查jq是否已经安装。如果没有安装，则执行安装
if ! [ -x "$(command -v jq)" ]; then
  sudo yum install jq -y
fi

# 获取 Cloudflare 地址，添加 set_real_ip_from 前缀并保存到文件中
curl https://www.cloudflare.com/ips-v4 | awk '{print "set_real_ip_from " $1 ";"}' > /www/googlebot_ips/cloudflare_ips_v4.txt && chmod 777 /www/googlebot_ips/cloudflare_ips_v4.txt

# 从 Google JSON 数据获取地址，如果非空且有效，则添加'allow'到文件中
curl https://developers.google.com/search/apis/ipranges/googlebot.json | jq -r '.prefixes[] | select(.ipv4Prefix) | .ipv4Prefix' | while read -r ip; do if [[ $ip != "null" ]]; then echo "allow $ip;" >> /www/googlebot_ips/googlebot_ips.txt; fi; done

# 从提供的URL获取IP，并保存到文件中，并添加 "allow" 前缀和 ";" 后缀
curl http://107.148.4.229/whitelist_ips.txt | awk '{print "allow " $1 ";"}' > /www/googlebot_ips/whitelist_ips.txt

# 将文件权限设置为777
chmod 777 /www/googlebot_ips/*
