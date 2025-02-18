% filepath: /f:/CCPP-BasedOn-VectorMap/src/smoothCorners.m
function new_path = smoothCorners(path, smooth_radius, num_curve_pts, angle_threshold)
    % 对路径中的每个转角进行平滑处理
    % 输入：
    %   path          - 原始路径点集，Nx2 数组
    %   smooth_radius - 平滑的半径（用于截取边界）
    %   num_curve_pts - 用于生成平滑曲线的采样点数
    %   angle_threshold - 转角阈值（单位：弧度）
    
    % 添加参数：检查范围
    check_distance = smooth_radius;  % 检查范围
    
    new_path = path(1,:);
    N = size(path,1);
    i = 2;
    
    while i < N
        p_cur = path(i,:);
        p_prev = path(i-1,:);
        
        % 在检查范围内寻找下一个点
        j = i + 1;
        while j <= N && norm(path(j,:) - p_cur) <= check_distance
            p_next = path(j,:);
            v1 = p_cur - p_prev;
            v2 = p_next - p_cur;
            
            % 检查向量有效性
            if norm(v1) < 1e-6 || norm(v2) < 1e-6
                j = j + 1;
                continue;
            end
            
            val = dot(v1, v2) / (norm(v1)*norm(v2));
            val = max(min(val, 1), -1);  % 限制值域为[-1,1]
            theta = acos(val);
            
            if theta >= angle_threshold
                % 计算平滑距离，确保不会超过相邻边长
                d = min([smooth_radius, norm(v1), norm(v2)]);
                
                % 用归一化后的v1、v2计算p1、p2（保证切向一致）
                p1 = p_cur - min(d, norm(v1)) * (v1 / norm(v1));
                p2 = p_cur + min(d, norm(v2)) * (v2 / norm(v2));
                
                % 计算切向量
                T0 = v1 / norm(v1);
                T3 = v2 / norm(v2);
                
                % 根据转角大小动态调整曲率
                curvature = 0.5 + 0.3 * (theta - angle_threshold)/(pi - angle_threshold);
                
                % 生成平滑曲线
                arc = generateTangentArc(p1, p2, T0, T3, curvature, num_curve_pts);
                
                % 添加平滑曲线（去除重复点）
                new_path = [new_path; arc(2:end,:)];
                
                % 更新索引，跳过已平滑的部分
                i = j;
                break;
            end
            
            j = j + 1;
        end
        
        % 如果没有找到需要平滑的转角，添加当前点
        if j > N || norm(path(j,:) - p_cur) > check_distance
            new_path = [new_path; p_cur];
            i = i + 1;
        end
    end
    
    % 添加最后一个点（如果还没添加）
    if ~isequal(new_path(end,:), path(end,:))
        new_path = [new_path; path(end,:)];
    end
end