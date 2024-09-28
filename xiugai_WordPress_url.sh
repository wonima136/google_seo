#!/bin/bash

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
      
      # 强制刷新重写规则
      wp --path="$site" rewrite flush --hard --allow-root
      
      echo "站点 $site 的固定链接结构已更新并刷新 URL 规则"

      # 创建或更新 .htaccess 文件
      HTACCESS_FILE="$site/.htaccess"
      cat <<EOL > "$HTACCESS_FILE"
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
EOL

      echo "已在 $site 目录中创建或更新 .htaccess 文件"
    else
      echo "站点 $site 不是有效的 WordPress 安装"
    fi
  fi
done
