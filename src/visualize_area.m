function visualize_area()
    % 获取边界点
    boundary_points = get_custom_area();
    
    % 创建新的图形窗口
    figure('Name', 'Custom Area Visualization');
    
    % 绘制封闭多边形
    % 添加起点作为终点以闭合多边形，注意x和y的对应关系
    plot([boundary_points(:,2); boundary_points(1,2)], ...
         [boundary_points(:,1); boundary_points(1,1)], ...
         'b-', 'LineWidth', 2);
    
    % 设置图形属性
    grid on;
    title('广场边界可视化');
    xlabel('X坐标');
    ylabel('Y坐标');
    axis equal;
    
    % 适当调整坐标轴范围，注意x和y的对应关系
    xlim([min(boundary_points(:,2))-1, max(boundary_points(:,2))+1]);
    ylim([min(boundary_points(:,1))-1, max(boundary_points(:,1))+1]);
end