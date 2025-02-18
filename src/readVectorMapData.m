% filepath: /CCPP-BasedOn-VectorMap/src/readVectorMapData.m
function mapData = readVectorMapData()
    % 获取数据目录
    current_dir = pwd;
    [~, folder_name, ~] = fileparts(current_dir);
    if strcmp(folder_name, 'src')
        data_directory = '../data';
    else
        data_directory = './data';
    end

    % 读取各个数据文件
    mapData = struct();
    mapData.point = readtable(fullfile(data_directory, 'point.csv'));
    mapData.node = readtable(fullfile(data_directory, 'node.csv'));
    mapData.lane = readtable(fullfile(data_directory, 'lane.csv'));
    mapData.line = readtable(fullfile(data_directory, 'line.csv'));
    mapData.area = readtable(fullfile(data_directory, 'area.csv'));
    mapData.customArea = readtable(fullfile(data_directory, 'custom_area.csv'));
end