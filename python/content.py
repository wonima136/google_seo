import mysql.connector
import datetime
import re
import random

# 连接到MySQL数据库
cnx = mysql.connector.connect(user='用户名', password='数据库密码', host='地址', database='数据库名')

# 创建游标对象
cursor = cnx.cursor()

# 生成Markdown文件内容列表
markdown_contents = []

for _ in range(1, 50):
    i = random.randint(1, 690000)
    # 执行查询
    query = f"SELECT title, description FROM search_result WHERE keyword_id = {i}"
    cursor.execute(query)
    # 读取查询结果
    results = cursor.fetchall()

    if len(results) >= 500:
        # 随机选择7-10条结果并乱序
        selected_results = random.sample(results, random.randint(300, 500))
        random.shuffle(selected_results)
    else:
        # 如果结果集不足10条，使用全部结果
        selected_results = results


    # # 随机选择7-10条结果并乱序
    # selected_results = random.sample(results, random.randint(8, 10))
    # random.shuffle(selected_results)

    # 一整篇文章
    content = ''
    for result in selected_results:
        title = result[0]
        description = result[1]
        pattern_tit = r"<\/?b>|\s|/"
        
        pattern_des = r"^(Web(?: \u00B7)?)|\s·\s+|\s+—\s+|\s*\"\s*|\bhttps?://\S+\b|(?:[A-Za-z]{3}\s\d{1,2},\s\d{4}| \u00B7\s{0,4}|\d+\s(?:minute|hour|day|week|month|year)s?\sago|\d{4}-\d{2}-\d{2} \d{2}:\d{2}\.\s{0,1}|\d{1,2}\s(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d{4}\s)|<\/?b>|\d{4}/\d{1,2}/\d{1,2}\."
        re_tit = re.sub(pattern_tit, "", title)
        re_des = re.sub(pattern_des, "", description)
        re_des = re_des.replace('"', "")
        # 判断 re_des 是否为空并且长度大于等于10个字符
        if re_des and len(re_des) >= 10:
            content += re_des

    query = f"SELECT key_words FROM key_words WHERE id = {i}"
    cursor.execute(query)

    # 提取查询结果
    result = cursor.fetchone()

    # 提取标题
    title = ''
    while result:
        title = result[0]
        result = cursor.fetchone()

    pattern = r"<\/?b>|\s|,|/"
    title = re.sub(pattern, "", title)

    # 系统时间
    thetime = datetime.datetime.now()
    formatted_time = thetime.strftime('%Y-%m-%dT%H:%M:%S%z+08:00')

    contents = f"""---
title: "{title}" 
---

{content}
"""
    if content:
        markdown_contents.append((title, contents))

# 关闭游标对象
cursor.close()

# 关闭连接
cnx.close()

with open('/home/wwwroot/python/random_domains.txt', 'r', encoding='utf-8') as domain_file:
    file_names = [line.strip() for line in domain_file]

# 直接在content目录下保存Markdown文件
for i, (title, markdown_content) in enumerate(markdown_contents):
    file_name = file_names[i]
    file_path = '/home/wwwroot/hugo/content/' + file_name + '.md'
    with open(file_path, "w", encoding="utf-8") as file:
        file.write(markdown_content)

print("它来了它来了它带着蜘蛛爬来了......Markdown文件生成成功！")
