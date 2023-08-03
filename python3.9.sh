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

clear

echo "查询nginx是否运行"
# 查询nginx是否运行
systemctl status nginx
echo "------------------------------------------------"

# 查看nginx版本
echo "nginx当前版本"
nginx -v
echo "------------------------------------------------"

# 查看python版本
echo "python当前版本"
python3 --version
echo "------------------------------------------------"

# 显示Hugo版本
echo "Hugo当前版本"
hugo version
echo "------------------------------------------------"

echo "查看nginx配置"
cat /root/nginx_config.txt
echo "------------------------------------------------"

echo "关于python安装完成出现的错误可以忽略他"
