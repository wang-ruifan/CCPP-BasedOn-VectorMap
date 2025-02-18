% filepath: /f:/CCPP-BasedOn-VectorMap/src/plotSpiralPath.m
function plotSpiralPath(spiral_path)
    % 读取自定义区域边界点，构造多边形（交换 x 与 y 坐标）
    boundary_points = get_custom_area();
    poly_orig = polyshape(boundary_points(:,1), boundary_points(:,2));
    
    figure;
    hold on; grid on; axis equal;
    
    % 绘制区域边界（交换 x 与 y 坐标）
    [x_poly, y_poly] = boundary(poly_orig);
    plot(y_poly, x_poly, 'k-', 'LineWidth', 1.5);
    
    % 绘制螺旋路径（交换 x 与 y 坐标）
    plot(spiral_path(:,2), spiral_path(:,1), 'r-', 'LineWidth', 2);
    
    % 获取初始 lane 段的起点和终点
    [startPt, endPt] = getInitialLaneSegment();
    % 绘制初始 lane 线段（交换 x 与 y 坐标），以蓝色显示
    plot([startPt(2) endPt(2)], [startPt(1) endPt(1)], 'b-', 'LineWidth', 2);
    % 添加端点标记
    plot(startPt(2), startPt(1), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
    plot(endPt(2), endPt(1), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
    text(startPt(2), startPt(1), '  BNID', 'Color', 'b', 'FontSize', 10);
    text(endPt(2), endPt(1), '  FNID', 'Color', 'b', 'FontSize', 10);
    
    title('连续螺旋覆盖路径');
    xlabel('X'); ylabel('Y');
    hold off;
end