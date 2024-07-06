#!/bin/bash

# 检查目录是否存在，如果不存在则创建目录
if [ ! -d "/www/googlebot_ips/" ]; then
  mkdir -p /www/googlebot_ips/
fi

# 检查jq是否已经安装。如果没有安装，则执行安装
if ! [ -x "$(command -v jq)" ]; then
  sudo yum install jq -y
fi

# 临时文件用于存储新数据
temp_file="/tmp/new_googlebot_ips.txt"

# 清空 googlebot_ips.txt
> /www/googlebot_ips/googlebot_ips.txt

# 获取 Cloudflare 地址，添加 set_real_ip_from 前缀并保存到 cloudflare_ips_v4.txt 文件中
curl -s https://www.cloudflare.com/ips-v4 | awk '{print "set_real_ip_from " $1 ";"}' > /www/googlebot_ips/cloudflare_ips_v4.txt && chmod 777 /www/googlebot_ips/cloudflare_ips_v4.txt

# 从 Google JSON 数据获取 IPv4 地址，如果非空且有效，则追加到 googlebot_ips.txt 文件中
curl -s https://developers.google.com/search/apis/ipranges/googlebot.json | jq -r '.prefixes[] | select(.ipv4Prefix != null) | .ipv4Prefix' >> "$temp_file"

# 从 Google JSON 数据获取 IPv6 地址，如果非空且有效，则追加到临时文件中
curl -s https://developers.google.com/search/apis/ipranges/googlebot.json | jq -r '.prefixes[] | select(.ipv6Prefix != null) | .ipv6Prefix' >> "$temp_file"

# 从 Bing JSON 数据获取 IPv4 地址，如果非空且有效，则追加到 googlebot_ips.txt 文件中
curl -s https://www.bing.com/toolbox/bingbot.json | jq -r '.[] | select(.ipv4Prefix != null) | .ipv4Prefix' >> /www/googlebot_ips/googlebot_ips.txt

# 将临时文件覆盖到 googlebot_ips.txt
mv "$temp_file" /www/googlebot_ips/googlebot_ips.txt

# 将文件权限设置为777
chmod 777 /www/googlebot_ips/*

echo "脚本执行完成。"
