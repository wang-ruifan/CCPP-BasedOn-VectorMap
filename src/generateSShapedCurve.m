% filepath: /CCPP-BasedOn-VectorMap/src/generateSShapedCurve.m
function curve_pts = generateSShapedCurve(P0, P1, curvature, num_pts)
    % 生成 S 形状的 Cubic Bézier 曲线
    % P0、P1 为端点，curvature 为曲率参数，num_pts 为采样点数
    delta = P1 - P0;
    dist = norm(delta);
    if dist < eps
        curve_pts = repmat(P0, num_pts, 1);
        return;
    end
    v = delta / dist;
    u = [-v(2), v(1)];

    % 使用控制点比例参数 t = 0.4
    t = 0.4;
    cp1 = P0 + t * delta + curvature * dist * u;
    cp2 = P1 - t * delta - curvature * dist * u;

    ts = linspace(0, 1, num_pts)';
    curve_pts = (1 - ts).^3 * P0 + 3 * (1 - ts).^2 .* ts * cp1 + ...
        3 * (1 - ts) .* ts.^2 * cp2 + ts.^3 * P1;
end