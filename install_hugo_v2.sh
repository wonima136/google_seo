#!/bin/bash

# 开启错误检测，遇到错误时立即退出
set -e

# 定义日志文件
LOG_FILE="/var/log/hugo_install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Hugo 安装开始于 $(date)"

# 检查root权限
if [ "$(id -u)" != "0" ]; then
    echo "请使用root用户运行此脚本"
    exit 1
fi

# 安装基础软件
echo "安装基础软件..."
yum -y install golang wget unzip dos2unix
go version

# 创建Hugo仓库配置并安装
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

echo "Hugo 安装完成于 $(date)！"
