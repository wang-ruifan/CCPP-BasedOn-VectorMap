import csv
import os

# 打印当前工作目录
print("当前工作目录:", os.getcwd())

def get_data_directory():
    current_dir = os.getcwd()
    if current_dir.endswith('src'):
        return '../data'
    else:
        return './data'

data_directory = get_data_directory()

# 手动设定矩形边界的参数
length = 200  # 矩形的长度
width = 50    # 矩形的宽度
center_x = 20  # 矩形中心点相对于地图原点的 x 偏移
center_y = 10  # 矩形中心点相对于地图原点的 y 偏移
height = 0.5    # 所有线的高度

# 计算矩形的四个顶点
half_length = length / 2
half_width = width / 2

points = [
    (center_x - half_length, center_y - half_width),
    (center_x + half_length, center_y - half_width),
    (center_x + half_length, center_y + half_width),
    (center_x - half_length, center_y + half_width)
]

# 生成 point.csv 的内容
point_rows = []
for i, (bx, ly) in enumerate(points, start=1):
    point_rows.append([i, 0, 0, height, bx, ly, 0, 0, 0, 0])

# 生成 line.csv 的内容
line_rows = []
for i in range(1, 5):
    bpid = i
    fpid = i % 4 + 1
    line_rows.append([i, bpid, fpid, 0, 0])

# 生成 roadedge.csv 的内容
roadedge_rows = []
for i in range(1, 5):
    roadedge_rows.append([i, i, 0])

# 确保 data 目录存在
os.makedirs(data_directory, exist_ok=True)

# 写入 point.csv 文件
with open(os.path.join(data_directory, 'point.csv'), 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['PID', 'B', 'L', 'H', 'Bx', 'Ly', 'ReF', 'MCODE1', 'MCODE2', 'MCODE3'])
    writer.writerows(point_rows)

# 写入 line.csv 文件
with open(os.path.join(data_directory, 'line.csv'), 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['LID', 'BPID', 'FPID', 'BLID', 'FLID'])
    writer.writerows(line_rows)

# 写入 roadedge.csv 文件
with open(os.path.join(data_directory, 'roadedge.csv'), 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['ID', 'LID', 'LinkID'])
    writer.writerows(roadedge_rows)

print("文件已生成：point.csv, line.csv, roadedge.csv")