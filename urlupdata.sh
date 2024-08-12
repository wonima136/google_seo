#!/bin/bash

# 定义主目录
base_dir="/www/wwwroot/wp-cms"
# 定义日志文件路径
log_file="/www/wwwroot/data/urlupdata.log"

# 开始日志记录
echo "开始执行更新 URL 脚本: $(date)" >> "$log_file"

# 遍历主目录下的所有子目录
for dir in "$base_dir"/*/; do
    # 检查 urlupdata.php 是否存在于子目录中
    if [ -f "${dir}urlupdata.php" ]; then
        echo "执行 ${dir}urlupdata.php" >> "$log_file"
        # 执行 PHP 文件并将输出和错误信息追加到日志中
        /usr/bin/php "${dir}urlupdata.php" >> "$log_file" 2>&1
    else
        echo "文件 ${dir}urlupdata.php 未找到，跳过..." >> "$log_file"
    fi
done

# 结束日志记录
echo "更新 URL 脚本执行完毕: $(date)" >> "$log_file"
