#!/bin/bash

# 检查root权限
if [ "$(id -u)" != "0" ]; then
    echo "请使用root用户运行此脚本"
    exit 1
fi

# 安装Go
yum -y install golang
go version

# 创建Hugo仓库配置
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

# 安装Hugo
yum -y install hugo
hugo version

echo "安装完成！"
