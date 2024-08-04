#!/bin/bash

# 卸载挂载在/home的文件系统。
sudo umount /home  # 如果已经卸载，则会显示：umount: /home: not mounted

# 自动查找系统中最大的磁盘设备。
device=$(lsblk -nrdo NAME,TYPE,SIZE | sort -rk 3,3 | head -n 1 | awk '{print "/dev/" $1}')

# 创建ext4文件系统并挂载到/www目录。
sudo mkfs.ext4 $device
sudo mkdir -p /www
sudo mount $device /www

# 下载必要工具包到/www/wwwroot/data/目录。
sudo yum install wget -y
sudo yum install unzip -y
sudo mkdir -p /www/wwwroot/data/
cd /www/wwwroot/data/
sudo wget https://www.addlink.lol/data/wp%E5%BF%85%E5%A4%87%E5%B7%A5%E5%85%B7.zip
unzip wp必备工具.zip
sudo rm -rf /www/wwwroot/data/wp必备工具.zip

# 安装宝塔面板
sudo cd /root
sudo wget -O install.sh https://download.bt.cn/install/install_lts.sh
sudo bash install.sh ed8484bec -y
