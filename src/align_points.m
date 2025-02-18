% filepath: /f:/CCPP-BasedOn-VectorMap/src/align_points.m
function pts_aligned = align_points(pts, ref_pt)
    % 找到离参考点最近的顶点
    d = vecnorm(pts - ref_pt, 2, 2);
    [~, min_idx] = min(d);

    % 对齐时不改变原始顶点顺序
    pts_aligned = [pts(min_idx:end, :); pts(1:min_idx-1, :)];
end