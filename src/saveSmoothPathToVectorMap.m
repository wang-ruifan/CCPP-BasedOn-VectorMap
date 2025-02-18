% filepath: /CCPP-BasedOn-VectorMap/src/saveSmoothPathToVectorMap.m
function saveSmoothPathToVectorMap(smooth_path, mapData)
    %% 参数设置
    defaultB = 0;
    defaultL = 0;
    defaultExtra = 0;

    %% 检查输入参数
    num_pts_new = size(smooth_path,1);
    if num_pts_new < 2
        error('生成的平滑路径点数少于2，无法构造车道段。');
    end

    %% 从 mapData 中获取地图数据
    tblPoint = mapData.point;
    tblNode = mapData.node;
    tblLane = mapData.lane;
    tblLine = mapData.line;

    %% 重新组织数据
    % 1. 获取各类点
    lanePIDs = unique(tblNode.PID);  % lane使用的点
    linePIDs = unique([tblLine.BPID; tblLine.FPID]);  % line使用的点

    % 2. 分离原point数据
    lanePoints = tblPoint(ismember(tblPoint.PID, lanePIDs), :);
    linePoints = tblPoint(ismember(tblPoint.PID, linePIDs), :);
    otherPoints = tblPoint(~ismember(tblPoint.PID, [lanePIDs; linePIDs]), :);

    % 获取已有lane终点的高度
    lastLanePointH = lanePoints.H(end);

    % 3. 准备新生成的点数据
    smooth_path = smooth_path(2:end, :);  % 去掉第一个点
    num_pts_new = size(smooth_path,1);

    % 生成新points，使用已有lane终点的高度
    newPID = (height(lanePoints)+1):(height(lanePoints)+num_pts_new);
    newPoints = table(newPID', repmat(defaultB, num_pts_new,1), repmat(defaultL, num_pts_new,1), ...
        repmat(lastLanePointH, num_pts_new,1), smooth_path(:,1), smooth_path(:,2), ...
        repmat(defaultExtra, num_pts_new,1), repmat(defaultExtra, num_pts_new,1), ...
        repmat(defaultExtra, num_pts_new,1), repmat(defaultExtra, num_pts_new,1), ...
        'VariableNames', {'PID','B','L','H','Bx','Ly','ReF','MCODE1','MCODE2','MCODE3'});

    % 4. 重新分配line点的PID
    startLinePID = height(lanePoints) + height(newPoints) + 1;
    old_to_new_pid = containers.Map('KeyType','double','ValueType','double');
    for i = 1:height(linePoints)
        old_to_new_pid(linePoints.PID(i)) = startLinePID + i - 1;
    end
    linePoints.PID = (startLinePID:(startLinePID+height(linePoints)-1))';

    % 5. 更新line的引用
    for i = 1:height(tblLine)
        if isKey(old_to_new_pid, tblLine.BPID(i))
            tblLine.BPID(i) = old_to_new_pid(tblLine.BPID(i));
        end
        if isKey(old_to_new_pid, tblLine.FPID(i))
            tblLine.FPID(i) = old_to_new_pid(tblLine.FPID(i));
        end
    end

    % 6. 合并point数据
    tblPoint_new = [lanePoints; newPoints; linePoints; otherPoints];

    % 7. 生成新的node数据
    newNID = (max(tblNode.NID)+1):(max(tblNode.NID)+num_pts_new);
    newNodes = table(newNID', newPID', 'VariableNames', {'NID','PID'});
    tblNode_new = [tblNode; newNodes];

    % 8. 生成新的lane数据
    numLanes = num_pts_new - 1;
    newLID = (max(tblLane.LnID)+1):(max(tblLane.LnID)+numLanes);

    % 构造新lane记录
    BLID = [tblLane.LnID(end), newLID(1:end-1)];  % 第一段连接已有lane
    FLID = [newLID(2:end), 0];
    BNID = newNID(1:end-1);
    FNID = newNID(2:end);

    newLanes = table(newLID', newLID', BLID', FLID', BNID', FNID', ...
        repmat(tblLane.JCT(end), numLanes,1), ...
        repmat(0, numLanes,1), repmat(0, numLanes,1), repmat(0, numLanes,1), ...
        repmat(0, numLanes,1), repmat(0, numLanes,1), repmat(0, numLanes,1), ...
        repmat(0, numLanes,1), repmat(0, numLanes,1), repmat(0, numLanes,1), ...
        repmat(tblLane.Lno(end), numLanes,1), repmat(0, numLanes,1), ...
        repmat(tblLane.LimitVel(end), numLanes,1), ...
        repmat(tblLane.RefVel(end), numLanes,1), ...
        repmat(0, numLanes,1), repmat(0, numLanes,1), repmat(1, numLanes,1), ...
        'VariableNames', {'LnID','DID','BLID','FLID','BNID','FNID','JCT','BLID2',...
        'BLID3','BLID4','FLID2','FLID3','FLID4','ClossID','Span','LCnt','Lno',...
        'LaneType','LimitVel','RefVel','RoadSecID','LaneChgFG','IsSweep'});
    tblLane_new = [tblLane; newLanes];

    %% 保存数据
    % 获取数据目录
    current_dir = pwd;
    [~, folder_name, ~] = fileparts(current_dir);
    if strcmp(folder_name, 'src')
        dataDir = '../data';
    else
        dataDir = './data';
    end

    % 创建输出目录
    outDir = fullfile(pwd, '..', 'output');
    if ~exist(outDir, 'dir')
        mkdir(outDir);
    end

    % 写出更新后的文件
    writetable(tblPoint_new, fullfile(outDir, 'point.csv'));
    writetable(tblNode_new, fullfile(outDir, 'node.csv'));
    writetable(tblLane_new, fullfile(outDir, 'lane.csv'));
    writetable(tblLine, fullfile(outDir, 'line.csv'));

    % 复制其他数据文件
    copyfile(fullfile(dataDir, 'area.csv'), outDir);
    copyfile(fullfile(dataDir, 'custom_area.csv'), outDir);
end