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
    sudo apt-get install -y wget tar zlib1g-dev libbz2-dev libssl-dev libncurses5-dev libsqlite3-dev libreadline-dev tk-dev gcc make
elif [ "$OS" == "CentOS Linux" ]; then
    sudo yum install -y wget tar zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make
else
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

# 安装screen
if [ "$OS" == "Ubuntu" ]; then
    sudo apt-get install -y screen
elif [ "$OS" == "CentOS Linux" ]; then
    sudo yum install -y epel-release
    sudo yum install -y screen
fi

# 找到当前python3的路径
python3_path=$(which python3)

# 创建新的符号链接
sudo ln -sf /usr/local/Python39/bin/python3 $python3_path

# 检查python3现在是否指向新安装的Python 3.9.8
python3 --version
