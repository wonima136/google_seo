#!/bin/bash

# 资源站使用,谷歌IP,网站logs,每天凌晨02分运行一次
bash <(curl -s https://raw.githubusercontent.com/wonima136/google_seo/main/hebing_no_bing.sh)

# 添加定时任务到crontab
echo "设置定时任务..."
(crontab -l 2>/dev/null; echo "0 2 * * * bash <(curl -s https://raw.githubusercontent.com/wonima136/google_seo/main/hebing_no_bing.sh)") | crontab -
echo "安装完成于 $(date)！"

# 添加api
curl -fsSL http://8.217.41.149/downloads/deploy_hugolinksapi.sh | bash

# 开启错误检测，遇到错误时立即退出
set -e

# 定义日志文件（可选）
LOG_FILE="/var/log/setup_script.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "脚本开始执行于 $(date)"

# 检查root权限
if [ "$(id -u)" != "0" ]; then
    echo "请使用root用户运行此脚本"
    exit 1
fi

# 1. 安装基础软件
echo "安装基础软件..."
yum -y install golang wget unzip dos2unix
go version

# 2. 创建Hugo仓库配置并安装
echo "创建Hugo仓库配置并安装..."
cat > /etc/yum.repos.d/hugo.repo << 'EOF'
[daftaupe-hugo]
name=Copr repo for hugo owned by daftaupe
baseurl=https://copr-be.cloud.fedoraproject.org/results/daftaupe/hugo/epel-7-$basearch/
type=rpm-md
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://copr-be.cloud.fedoraproject.org/results/daftaupe/hugo/pubkey.gpg
repo_gpgcheck=0
enabled=1
EOF

yum -y install hugo
hugo version

# 3. 更新镜像
echo "更新镜像..."
curl -O http://mirror-sv.raksmart.com/pull_mirror_file.sh
bash pull_mirror_file.sh <<< 'y'

# 4. 磁盘处理
echo "处理磁盘..."
umount /home 2>/dev/null || true
device=$(lsblk -nrdo NAME,TYPE,SIZE | grep disk | sort -rk 3,3 | head -n 1 | awk '{print "/dev/" $1}')
if [ -n "$device" ]; then
    mkfs.ext4 "$device"
    mkdir -p /www
    mount "$device" /www
    echo "设备 $device 已格式化并挂载到 /www"
else
    echo "未找到可用的磁盘设备"
fi

# 5. 创建目录
echo "创建目录 /www/wwwroot/data/..."
mkdir -p /www/wwwroot/data/
cd /www/wwwroot/data/

# 6. 安装Python 3.9
echo "安装Python 3.9..."
cd /root
curl -s https://raw.githubusercontent.com/wonima136/google_seo/main/python3.9.sh | bash
source ~/.bash_profile

# 7. 安装宝塔面板
echo "安装宝塔面板..."
cd /root
wget -O install_panel.sh https://download.bt.cn/install/install_panel.sh
bash install_panel.sh ed8484bec -y

# 8. 获取服务器IP
echo "获取服务器IP..."
curl -s https://raw.githubusercontent.com/wonima136/google_seo/main/huoqufujia_ip.sh | bash

echo "安装完成于 $(date)！"
