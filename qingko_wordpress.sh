#!/bin/bash

# 定义 WordPress 网站的根目录
WP_ROOT="/www/wwwroot/wp-cms"

# 检查 WP-CLI 是否已安装
if ! command -v wp &> /dev/null; then
    echo "WP-CLI 未安装，正在安装..."

    cd /root
    # 下载 WP-CLI
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    
    # 授予执行权限
    chmod +x wp-cli.phar
    
    # 移动到系统路径
    sudo mv wp-cli.phar /usr/local/bin/wp

    # 再次检查 WP-CLI 是否成功安装
    if ! command -v wp &> /dev/null; then
        echo "WP-CLI 安装失败，请手动安装。"
        exit 1
    fi
    echo "WP-CLI 安装成功。"
fi

# 遍历 wp-cms 文件夹中的每个子文件夹
for site in "$WP_ROOT"/*; do
    if [ -d "$site" ]; then
        echo "正在处理站点：$site"

        # 确认该目录中存在 WordPress 安装
        if [ -f "$site/wp-config.php" ]; then
            # 获取文章 ID 列表
            POST_IDS=$(wp post list --post_type='post' --format=ids --path="$site" --allow-root)
            
            if [ -z "$POST_IDS" ]; then
                echo "没有找到任何文章，跳过 $site。"
                continue
            else
                echo "找到以下文章 ID：$POST_IDS"
            fi

            # 删除所有文章（文章类型为 'post'）
            wp post delete $POST_IDS --path="$site" --force --allow-root
            
            if [ $? -eq 0 ]; then
                echo "$site 的文章已成功删除。"
            else
                echo "删除 $site 的文章时出错。"
            fi
        else
            echo "$site 不是有效的 WordPress 站点，跳过。"
        fi
    fi
done
