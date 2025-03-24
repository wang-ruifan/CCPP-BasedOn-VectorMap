# CCPP-BasedOn-VectorMap

本项目是一个基于 MATLAB 的覆盖式路径生成工具，用于生成覆盖式的高精地图车道路径，数据格式为 Autoware Vector Map。  
生成后的路径数据可用于 Unity 中的 Autoware MapToolbox 进行高精地图的可视化展示并可在Autoware中读取进行路径规划与导航使用。

## 上手指南

### 开发前的配置要求

- MATLAB 环境（R2024b 或更高版本）
- [MapToolbox_ForRoadSweeper](https://github.com/wang-ruifan/MapToolbox_ForRoadSweeper) 包（用于加载与生成 Autoware Vector Map 数据）
- Unity 2022.3.49f1 或更高版本  
- Windows 操作系统

### 使用步骤

1. 首先需要使用 Unity 并加载 Autoware MapToolbox包，加载点云数据并绘制Custom Area作为边界、lane作为初始车道，使用`Save Autoware ADASMMap to folder`保存到`data/`文件夹中。
2. 然后在 MATLAB 中执行 [src/main.m](src/main.m) 生成高精地图数据。
3. 之后在 Unity 中
4. 在 Unity 中，使用`Load Autoware ADASMap from folder`加载生成的高精地图数据。
5. 在ROS Autoware中读取地图数据进行路径规划与导航。

### 使用MATLAB Online
如果不需要修改初始的高精地图边界数据，可以直接使用MATLAB Online，使用Demo数据进行测试。  
[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=wang-ruifan/CCPP-BasedOn-VectorMap)

## 文件目录说明

- **.gitignore**：Git 忽略规则。
- **.vscode/**：包含调试配置文件（如 [launch.json](.vscode/launch.json)）。
- **data/**：存放 Autoware Vector Map 原始数据（CSV 文件），例如 `area.csv`、`point.csv` 等。
- **output/**：存放生成的高精地图数据（CSV 文件），例如 `lane.csv`、`node.csv` 等。
- **src/**：包含核心 MATLAB 源码
  - `main.m`：主入口脚本。
  - `readVectorMapData.m`：读取 CSV 数据。
  - `spiralPathGen.m`：生成螺旋路径。
  - `smoothCorners.m`：路径转角平滑处理。
  - 其他辅助函数。

## 软件架构

项目采用模块化设计，将数据读取、路径生成、平滑处理、数据保存等功能分成独立的脚本和函数。主要流程包括：

1. 数据读取（使用 `readVectorMapData.m`）
2. 边界与起始车道提取（使用 `getCustomArea`与`getInitialLaneSegment`）
3. 路径生成（使用 `spiralPathGen.m`）
4. 路径平滑（使用 `smoothCorners.m`）
5. 数据保存（使用 `saveSmoothPathToVectorMap.m`）

## 使用到的框架

- MATLAB：主要开发和运行环境
- Autoware：提供 Vector Map 数据格式
- Unity：高精地图的可视化与绘制平台
- Autoware MapToolbox：Unity 中用于加载和绘制高精地图数据的工具

## 作者

作者：Wang Ruifan  
邮箱：<wangruifan2003@qq.com>  
项目链接：[项目仓库链接](https://github.com/wang-ruifan/CCPP-BasedOn-VectorMap)
