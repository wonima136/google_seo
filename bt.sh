#!/bin/bash

# 更新yum源
curl -O http://mirror-sv.raksmart.com/pull_mirror_file.sh && bash pull_mirror_file.sh <<< "y"

# 卸载挂载在/home的文件系统。
sudo umount /home  # 如果已经卸载，则会显示：umount: /home: not mounted

# 自动查找系统中最大的磁盘设备。
device=$(lsblk -nrdo NAME,TYPE,SIZE | sort -rk 3,3 | head -n 1 | awk '{print "/dev/" $1}')

# 创建ext4文件系统并挂载到/www目录。
sudo mkfs.ext4 $device
sudo mkdir -p /www
sudo mount $device /www


sudo cd /root

# 安装python
curl -s https://raw.githubusercontent.com/wonima136/google_seo/main/python3.9.sh | bash
# 使环境变量生效（有时候需要，有时候不需要）
source ~/.bash_profile

sudo cd /root

# 安装宝塔面板
sudo wget -O install.sh https://download.bt.cn/install/install_lts.sh
sudo bash install.sh ed8484bec -y

### 获取服务器全部可用IP
curl -s https://raw.githubusercontent.com/wonima136/google_seo/main/huoqufujia_ip.sh | bash
