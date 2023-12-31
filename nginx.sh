#!/bin/bash

# 安装第三方yum源
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# 安装nginx
yum install -y nginx

# 创建保存配置信息的txt文件
config_file="/root/nginx_config.txt"
touch $config_file

# 获取nginx的配置信息
nginx_version=$(nginx -v 2>&1 | awk -F/ '{print $2}')
nginx_config_dir="/etc/nginx"
website_config_dir="/etc/nginx/conf.d"

# 获取nginx的安装位置
nginx_install_dir=$(which nginx)

# 创建conf.d目录
mkdir $website_config_dir

# 将配置信息写入txt文件
echo "Nginx 版本: $nginx_version" >> $config_file
echo "Nginx 配置目录: $nginx_config_dir" >> $config_file
echo "网站配置目录: $website_config_dir" >> $config_file
echo "Nginx 安装目录: $nginx_install_dir" >> $config_file

# 设置文件权限为只有root用户可读写
chmod 600 $config_file

# 加入nginx配置调整
sudo sed -i '/http {/a \ \ \ \ server_names_hash_max_size 1024;\n\ \ \ \ server_names_hash_bucket_size 512;' /etc/nginx/nginx.conf

# 创建用户
sudo useradd -r nginx
# 开启nginx
systemctl start nginx

echo "Nginx配置信息已保存到 $config_file"

# 开始安装hugo
echo "Nginx安装完成，现在开始安装hugo"
sleep 5

cat /root/nginx_config.txt

# cd /root
# yum install -y wget && wget -qO- https://raw.githubusercontent.com/wonima136/google_seo/main/hugo.sh | bash
