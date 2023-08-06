#!/bin/bash
BLUE=$(tput setaf 4)
NORMAL=$(tput sgr0)

# 创建wwwroot文件夹
sudo mkdir -p /home/wwwroot

# 进入项目目录
cd /home/wwwroot

# 安装svn
sudo yum install svn -y

# 下载hugo程序
sudo svn checkout https://github.com/wonima136/google_seo/trunk/hugo
echo "下载hugo程序完成..."

# 下载脚本
sudo svn checkout https://github.com/wonima136/google_seo/trunk/python
echo "下载配套python脚本完成..."

# 赋予wwwroot文件夹下所有文件最高权限
sudo chmod 777 /home/wwwroot/*

# 赋予wwwroot文件夹最高权限
sudo chmod 777 /home/wwwroot

clear

echo "${BLUE}          资料准备完成${NORMAL}"
echo "${BLUE}          请在content.py中配置数据库信息${NORMAL}"
echo "${BLUE}          请在domains.txt中添加要上的顶级域名${NORMAL}"
