% filepath: /CCPP-BasedOn-VectorMap/src/plotSpiralPath.m
function plotSpiralPath(spiral_path, boundary_points, lanePt, title_str)
    % 读取自定义区域边界点，构造多边形（交换 x 与 y 坐标）
    poly_orig = polyshape(boundary_points(:,1), boundary_points(:,2));

    figure('Name', title_str);
    hold on; grid on; axis equal;

    % 绘制区域边界（交换 x 与 y 坐标）
    [x_poly, y_poly] = boundary(poly_orig);
    plot(y_poly, x_poly, 'k-', 'LineWidth', 1.5);

    % 读取车道起点与终点坐标
    startPt = lanePt(1,:);
    endPt = lanePt(2,:);

    % 绘制螺旋路径（交换 x 与 y 坐标）
    plot(spiral_path(:,2), spiral_path(:,1), 'r-', 'LineWidth', 2);

    % 绘制初始 lane 线段（交换 x 与 y 坐标），以蓝色显示
    plot([startPt(2) endPt(2)], [startPt(1) endPt(1)], 'b-', 'LineWidth', 2);

    title(title_str);
    xlabel('X'); ylabel('Y');
    hold off;
end