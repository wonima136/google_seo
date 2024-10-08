# ip白名单定时器-2分钟刷新一次
#!/bin/bash

# 从提供的URL获取IP，并保存到文件中，并添加 "allow" 前缀和 ";" 后缀
curl https://www.addlink.lol/data/ahrefs_ip.txt | awk '{print "allow " $1 ";"}' > /www/googlebot_ips/ahrefs_ip.txt

# 将文件权限设置为777
chmod 777 /www/googlebot_ips/*

#重载nginx
/etc/init.d/nginx reload
