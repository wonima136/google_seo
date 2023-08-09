import os

# 第二段代码
# {domain_1} 用于调用，完整域名
# {domain_2} 用于调用，顶级域名
kkk = '''
server
{
    listen 80;
    server_name {domain_1};
    index index.html;
    root /home/wwwroot/hugo/public/{domain_1};
    access_log  /home/wwwroot/tongji/{domain_2}.log;
}
########################################################################
'''

# 读取指定文件夹下的所有 .md 文件的文件名
folder_path = "/home/wwwroot/hugo/content/"
md_files = [file for file in os.listdir(folder_path) if file.endswith(".md")]

result = ''
for file_name in md_files:
    domain_1 = file_name.split(".md")[0]
    domain_2 = domain_1.split(".")[1]
    k1 = kkk.replace("{domain_1}", domain_1)
    k1 = k1.replace("{domain_2}", domain_2)
    result += k1

# 将结果写入文件
with open("/etc/nginx/conf.d/hugo.conf", "w", encoding="utf-8") as file:
    file.write(result)
