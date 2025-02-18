% filepath: /CCPP-BasedOn-VectorMap/src/visualizeArea.m
function visualizeArea(boundary_points, lanePt, title_str)
    %% 创建图形窗口
    figure('Name', title_str);
    hold on; grid on; axis equal;

    %% 绘制区域边界
    % 添加起点作为终点以闭合多边形，注意x和y的对应关系
    plot([boundary_points(:,2); boundary_points(1,2)], ...
        [boundary_points(:,1); boundary_points(1,1)], ...
        'k-', 'LineWidth', 2);

    %% 绘制车道
    % 读取车道起点与终点坐标
    startPt = lanePt(1,:);
    endPt = lanePt(2,:);

    % 绘制初始 lane 线段，以蓝色显示
    plot([startPt(2) endPt(2)], [startPt(1) endPt(1)], 'b-', 'LineWidth', 2);

    %% 设置图形属性
    title(title_str);
    xlabel('X坐标');
    ylabel('Y坐标');

    % 适当调整坐标轴范围，注意x和y的对应关系
    xlim([min(boundary_points(:,2))-1, max(boundary_points(:,2))+1]);
    ylim([min(boundary_points(:,1))-1, max(boundary_points(:,1))+1]);
end