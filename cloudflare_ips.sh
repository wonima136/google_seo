#!/bin/bash

# 检查目录是否存在，如果不存在则创建目录
if [ ! -d "/www/googlebot_ips/" ]; then
  mkdir -p /www/googlebot_ips/
fi

# 创建新文件并写入 IPv4 地址
curl https://www.cloudflare.com/ips-v4 | awk '{print "set_real_ip_from " $1 ";"}' > /www/googlebot_ips/cloudflare_ips_v4.txt

# 追加 IPv6 地址到同一个文件
curl https://www.cloudflare.com/ips-v6 | awk '{print "set_real_ip_from " $1 ";"}' >> /www/googlebot_ips/cloudflare_ips_v4.txt

# 设置文件权限
chmod 777 /www/googlebot_ips/*

# 重载 Nginx 配置
/etc/init.d/nginx reload

# 输出完成信息
echo "CloudFlare IPv4和IPv6地址范围已更新到同一文件，NGINX已成功重新加载。"
