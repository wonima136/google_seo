#!/bin/bash

# 安装依赖
yum -y install gcc

# 下载Python源码
wget https://www.python.org/ftp/python/3.9.10/Python-3.9.10.tgz

# 解压源码
tar -zxvf Python-3.9.10.tgz

# 进入源码目录
cd Python-3.9.10

# 配置、编译、安装
./configure --prefix=/usr/local/python39
make && make install

# 建立软连接
ln -s /usr/local/python39/bin/python3.9 /usr/bin/python3
ln -s /usr/local/python39/bin/pip3.9 /usr/bin/pip3

# PATH环境变量
export PATH="/usr/local/python39/bin:$PATH"

# 测试Python安装是否成功
python3 -V

# 删除源码文件
cd ..
rm -rf Python-3.9.10.tgz

# 创建版本文件
touch /root/version

# 开始下载程序跟脚本
sudo yum install -y wget && wget -qO- https://raw.githubusercontent.com/wonima136/google_seo/main/program_download.sh | bash

