clc;
clear all;

global f;
global cfgRelation1;
global cfgRelation2;
global baseBlockNumber;

%处理out_file2，获取程序的控制流图
cfgData = importdata('data/out_file2');  %加载数据，存入一个两列的矩阵中，第一列表示出发节点，第二列表示到达节点
[cfgData_rowSize,cfgData_colSize] = size(cfgData);
allBaseBlock(1) = cfgData(1);%将第一个baseBlock直接放入矩阵

for i = 2 : (cfgData_rowSize * cfgData_colSize)
    flag = 0;
    for j = 1 : size(allBaseBlock)
        if(cfgData(i) == allBaseBlock(j))
            flag = 1;
        end
    end
    if(flag == 0)
        allBaseBlock = [allBaseBlock;cfgData(i)];
    end
end
[baseBlockNumber,~] = size(allBaseBlock);
cfgRelation1 = zeros(1,baseBlockNumber);
cfgRelation1(1,1) = 1;

tmp_cfgRelationRow = 2;
cfgRelation1 = [cfgRelation1;zeros(1,baseBlockNumber)];

for i = 1: cfgData_rowSize
    pos_1 = find(allBaseBlock == cfgData(i,1));%获取节点的新编号
    pos_2 = find(allBaseBlock == cfgData(i,2));
    cfgRelation1(tmp_cfgRelationRow,pos_1) = -1;%当前节点的值设置为-1
    cfgRelation1(tmp_cfgRelationRow,pos_2) = 1;%可达节点的值设置为1
    
    if(i<cfgData_rowSize)
        pos_1_nextLine = find(allBaseBlock == cfgData(i+1,1));%读取下一行的起始节点
    end
    
    if(pos_1 ~= pos_1_nextLine)  %判断下一行是否是同一个起始节点，如果不是，则写入一行新的矩阵
        tmp_cfgRelationRow = tmp_cfgRelationRow + 1;
        cfgRelation1 = [cfgRelation1;zeros(1,baseBlockNumber)];
    end
end
[relationRow,~]= size(cfgRelation1);
cfgRelation2 = zeros(relationRow + 1,1);%设置等式右边的矩阵
cfgRelation2(1) = 1;


%处理out_file，获取程序固有流量的比例
reachTimesData = importdata('data/out_file');  %加载数据，存入一个两列的矩阵中，第一列为节点，第二列为到达次数
[reachTimesData_row,~] = size(reachTimesData);
f = zeros(1,baseBlockNumber);
maxReachNumber = max(reachTimesData(:,2));
for i = 1 : reachTimesData_row
    f_pos = find(allBaseBlock == reachTimesData(i,1)); %获取该节点的新编号
    f(f_pos) = reachTimesData(i,2) / maxReachNumber;
end
fprintf('CFG has been established successfully!\n');




