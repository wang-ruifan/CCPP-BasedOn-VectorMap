% filepath: /f:/CCPP-BasedOn-VectorMap/src/buildSpiralCoveragePath.m
function smooth_path = buildSpiralCoveragePath()
	% 参数设置
    d = 1;                % 每层偏移距离
    minArea = 5;            % 面积停止阈值
    max_seg_length = 1;     % 每个采样线段的最大长度为1
    curvature = 0.2;        % 曲率参数（统一设定，可随时调整）
    num_curve_pts = 10;     % 曲线上采样点数
    extended_gap = 1;  % 沿路径方向延长的距离
    tolerance_inner = 0.5;  % 内层边界去重容差

    % 调用生成螺旋路径函数得到路径
    spiral_path = spiral_path_generator(d, minArea, max_seg_length, curvature, num_curve_pts, extended_gap, tolerance_inner);
        
    % 平滑路径中的转角
    smooth_radius = 1;          % 平滑半径
    num_curve_pts = 10;           % 平滑曲线采样点数
    angle_threshold = pi/4;       % 转角阈值
    smooth_path = smoothCorners(spiral_path, smooth_radius, num_curve_pts, angle_threshold);
end
