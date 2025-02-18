% filepath: /CCPP-BasedOn-VectorMap/src/samplePolyBoundary.m
function pts_uniform = samplePolyBoundary(poly_obj, max_seg_length)
    % 获取多边形边界点
    [x, y] = boundary(poly_obj);
    pts = [x, y];

    % 先对原始顶点进行合并处理：如果相邻顶点之间距离小于tol_merge，则合并它们
    tol_merge = 1e-6;
    merged_pts = pts(1,:);
    for i = 2:size(pts,1)
        if norm(pts(i,:) - merged_pts(end,:)) < tol_merge
            % 合并为平均值
            merged_pts(end,:) = (merged_pts(end,:) + pts(i,:)) / 2;
        else
            merged_pts = [merged_pts; pts(i,:)];
        end
    end

    % 对于每个相邻顶点之间的线段，进行采样（保留顶点不动）
    pts_uniform = merged_pts(1,:);  % 初始化结果序列
    for i = 1:size(merged_pts,1)-1
        pt_start = merged_pts(i,:);
        pt_end   = merged_pts(i+1,:);
        d = norm(pt_end - pt_start);

        % 如果线段长度大于最大采样长度，则在内部添加采样点
        if d > max_seg_length
            num_samples = floor(d/max_seg_length);
            % 使用均匀比例（不包括端点）
            t = linspace(0,1,num_samples+2);
            t = t(2:end-1);  % 去除0和1，因为端点已经保留
            % 生成中间采样点
            inter_pts = pt_start + t' * (pt_end - pt_start);
            pts_uniform = [pts_uniform; inter_pts];
        end

        % 添加终点
        pts_uniform = [pts_uniform; pt_end];
    end

    % 如果是闭合多边形，结果中第一个点可能等于最后一个点
    if norm(pts_uniform(1,:) - pts_uniform(end,:)) < tol_merge
        pts_uniform(end,:) = [];
    end
end