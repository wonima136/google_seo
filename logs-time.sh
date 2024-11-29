#!/bin/bash
# 获取当前日期
current_date=$(date +%Y-%m-%d)

# 检查父文件夹是否存在，如果不存在则创建
if [ ! -d "/www/wwwlogs/tongji" ]; then
    sudo mkdir -p /www/wwwlogs/tongji
fi

# 更新 log.log.conf 文件中的日期
if [ -f "/www/server/panel/vhost/nginx/log.log.conf" ]; then
    echo "找到 log.log.conf 文件，开始更新日期..."
    sed -i "s|root /www/wwwlogs/tongji/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}|root /www/wwwlogs/tongji/${current_date}|" "/www/server/panel/vhost/nginx/log.log.conf"
else
    echo "未找到 log.log.conf 文件，跳过更新"
fi

# 检查当天日期文件夹是否存在
if [ -d "/www/wwwlogs/tongji/${current_date}" ]; then
    echo "当天日期文件夹已存在，检查配置文件日期..."
    
    # 检查所有配置文件中的日期
    need_reload=false
    for conf_file in /www/server/panel/vhost/nginx/*.conf; do
        # 检查文件中是否存在旧日期
        if grep -q "tongji/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}" "$conf_file"; then
            old_date=$(grep -o "tongji/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}" "$conf_file" | head -1 | cut -d'/' -f2)
            if [ "$old_date" != "$current_date" ]; then
                # 替换 access_log
                sed -Ei "s|(access_log\s+/www/wwwlogs/tongji/)[0-9]{4}-[0-9]{2}-[0-9]{2}(/[^;]+;)|\1${current_date}\2|" "$conf_file"
                # 替换 error_log
                sed -Ei "s|(error_log\s+/www/wwwlogs/tongji/)[0-9]{4}-[0-9]{2}-[0-9]{2}(/[^;]+;)|\1${current_date}\2|" "$conf_file"
                need_reload=true
            fi
        fi
    done

    # 如果有配置文件被更新，则重载nginx
    if [ "$need_reload" = true ]; then
        echo "配置文件已更新，重载nginx..."
        sleep 3
        sudo nginx -s reload
    else
        echo "所有配置文件日期均为最新"
    fi
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

    # 等待3秒
    sleep 3

    # 递归更改文件夹及其子文件夹和文件的权限为777
    sudo chmod -R 777 /www/wwwlogs/tongji/*

    # 等待3秒
    sleep 3

    # 重载nginx
    sudo nginx -s reload

    echo "当天日期文件夹已成功创建"
fi
