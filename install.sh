#!/bin/bash

# 更新软件包列表
echo "正在更新软件包列表..."
yum update -y

# 安装nginx
echo "正在安装nginx..."
yum install -y epel-release
yum install -y nginx
systemctl start nginx
systemctl enable nginx

# 安装PHP 7.4
echo "正在安装PHP 7.4..."
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install -y yum-utils
yum-config-manager --enable remi-php74
yum install -y php php-cli php-fpm php-mysql php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json

# 安装 MySQL 5.7
echo "正在安装MySQL 5.7..."
wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
rpm -ivh mysql57-community-release-el7-11.noarch.rpm
yum install -y mysql-server
systemctl start mysqld

# MySQL安全配置，设置root用户密码
echo "正在进行MySQL安全配置..."
mysql_secure_installation

# 询问用户输入MySQL root密码
echo "请输入MySQL root用户的密码:"
read -s root_password

# 赋予所有数据库的所有权限给root用户
echo "正在配置MySQL用户权限..."
mysql -uroot -p${root_password} -e "grant all on *.* to 'root'@'%' identified by '${root_password}';"

# 关闭防火墙
echo "正在关闭防火墙..."
systemctl stop firewalld
systemctl disable firewalld

# 开启3306端口
echo "正在开启3306端口..."
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload

# 输出nginx，php，mysql的状态和版本
echo "正在获取nginx，php，mysql的状态和版本..."
systemctl status nginx
php -v
systemctl status mysqld
