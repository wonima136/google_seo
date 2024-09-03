#!/bin/bash

# 检查目录是否存在，如果不存在则创建目录
if [ ! -d "/www/wwwroot/data/" ]; then
  mkdir -p /www/wwwroot/data/
fi

# 进入目录
cd /www/wwwroot/data/

# 保存IP段的文件路径
output_file="服务器全部IP.txt"

# 清空文件内容，如果文件存在的话
> "$output_file"

# 获取 eth0 网络接口上的公网IP地址并保存到文件
echo "获取 eth0 网络接口上的公网IP地址..."
/sbin/ip addr show dev eth0 | grep -oP 'inet \K[\d.]+' | sort -u >> "$output_file"

echo "附加IP地址获取完成，保存在 $output_file 中。"
