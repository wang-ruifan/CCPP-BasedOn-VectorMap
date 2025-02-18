% file: get_custom_area.m
function boundary_points = get_custom_area()
    % 获取数据目录
    current_dir = pwd;
    [~, folder_name, ~] = fileparts(current_dir);
    if strcmp(folder_name, 'src')
        data_directory = '../data';
    else
        data_directory = './data';
    end

    % 读取point.csv文件
    point_data = readtable(fullfile(data_directory, 'point.csv'));
    points = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    for i = 1:height(point_data)
        pid = point_data.PID(i);
        points(pid) = [point_data.Bx(i), point_data.Ly(i)];
    end

    % 读取line.csv文件
    line_data = readtable(fullfile(data_directory, 'line.csv'));
    lines = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    for i = 1:height(line_data)
        lid = line_data.LID(i);
        lines(lid) = [line_data.BPID(i), line_data.FPID(i), ...
                          line_data.BLID(i), line_data.FLID(i)];
    end

    % 读取area.csv文件
    area_data = readtable(fullfile(data_directory, 'area.csv'));
    areas = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    for i = 1:height(area_data)
        aid = area_data.AID(i);
        areas(aid) = [area_data.SLID(i), area_data.ELID(i)];
    end

    % 读取custom_area.csv文件
    custom_area_data = readtable(fullfile(data_directory, 'custom_area.csv'));
    custom_areas = [];
    for i = 1:height(custom_area_data)
        aid = custom_area_data.AID(i);
        if isKey(areas, aid)
            custom_areas = [custom_areas; areas(aid)];
        end
    end

    % 找出自定义区域包含的所有线段
    area_lines = [];
    for i = 1:size(custom_areas, 1)
        current_lid = custom_areas(i, 1);
        while current_lid ~= custom_areas(i, 2)
            if isKey(lines, current_lid)
                area_lines = [area_lines; current_lid];
                line_info = lines(current_lid);
                current_lid = line_info(4);
            end
        end
        area_lines = [area_lines; custom_areas(i, 2)];
    end

    % 提取边界点
    boundary_points = [];
    for i = 1:length(area_lines)
        lid = area_lines(i);
        if isKey(lines, lid)
            line_info = lines(lid);
            bpid = line_info(1);
            if isKey(points, bpid)
                p = points(bpid);
                boundary_points = [boundary_points; p];
            end
        end
    end
end
