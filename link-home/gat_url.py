import os
import requests
import random

# 获取当前脚本的路径
base_dir = os.path.dirname(os.path.realpath(__file__))

links = []

# 使用 os.path.join 来构建文件路径
with open(os.path.join(base_dir, 'urls.txt'), 'r', encoding='utf-8') as f:
    urls = f.readlines()

for url in urls:
    url = url.strip()

    try:
        response = requests.get(url)

        if response.status_code == 200:
            lines = response.text.strip().split('<br />')
            
            for line in lines:
                try:
                    return_url, link_text = line.split('******', 1)
                    link = f'<a href="{return_url.strip()}" title="{link_text.strip()}">{link_text.strip()}</a>\n'
                    links.append(link)
                except ValueError:
                    continue  # 如果此行无法拆分，跳过此行并处理下一行
    except requests.exceptions.RequestException as e:
        print(f"处理链接 {url} 时发生错误，错误信息：{e}")

random.shuffle(links)

# 使用 os.path.join 来构建文件路径
with open(os.path.join(base_dir, 'links.txt'), 'w', encoding='utf-8') as f:
    f.writelines(links)
