#!/bin/bash

# 检查root权限
if [ "$(id -u)" != "0" ]; then
    echo "请使用root用户运行此脚本"
    exit 1
fi

# 函数：执行命令并检查结果
execute_command() {
    if ! $1; then
        echo "执行失败: $1"
        exit 1
    fi
}

# 1. 安装基础软件
yum -y install golang wget unzip dos2unix
go version

# 2. 创建Hugo仓库配置并安装
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
execute_command "curl -O http://mirror-sv.raksmart.com/pull_mirror_file.sh && bash pull_mirror_file.sh <<< 'y'"

# 4. 磁盘处理
umount /home 2>/dev/null || true
device=$(lsblk -nrdo NAME,TYPE,SIZE | grep disk | sort -rk 3,3 | head -n 1 | awk '{print "/dev/" $1}')
if [ -n "$device" ]; then
    mkfs.ext4 $device
    mkdir -p /www
    mount $device /www
fi

# 5. 创建目录
mkdir -p /www/wwwroot/data/
cd /www/wwwroot/data/

# 6. 安装Python 3.9
cd /root
execute_command "curl -s https://raw.githubusercontent.com/wonima136/google_seo/main/python3.9.sh | bash"
source ~/.bash_profile

# 7. 安装宝塔面板
cd /root
wget -O install.sh https://download.bt.cn/install/install_lts.sh
bash install.sh ed8484bec -y

# 8. 获取服务器IP
execute_command "curl -s https://raw.githubusercontent.com/wonima136/google_seo/main/huoqufujia_ip.sh | bash"

echo "安装完成！"
