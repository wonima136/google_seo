#!/bin/bash

# 更新yum源，下载并执行拉取镜像文件的脚本
curl -O http://mirror-sv.raksmart.com/pull_mirror_file.sh && bash pull_mirror_file.sh <<< "y"

# -------------------------------------------------------------------------------

# 卸载挂载在/home的文件系统。如果已经卸载，则会显示：umount: /home: not mounted
sudo umount /home

# 自动查找系统中最大的磁盘设备，并将其存储在变量device中
device=$(lsblk -nrdo NAME,TYPE,SIZE | sort -rk 3,3 | head -n 1 | awk '{print "/dev/" $1}')

# 创建ext4文件系统并挂载到/www目录
sudo mkfs.ext4 $device
sudo mkdir -p /www
sudo mount $device /www
# 等待3秒钟以确保挂载完成
sleep 3

# -------------------------------------------------------------------------------

# 安装必要工具包
sudo yum install wget -y
sudo yum install unzip -y

# 创建下载目录
sudo mkdir -p /www/wwwroot/data/
cd /www/wwwroot/data/

# 下载wp必备工具的压缩包
sudo wget https://www.addlink.lol/data/wp%E5%BF%85%E5%A4%87%E5%B7%A5%E5%85%B7.zip

# 解压下载的wp必备工具压缩包
unzip wp必备工具.zip

# 等待3秒钟以确保解压完成
sleep 3

# 删除下载的wp必备工具压缩包
sudo rm -rf /www/wwwroot/data/wp必备工具.zip

# 安装dos2unix工具
sudo yum install dos2unix -y

# 等待3秒钟以确保安装完成
sleep 3

# 转换shell脚本文件的换行符格式
dos2unix /www/wwwroot/data/wp必备工具/生成网站主脚本/app-生成网站sql文件.sh

# 等待3秒钟以确保转换完成
sleep 3

# 转换另一个shell脚本文件的换行符格式
dos2unix /www/wwwroot/data/wp必备工具/生成网站主脚本/add-导入数据库.sh

# 等待5秒钟以确保转换完成
sleep 5

# 切换到/root目录
sudo cd /root

# 安装Python 3.9
curl -s https://raw.githubusercontent.com/wonima136/google_seo/main/python3.9.sh | bash

# 使环境变量生效（有时候需要，有时候不需要）
source ~/.bash_profile

# 等待5秒钟以确保环境变量生效
sleep 5

# 切换到/root目录
sudo cd /root

# 安装宝塔面板
sudo wget -O install.sh https://download.bt.cn/install/install_lts.sh
sudo bash install.sh ed8484bec -y

# 等待3秒钟以确保安装完成
sleep 3

# 获取服务器全部可用IP
curl -s https://raw.githubusercontent.com/wonima136/google_seo/main/huoqufujia_ip.sh | bash










































# #!/bin/bash

# # 更新yum源
# curl -O http://mirror-sv.raksmart.com/pull_mirror_file.sh && bash pull_mirror_file.sh <<< "y"

# # -------------------------------------------------------------------------------

# # 卸载挂载在/home的文件系统。
# sudo umount /home  # 如果已经卸载，则会显示：umount: /home: not mounted

# # 自动查找系统中最大的磁盘设备。
# device=$(lsblk -nrdo NAME,TYPE,SIZE | sort -rk 3,3 | head -n 1 | awk '{print "/dev/" $1}')

# # 创建ext4文件系统并挂载到/www目录。
# sudo mkfs.ext4 $device
# sudo mkdir -p /www
# sudo mount $device /www
# sleep 3

# # -------------------------------------------------------------------------------

# # 下载必要工具包到/www/wwwroot/data/目录。
# sudo yum install wget -y
# sudo yum install unzip -y
# sudo mkdir -p /www/wwwroot/data/
# cd /www/wwwroot/data/
# sudo wget https://www.addlink.lol/data/wp%E5%BF%85%E5%A4%87%E5%B7%A5%E5%85%B7.zip
# unzip wp必备工具.zip
# sleep 3
# sudo rm -rf /www/wwwroot/data/wp必备工具.zip

# sudo yum install dos2unix -y
# sleep 3
# dos2unix /www/wwwroot/data/wp必备工具/生成网站主脚本/app-生成网站sql文件.sh
# sleep 3
# dos2unix /www/wwwroot/data/wp必备工具/生成网站主脚本/add-导入数据库.sh
# sleep 5
# sudo cd /root

# # 安装python
# curl -s https://raw.githubusercontent.com/wonima136/google_seo/main/python3.9.sh | bash
# # 使环境变量生效（有时候需要，有时候不需要）
# source ~/.bash_profile
# sleep 5
# sudo cd /root

# # 安装宝塔面板
# sudo wget -O install.sh https://download.bt.cn/install/install_lts.sh
# sudo bash install.sh ed8484bec -y
# sleep 3
# ### 获取服务器全部可用IP
# curl -s https://raw.githubusercontent.com/wonima136/google_seo/main/huoqufujia_ip.sh | bash
