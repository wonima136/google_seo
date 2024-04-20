#!/bin/bash

# 安装EPEL和Remi仓库
sudo yum install -y epel-release yum-utils
sudo yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi-php74

# 更新软件包索引
sudo yum update -y

# 安装Nginx
sudo yum install -y nginx

# 启动Nginx服务并设置为开机自启
sudo systemctl start nginx
sudo systemctl enable nginx

# 添加MySQL官方仓库
sudo rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm

# 安装MySQL 5.7
sudo yum install -y mysql-community-server

# 启动MySQL服务并设置为开机自启
sudo systemctl start mysqld
sudo systemctl enable mysqld

# MySQL安装后自动设置root密码
NEW_ROOT_PASSWORD='f7a910dfcb021ff'
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${NEW_ROOT_PASSWORD}'; FLUSH PRIVILEGES;"

# 安装PHP及其与MySQL交互的扩展
sudo yum install -y php php-mysqlnd php-fpm

# 启动PHP-fpm服务并设置为开机自启
sudo systemctl start php-fpm
sudo systemctl enable php-fpm

# 显示安装的服务状态
echo "Nginx, MySQL 5.7, and PHP-7.4 have been installed and started."
echo "Nginx version: $(nginx -v)"
echo "MySQL service status: $(systemctl status mysqld | grep 'Active')"
echo "PHP version: $(php -v | head -n 1)"
