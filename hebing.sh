### 每台服务器只要开启ip拦截的必须创建任务计划2分钟运行一次
bash <(curl -s https://raw.githubusercontent.com/wonima136/google_seo/main/updata_ip.sh)


sleep 5

### 谷歌爬虫IP白名单，一天运行一次
bash <(curl -s https://raw.githubusercontent.com/wonima136/google_seo/main/google_bot_ip.sh)
