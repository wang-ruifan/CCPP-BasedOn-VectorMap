%% 参数设置
% 设置参数结构体
params = struct();

% 螺旋路径参数
params.spiral = struct(...
    'd', 1, ...                  % 每层偏移距离
    'minArea', 5, ...           % 面积停止阈值
    'maxSegLength', 1, ...      % 每个采样线段的最大长度
    'curvature', 0.2, ...       % 曲率参数
    'numCurvePts', 10, ...      % 曲线上采样点数
    'extendedGap', 1);          % 沿路径方向延长的距离

% 平滑路径参数
params.smooth = struct(...
    'radius', 1, ...            % 平滑半径
    'numCurvePts', 10, ...      % 平滑曲线采样点数
    'angleThreshold', pi/4);    % 转角阈值

%% 读取地图数据
mapData = readVectorMapData();

%% 获取区域边界点与初始车道
boundary_points = getCustomArea(mapData);

[laneStartPt, laneEndPt] = getInitialLaneSegment(mapData);
lanePt = [laneStartPt; laneEndPt];

%% 生成用S曲线平滑连接的螺旋路径
% 使用S曲线连接
spiral_path = spiralPathGen(params.spiral, boundary_points, true, mapData);

%% 平滑路径中的转角
smooth_path = smoothCorners(spiral_path, params.smooth);
plotSpiralPath(smooth_path, boundary_points, lanePt, '平滑的覆盖式螺旋路径');

%% 将路径保存到VectorMap中
saveSmoothPathToVectorMap(smooth_path, mapData);
