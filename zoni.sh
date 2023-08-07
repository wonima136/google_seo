#!/bin/bash
BLUE=$(tput setaf 4)
NORMAL=$(tput sgr0)

# 加入项目目录
cd /home/wwwroot/python

# 生成二级域名
# /usr/local/python39/bin/python3 /home/domain.py
# echo "${BLUE}生成二级域名完成${NORMAL}"

sleep 5

# 生成文章
/usr/local/python39/bin/python3 /home/wwwroot/python/content.py

echo "${BLUE}Markdown文件生成成功！${NORMAL}"
sleep 5


# 加入hugo
cd /home/wwwroot/hugo

# 生成静态文件
sudo hugo
# 重载nginx
sudo nginx -s reload
echo "${BLUE}网站搭建成功${NORMAL}"
echo "--------------------------------------------------"
echo "${BLUE}网站程序路径：/home/wwwroot/hugo${NORMAL}"
echo "${BLUE}MD文档路径：/home/wwwroot/hugo/content${NORMAL}"
echo "${BLUE}网站静态文件：/home/wwwroot/hugo/public${NORMAL}"
echo "${BLUE}生成后Markdown文档路径：/home/wwwroot/hugo/content${NORMAL}"
echo "${BLUE}生成的二级域名列表：/home/wwwroot/python/random_domains.txt${NORMAL}"
echo "${BLUE}顶级域名列表：/home/wwwroot/python/domains.txt${NORMAL}"
echo "${BLUE}网站生成的配置路径：/etc/nginx/conf.d${NORMAL}"
echo "${BLUE}生成二级域名和网站配置文件脚本：/home/wwwroot/python/conf.py${NORMAL}"
echo "${BLUE}生成Markdown文件脚本：/home/wwwroot/python/content.py${NORMAL}"
echo "${BLUE}网站被K导出流量列表(内容里面请使用完整的html,A标签)：/home/wwwroot/hugo/static/links.txt${NORMAL}"

