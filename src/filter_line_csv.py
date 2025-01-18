import csv
import os

def get_data_directory():
    current_dir = os.getcwd()
    if current_dir.endswith('src'):
        return '../data'
    else:
        return './data'

data_directory = get_data_directory()

# 读取 roadedge.csv 文件中的 LID
roadedge_lids = set()
with open(os.path.join(data_directory, 'roadedge.csv'), 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        lid = int(row['LID'])
        roadedge_lids.add(lid)

# 读取 line_raw.csv 文件并过滤
filtered_lines = []
with open(os.path.join(data_directory, 'line_raw.csv'), 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        lid = int(row['LID'])
        if lid in roadedge_lids:
            filtered_lines.append(row)

# 写入过滤后的数据到 line.csv
with open(os.path.join(data_directory, 'line.csv'), 'w', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=['LID', 'BPID', 'FPID', 'BLID', 'FLID'])
    writer.writeheader()
    writer.writerows(filtered_lines)

print("过滤后的文件已生成：line.csv")