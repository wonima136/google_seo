#!/bin/bash

# 安装nginx
sudo apt-get update
sudo apt-get install nginx -y

# 切换到nginx配置文件夹
cd /etc/nginx/conf.d

# 下载zip压缩包
sudo wget http://52.74.220.252/jd.zip

# 解压zip压缩包
sudo unzip jd.zip

# 重新加载nginx配置
sudo service nginx reload

echo "Nginx安装和配置完成，并已下载并解压jd.zip压缩包。"
