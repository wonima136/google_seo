#!/bin/bash

# 创建wwwroot文件
sudo mkdir -p  /home/wwwroot

# 进入项目
cd /home/wwwroot/

# 安装svn
yum install svn -y

# 下载hogo程序
sudo svn checkout https://github.com/wonima136/google_seo/trunk/hugo
echo "下载hogo程序完成..."

# 下载脚本
sudo svn checkout https://github.com/wonima136/google_seo/trunk/python
echo "下载配套python脚本完成..."

# 给wwwroot最高权限权限
sudo chmod 777 /home/wwwroot/*

echo "资料准备完成"
echo "在content.py配置数据库信息"
echo "domains.txt添加要上的顶级域名"
