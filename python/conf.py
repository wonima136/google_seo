import random
import string

def generate_subdomain(length=5):
    characters = string.ascii_lowercase + string.digits
    subdomain = ''.join(random.choice(characters) for _ in range(length))
    return subdomain

def generate_domain(top_domain):
    subdomain = generate_subdomain()
    domain = f"{subdomain}.{top_domain}"
    return domain

def generate_random_domains_for_each_top_domain(num_domains, top_domains):
    all_domains = set()
    for top_domain in top_domains:
        domains = set()  # 使用set来存储对每个顶级域名生成的唯一二级域名
        while len(domains) < num_domains:
            domain = generate_domain(top_domain)
            domains.add(domain)
        all_domains.update(domains)  # 将这些二级域名添加到总集合中
    return all_domains

# 从domain.txt读取所有顶级域名
with open("/home/domains.txt", "r") as file:
    top_domains = [line.strip() for line in file.readlines()]

num_domains = 2000
random_domains = generate_random_domains_for_each_top_domain(num_domains, top_domains)

with open("/home/random_domains.txt", "w") as file:
    for domain in random_domains:
        file.write(domain + "\n")

print("随机生成的二级域名已保存在random_domains.txt中")

# 第二段代码

kkk = '''
server
{
    listen 80;
    server_name example.com;
    index index.html;
    root /home/hugo/public/example.com;
    access_log  /home/hugo/public/example.com/example.com.log;
}
######################################################################## # 多个配置文件分割符号
'''

# 从 "random_domains.txt" 中读取域名，而不是从 "conf.txt"
with open("/home/hugo/random_domains.txt", "r", encoding="utf-8") as file:
    domains = file.readlines()

result = ''
for domain in domains:
    domain = domain.strip()  # 删除尾部的换行符
    k1 = kkk.replace("example.com", domain)
    result += k1

# 将结果写入文件
with open("/etc/nginx/conf.d/hugo.conf", "w", encoding="utf-8") as file:
    file.write(result)
