#!/bin/bash
# 安装expect 工具
yum install expect -y

# 1. 安装VPN的依赖库
yum -y install gcc zlib-devel openssl-devel readline-devel ncurses-devel

# 2. 安装下载程序
yum install wget -y

# 3. 下载SoftEther VPN Server
wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.31-9727-beta/softether-vpnserver-v4.31-9727-beta-2019.11.18-linux-x64-64bit.tar.gz

# 4. 解压下载的文件
tar zxf softether-vpnserver-v4.31-9727-beta-2019.11.18-linux-x64-64bit.tar.gz

# 5. 进入解压目录
cd vpnserver

# 6. 安装软件（直接make 即可）
# 这里使用 expect 执行交互式命令，3次选择都是1
expect << EOF
    spawn make
    expect "1"
    send "1\r"
    expect "1"
    send "1\r"
    expect "1"
    send "1\r"
    expect eof
EOF

# 7. 启动它
./vpnserver start

# 8. 设置管理员ip跟端口账号密码
# 这里也是交互式命令，第一次选择1，第二次输入127.0.0.1:443，第三次留空
expect << EOF
    spawn ./vpncmd
    expect "1"
    send "1\r"
    expect "Hostname of IP Address of Destination:"
    send "127.0.0.1:443\r"
    expect "Username:"
    send "\r"
    expect eof
EOF

