#!/bin/bash

# 确定Linux发行版
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -si)
else
    OS=$(uname -s)
fi

# 根据不同的发行版，执行不同的命令安装必要的包
if [ "$OS" == "Ubuntu" ]; then
    sudo apt-get update
    # 安装wget和tar以及其他必要的包
    sudo apt-get install -y wget tar zlib1g-dev libbz2-dev libssl-dev libncurses5-dev libsqlite3-dev libreadline-dev tk-dev gcc make
elif [ "$OS" == "CentOS Linux" ]; then
    # 安装wget和tar以及其他必要的包
    sudo yum install -y wget tar zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make
else
    # 如果不是Ubuntu或CentOS，输出错误信息并退出
    echo "不支持的操作系统，退出"
    exit 1
fi

# 下载Python源码
wget https://www.python.org/ftp/python/3.9.8/Python-3.9.8.tgz
tar -xvf Python-3.9.8.tgz
cd Python-3.9.8

# 编译和安装Python
./configure --prefix=/usr/local/Python39 --with-ssl
make && sudo make install

# 设置环境变量
echo 'export PATH=/usr/local/Python39/bin:$PATH' >> ~/.bash_profile
echo 'export PYTHON_HOME=/usr/local/Python39' >> ~/.bash_profile
echo 'export PATH=$PYTHON_HOME/bin:$PATH' >> ~/.bash_profile

# 使环境变量生效
source ~/.bash_profile

# 显示新安装的Python版本
/usr/local/Python39/bin/python3 --version
