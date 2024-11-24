#!/bin/bash

# 检查目录是否存在，如果不存在则创建目录
if [ ! -d "/www/googlebot_ips/" ]; then
  mkdir -p /www/googlebot_ips/
fi

# 检查 jq 是否已经安装。如果没有安装，则执行安装
if ! [ -x "$(command -v jq)" ]; then
  sudo yum install jq -y
fi

# 临时文件用于存储新数据
temp_file="/tmp/new_googlebot_ips.txt"

# 获取 Cloudflare IPv4 地址，添加 set_real_ip_from 前缀并保存到 cloudflare_ips_v4.txt 文件中
curl -s https://www.cloudflare.com/ips-v4 | awk '{print "set_real_ip_from " $1 ";"}' > /www/googlebot_ips/cloudflare_ips_v4.txt

# 获取 Cloudflare IPv6 地址，并追加到 cloudflare_ips_v4.txt 文件中
curl -s https://www.cloudflare.com/ips-v6 | awk '{print "set_real_ip_from " $1 ";"}' >> /www/googlebot_ips/cloudflare_ips_v4.txt

# 设置 cloudflare_ips_v4.txt 的权限
chmod 777 /www/googlebot_ips/cloudflare_ips_v4.txt

# 从 Google JSON 数据获取 IPv4 和 IPv6 地址，如果非空且有效，则追加到临时文件中
curl -s https://developers.google.com/search/apis/ipranges/googlebot.json | jq -r '.prefixes[] | .ipv4Prefix, .ipv6Prefix' | while read -r ip; do
  if [[ $ip != "null" ]]; then
    echo "allow $ip;" >> "$temp_file"
  fi
done

# 从 Bing JSON 数据获取 IPv4 和 IPv6 地址，如果非空且有效，则追加到临时文件中
curl -s https://www.bing.com/toolbox/bingbot.json | jq -r '.prefixes[] | .ipv4Prefix, .ipv6Prefix' | while read -r ip; do
  if [[ $ip != "null" ]]; then
    echo "allow $ip;" >> "$temp_file"
  fi
done

# 清空 googlebot_ips.txt 文件，以便重新写入所有数据
> /www/googlebot_ips/googlebot_ips.txt

# 将临时文件内容（包括 Google 和 Bing 的 IPv4 和 IPv6 地址）追加到 googlebot_ips.txt 中
cat "$temp_file" >> /www/googlebot_ips/googlebot_ips.txt

# 删除临时文件
rm "$temp_file"

# 将文件权限设置为 777
chmod 777 /www/googlebot_ips/*
