% filepath: /CCPP-BasedOn-VectorMap/src/spiralPathGen.m
function spiral_path = spiralPathGen(params, boundary_points, use_s_curve, mapData)
    % 从参数结构体中获取参数
    d = params.d;
    minArea = params.minArea;
    max_seg_length = params.maxSegLength;
    curvature = params.curvature;
    num_curve_pts = params.numCurvePts;
    extended_gap = params.extendedGap;

    % 读取自定义区域边界点，并构造多边形
    poly_orig = polyshape(boundary_points(:,1), boundary_points(:,2));

    % 第一次负偏移，避免最外层与原边界重合
    poly_offset = polybuffer(poly_orig, -d, 'JointType', 'miter', 'MiterLimit', 2);
    if isempty(poly_offset.Vertices) || poly_offset.area < 1e-2
        error('第一次负偏移失败，请检查偏移距离 d 是否过大。');
    end

    % 如果偏移结果有多个区域，选择面积最大的区域
    if poly_offset.NumRegions > 1
        regions = poly_offset.Regions;
        areas = cellfun(@(ps) polyarea(ps(:,1), ps(:,2)), regions);
        [~, idx] = max(areas);
        ps = regions{idx};
        poly_offset = polyshape(ps(:,1), ps(:,2));
    end

    poly_current = poly_offset; % 初始区域为第一次偏移结果
    % 均匀采样外层轮廓（修改采样方式：最大采样线段长度为 max_seg_length）
    outer_pts = samplePolyBoundary(poly_current, max_seg_length);

    % 从 mapData 中获取 lane.csv, node.csv, point.csv 数据
    laneTable = mapData.lane;
    nodeTable = mapData.node;
    pointTable = mapData.point;

    % 选取 lane.csv 最后一行，并获取其终点 FNID
    fnid = laneTable(end,:).FNID;
    % 在 node.csv 中查找对应的 PID
    nodeRow = nodeTable(nodeTable.NID == fnid, :);
    if isempty(nodeRow)
        error('未找到对应的 node 数据，请检查 lane.csv 与 node.csv 的匹配关系。');
    end
    startPID = nodeRow.PID;
    % 在 point.csv 中获取对应的坐标（Bx, Ly）
    pointRow = pointTable(pointTable.PID == startPID, :);
    if isempty(pointRow)
        error('未找到对应的 point 数据，请检查 node.csv 与 point.csv 的匹配关系。');
    end
    laneStartPt = [pointRow.Bx, pointRow.Ly];

    % 连接车道终点与外层轮廓起点
    if size(outer_pts,1) >= 2
        % 找到最近点及其索引
        dists = vecnorm(outer_pts - laneStartPt, 2, 2);
        [~, nearest_idx] = min(dists);

        % 调整轮廓起点顺序
        outer_pts = [outer_pts(nearest_idx:end,:); outer_pts(1:nearest_idx-1,:)];

        % 直接把车道终点作为路径的起点
        spiral_path = [laneStartPt; outer_pts];

    else
        spiral_path = outer_pts;
    end
    last_pt = spiral_path(end,:);

    % 迭代生成内缩轮廓
    while poly_current.area > minArea
        % 负向偏移获得内层轮廓
        poly_offset = polybuffer(poly_current, -d, 'JointType', 'miter', 'MiterLimit', 2);
        if isempty(poly_offset.Vertices) || poly_offset.area < minArea
            break;
        end

        % 若偏移结果产生多个区域，选择面积最大的
        if poly_offset.NumRegions > 1
            regions = poly_offset.Regions;
            areas = cellfun(@(ps) polyarea(ps(:,1), ps(:,2)), regions);
            [~, idx] = max(areas);
            ps = regions{idx};
            poly_offset = polyshape(ps(:,1), ps(:,2));
        end

        % 均匀采样内层轮廓
        inner_pts = samplePolyBoundary(poly_offset, max_seg_length);

        % 对齐 inner_pts，使得 inner_pts(1,:) 距离上层末点最近
        inner_pts = alignPoints(inner_pts, last_pt);

        % 计算外层末端的切线方向（取上层路径最后两个点的方向）
        if size(spiral_path,1) >= 2
            v_outer = last_pt - spiral_path(end-1,:);
            v_outer = v_outer / norm(v_outer);
        else
            v_outer = [1, 0]; % 默认方向
        end

        % 计算内层起点的切线方向（取 inner_pts 前两个点的方向）
        if size(inner_pts,1) >= 2
            v_inner = inner_pts(2,:) - inner_pts(1,:);
            v_inner = v_inner / norm(v_inner);
        else
            v_inner = [1, 0]; % 默认方向
        end

        % 根据 use_s_curve 参数决定使用 S 型曲线还是直线连接
        if use_s_curve
            % 得到延长后的断点
            new_outer_pt = last_pt - extended_gap * v_outer;
            new_inner_pt = inner_pts(1,:) + extended_gap * v_inner;

            % 删除原来的断点段：用延长后的上层断点替换原上层末端
            spiral_path(end,:) = new_outer_pt;

            % 生成 S 型连接曲线
            connecting_curve = generateSShapedCurve(new_outer_pt, new_inner_pt, curvature, num_curve_pts);
            % 为避免重复，新内层断点直接作为连接曲线的终点，且忽略 inner_pts 第一节点
            inner_pts = inner_pts(2:end,:);
            % 拼接：连接曲线（去首重复点） + 新内层断点 + 内层剩余路径
            spiral_path = [spiral_path; connecting_curve(2:end,:); new_inner_pt; inner_pts];
        else
            % 直接用直线连接，不使用延长断点
            spiral_path = [spiral_path; inner_pts];
        end

        last_pt = spiral_path(end,:);

        % 更新当前多边形
        poly_current = poly_offset;
    end
end