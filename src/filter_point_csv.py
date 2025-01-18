import csv
import os

def get_data_directory():
    current_dir = os.getcwd()
    if current_dir.endswith('src'):
        return '../data'
    else:
        return './data'

data_directory = get_data_directory()

# 读取 line.csv 文件中的 BPID 和 FPID
bpid_fpid_set = set()
with open(os.path.join(data_directory, 'line.csv'), 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        bpid_fpid_set.add(int(row['BPID']))
        bpid_fpid_set.add(int(row['FPID']))

# 读取 point_raw.csv 文件并过滤
filtered_points = []
with open(os.path.join(data_directory, 'point_raw.csv'), 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        pid = int(row['PID'])
        if pid in bpid_fpid_set:
            filtered_points.append(row)

# 写入过滤后的数据到 point.csv
with open(os.path.join(data_directory, 'point.csv'), 'w', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=['PID', 'B', 'L', 'H', 'Bx', 'Ly', 'ReF', 'MCODE1', 'MCODE2', 'MCODE3'])
    writer.writeheader()
    writer.writerows(filtered_points)

print("过滤后的文件已生成：point.csv")