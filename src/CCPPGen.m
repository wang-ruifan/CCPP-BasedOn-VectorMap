%% 参数设置
% 螺旋路径参数
d = 1;                	% 每层偏移距离
minArea = 5;            % 面积停止阈值
max_seg_length = 1;     % 每个采样线段的最大长度为1
curvature = 0.2;        % 曲率参数
num_curve_pts = 10;     % 曲线上采样点数
extended_gap = 1;  		% 沿路径方向延长的距离

% 平滑路径参数
smooth_radius = 1;          % 平滑半径
num_smooth_curve_pts = 10;           % 平滑曲线采样点数
angle_threshold = pi/4;       % 转角阈值

%% 生成螺旋路径
usw_s_curve = false;  	% 是否使用S曲线连接
% 调用生成螺旋路径函数得到路径
spiral_path = spiral_path_generator(d, minArea, max_seg_length, curvature, num_curve_pts, extended_gap, usw_s_curve);

% 打印螺旋路径
plotSpiralPath(spiral_path);

%% 生成用S曲线平滑连接的螺旋路径
usw_s_curve = true;  	% 是否使用S曲线连接
% 调用生成螺旋路径函数得到路径
spiral_path = spiral_path_generator(d, minArea, max_seg_length, curvature, num_curve_pts, extended_gap, usw_s_curve);

% 打印螺旋路径
plotSpiralPath(spiral_path);

%% 平滑路径中的转角
% 调用平滑转角函数得到平滑路径
smooth_path = smoothCorners(spiral_path, smooth_radius, num_smooth_curve_pts, angle_threshold);

% 打印平滑路径
plotSpiralPath(smooth_path);

%% 将路径保存到VectorMap中
% 调用保存路径到VectorMap函数
saveSmoothPathToVectorMap(smooth_path);

