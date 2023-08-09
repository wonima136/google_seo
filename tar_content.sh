#!/bin/bash

cd /www/wwwroot/google_seo
sleep 5
tar -czvf content.tar.gz content/*

echo "压缩content成功"
echo "使用以下命令到上站服务器，hogo根目录下使用"
echo "yum install -y wget && wget http://137.220.133.133/content.tar.gz && tar -xzvf content.tar.gz"
