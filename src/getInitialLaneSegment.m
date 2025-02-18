% filepath: /f:/CCPP-BasedOn-VectorMap/src/getInitialLaneSegment.m
function [startPt, endPt] = getInitialLaneSegment()
    % 获取数据目录
    current_dir = pwd;
    [~, folder_name, ~] = fileparts(current_dir);
    if strcmp(folder_name, 'src')
        data_directory = '../data';
    else
        data_directory = './data';
    end

    % 读取 lane、node、point 数据
    laneTable = readtable(fullfile(data_directory, 'lane.csv'));
    nodeTable = readtable(fullfile(data_directory, 'node.csv'));
    pointTable = readtable(fullfile(data_directory, 'point.csv'));

    % 选取 lane.csv 第一行
    lane = laneTable(1,:);
    % 假定 lane 表中字段 BNID 和 FNID 分别表示起点和终点的 node 编号
    bnid = lane.BNID;
    fnid = lane.FNID;
    
    % 查找起点对应的 PID
    nodeRowStart = nodeTable(nodeTable.NID == bnid, :);
    if isempty(nodeRowStart)
        error('未找到对应的起点 node 数据');
    end
    pidStart = nodeRowStart.PID;
    pointRowStart = pointTable(pointTable.PID == pidStart, :);
    if isempty(pointRowStart)
        error('未找到对应的起点 point 数据');
    end
    startPt = [pointRowStart.Bx, pointRowStart.Ly];
    
    % 查找终点对应的 PID
    nodeRowEnd = nodeTable(nodeTable.NID == fnid, :);
    if isempty(nodeRowEnd)
        error('未找到对应的终点 node 数据');
    end
    pidEnd = nodeRowEnd.PID;
    pointRowEnd = pointTable(pointTable.PID == pidEnd, :);
    if isempty(pointRowEnd)
        error('未找到对应的终点 point 数据');
    end
    endPt = [pointRowEnd.Bx, pointRowEnd.Ly];
end