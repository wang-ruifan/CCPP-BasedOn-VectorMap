% filepath: /f:/CCPP-BasedOn-VectorMap/src/generateTangentArc.m
function arc_pts = generateTangentArc(P0, P3, T0, T3, curvature, num_pts)
    % 生成与给定切线方向相切的三次贝塞尔曲线
    % P0,P3: 起点和终点
    % T0,T3: 起点和终点的单位切向量
    % curvature: 用于调整控制点距离的系数
    
    % 计算两端点间距离
    chord = P3 - P0;
    chord_length = norm(chord);
    
    % 计算转角角度（两切线夹角）
    cos_angle = dot(T0, T3);
    angle = acos(max(-1, min(1, cos_angle)));
    
    % 根据转角大小动态调整控制点距离
    % 转角越大，控制点距离越大，以确保平滑过渡
    base_dist = chord_length / 3;
    angle_factor = 1 + sin(angle/2);  % 角度越大，系数越大
    control_dist = base_dist * angle_factor * curvature;
    
    % 构造控制点
    P1 = P0 + control_dist * T0;
    P2 = P3 - control_dist * T3;
    
    % 生成贝塞尔曲线点
    ts = linspace(0, 1, num_pts)';
    arc_pts = zeros(num_pts, 2);
    
    % 三次贝塞尔曲线公式
    for i = 1:num_pts
        t = ts(i);
        arc_pts(i,:) = (1-t)^3 * P0 + ...
                       3*(1-t)^2*t * P1 + ...
                       3*(1-t)*t^2 * P2 + ...
                       t^3 * P3;
    end
end