import csv
import matplotlib.pyplot as plt
import os

def get_data_directory():
    current_dir = os.getcwd()
    if current_dir.endswith('src'):
        return '../data'
    else:
        return './data'

data_directory = get_data_directory()

# 读取 point.csv 文件
points = {}
with open(os.path.join(data_directory, 'point.csv'), 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        pid = int(row['PID'])
        bx = float(row['Bx'])
        ly = float(row['Ly'])
        points[pid] = (bx, ly)

# 读取 line.csv 文件
lines = {}
with open(os.path.join(data_directory, 'line.csv'), 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        lid = int(row['LID'])
        bpid = int(row['BPID'])
        fpid = int(row['FPID'])
        blid = int(row['BLID'])
        flid = int(row['FLID'])
        lines[lid] = (bpid, fpid, blid, flid)

# 读取 roadedge.csv 文件
road_edges = []
with open(os.path.join(data_directory, 'roadedge.csv'), 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        lid = int(row['LID'])
        road_edges.append(lid)

# 可视化 roadedge
plt.figure(figsize=(10, 10))
for lid in road_edges:
    if lid in lines:
        bpid, fpid, _, _ = lines[lid]
        if bpid in points and fpid in points:
            bx1, ly1 = points[bpid]
            bx2, ly2 = points[fpid]
            plt.plot([ly1, ly2], [bx1, bx2], 'b-')

plt.xlabel('Bx')
plt.ylabel('Ly')
plt.title('Road Edges Visualization')
plt.grid(True)
plt.axis('equal')
plt.show()