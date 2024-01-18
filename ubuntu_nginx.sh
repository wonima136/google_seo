#!/bin/bash

function updateNginxConfig() {
    default_site_config="/etc/nginx/sites-available/default"
    echo "server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        server_name _;
        location / {
            deny  all;
            allow 43.135.35.126;
            allow 43.132.185.49;
            allow 43.132.185.65;
            allow 192.178.0.0/16;
            allow 34.100.0.0/16;
            try_files \$uri \$uri/ =404;
        }
    }" | sudo tee $default_site_config

    sudo nginx -t && sudo systemctl reload nginx
}

# 更新源并安装Nginx
sudo apt update
sudo apt install -y nginx

config_file="/root/nginx_config.txt"
touch $config_file

nginx_version=$(nginx -v 2>&1 | awk -F/ '{print $2}')
nginx_config_dir="/etc/nginx"
website_config_dir="/etc/nginx/sites-available"
nginx_install_dir=$(which nginx)

echo "Nginx 版本: $nginx_version" >> $config_file
echo "Nginx 配置目录: $nginx_config_dir" >> $config_file
echo "网站配置目录: $website_config_dir" >> $config_file
echo "Nginx 安装目录: $nginx_install_dir" >> $config_file

chmod 600 $config_file

# 在这里调用函数来更新Nginx配置
updateNginxConfig

sudo systemctl start nginx
echo "Nginx配置信息已保存到 $config_file"

echo "Nginx安装完成，现在开始安装hugo"
sleep 5

cat /root/nginx_config.txt
