#!/bin/bash
# 网站log配置：access_log /www/wwwlogs/tongji/2024-05-23/$host.log;
# 获取当前日期
current_date=$(date +%Y-%m-%d)

# 检查当天日期文件夹是否存在
if [ -d "/www/wwwlogs/tongji/${current_date}" ]; then
    echo "当天日期文件夹已存在，跳过创建"
else
    # 遍历所有.conf文件并替换access_log和error_log字段
    for conf_file in /www/server/panel/vhost/nginx/*.conf; do
        # 替换 access_log
        sed -Ei "s|(access_log\s+/www/wwwlogs/tongji/)[0-9]{4}-[0-9]{2}-[0-9]{2}(/[^;]+;)|\1${current_date}\2|" "$conf_file"
        # 替换 error_log
        sed -Ei "s|(error_log\s+/www/wwwlogs/tongji/)[0-9]{4}-[0-9]{2}-[0-9]{2}(/[^;]+;)|\1${current_date}\2|" "$conf_file"
    done

    # 创建日志日期文件夹
    sudo mkdir /www/wwwlogs/tongji/${current_date}

    # 等待10秒
    sleep 3

    # 递归更改文件夹及其子文件夹和文件的权限为777
    sudo chmod -R 777 /www/wwwlogs/tongji/*

    # 等待10秒
    sleep 3

    # 重载nginx
    sudo nginx -s reload

    echo "当天日期文件夹已成功创建"
fi
