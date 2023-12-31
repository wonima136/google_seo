#!/bin/bash

# 安装Go
# yum install -y golang


# 添加Hugo的yum源文件
# cat << EOF > /etc/yum.repos.d/hugo.repo
# [daftaupe-hugo]
# name=Copr repo for hugo owned by daftaupe
# baseurl=https://copr-be.cloud.fedoraproject.org/results/daftaupe/hugo/epel-7-\$basearch/
# type=rpm-md
# skip_if_unavailable=True
# gpgcheck=1
# gpgkey=https://copr-be.cloud.fedoraproject.org/results/daftaupe/hugo/pubkey.gpg
# repo_gpgcheck=0
# enabled=1
# EOF

# 安装Hugo
sudo yum reinstall hugo -y


# 开始安装python3.9
echo "hugo安装完成，现在开始安装python3.9"
sleep 5
cd /root
yum install -y wget && wget -qO- https://raw.githubusercontent.com/wonima136/google_seo/main/python3.9.sh | bash
