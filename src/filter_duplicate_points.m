% filepath: /f:/CCPP-BasedOn-VectorMap/src/filter_duplicate_points.m
function filtered_path = filter_duplicate_points(path, tolerance)
    if isempty(path)
        filtered_path = path;
        return;
    end
    % 初始化结果，取第一个点
    filtered_path = path(1,:);
    for i = 2:size(path,1)
        if norm(path(i,:) - filtered_path(end,:)) < tolerance
            % 距离小于容差则合并：取平均值
            merged_point = (filtered_path(end,:) + path(i,:)) / 2;
            filtered_path(end,:) = merged_point;
        else
            filtered_path = [filtered_path; path(i,:)];
        end
    end
end