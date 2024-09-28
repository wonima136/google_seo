#!/bin/bash

# 检查是否已安装 wp-cli
if ! command -v wp &> /dev/null; then
    echo "wp-cli 未安装，正在下载安装..."

    # 下载 wp-cli.phar
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

    # 为 wp-cli.phar 添加可执行权限
    chmod +x wp-cli.phar

    # 将 wp-cli.phar 移动到系统的可执行路径中
    mv wp-cli.phar /usr/local/bin/wp

    # 检查安装是否成功
    if command -v wp &> /dev/null; then
        echo "wp-cli 安装成功！"
    else
        echo "wp-cli 安装失败，请手动检查。"
        exit 1
    fi
else
    echo "wp-cli 已安装"
fi

# 设置 WordPress 网站的主目录
WP_ROOT="/www/wwwroot/wp-cms"

# 遍历所有子文件夹
for site in "$WP_ROOT"/*; do
  if [ -d "$site" ]; then
    echo "处理站点: $site"
    
    # 检查当前目录是否为有效的 WordPress 安装
    if wp --path="$site" core is-installed --allow-root; then
      # 设置固定链接结构为 /%postname%/
      wp --path="$site" option update permalink_structure "/%postname%/" --allow-root
      
      # 刷新 URL 规则
      wp --path="$site" rewrite flush --allow-root
      
      echo "站点 $site 的固定链接结构已更新并刷新 URL 规则"
    else
      echo "站点 $site 不是有效的 WordPress 安装"
    fi
  fi
done
