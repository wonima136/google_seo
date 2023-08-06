import os

txt_file = '/home/hugo/public/dir.txt'

def replace_googleid(path, googleid):
    file_path = os.path.join(path, 'index.html')
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    new_content = content.replace("#@#googleid#@#", googleid)
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(new_content)

with open(txt_file, 'r', encoding='utf-8') as file:
    lines = file.readlines()

for line in lines:
    line = line.strip()
    path, googleid = line.split('@')
    replace_googleid(path, googleid)
