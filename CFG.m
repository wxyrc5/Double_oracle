clc;
clear all;

global f;
global cfgRelation1;
global cfgRelation2;
global baseBlockNumber;

%����out_file2����ȡ����Ŀ�����ͼ
cfgData = importdata('data/out_file2');  %�������ݣ�����һ�����еľ����У���һ�б�ʾ�����ڵ㣬�ڶ��б�ʾ����ڵ�
[cfgData_rowSize,cfgData_colSize] = size(cfgData);
allBaseBlock(1) = cfgData(1);%����һ��baseBlockֱ�ӷ������

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
    pos_1 = find(allBaseBlock == cfgData(i,1));%��ȡ�ڵ���±��
    pos_2 = find(allBaseBlock == cfgData(i,2));
    cfgRelation1(tmp_cfgRelationRow,pos_1) = -1;%��ǰ�ڵ��ֵ����Ϊ-1
    cfgRelation1(tmp_cfgRelationRow,pos_2) = 1;%�ɴ�ڵ��ֵ����Ϊ1
    
    if(i<cfgData_rowSize)
        pos_1_nextLine = find(allBaseBlock == cfgData(i+1,1));%��ȡ��һ�е���ʼ�ڵ�
    end
    
    if(pos_1 ~= pos_1_nextLine)  %�ж���һ���Ƿ���ͬһ����ʼ�ڵ㣬������ǣ���д��һ���µľ���
        tmp_cfgRelationRow = tmp_cfgRelationRow + 1;
        cfgRelation1 = [cfgRelation1;zeros(1,baseBlockNumber)];
    end
end
[relationRow,~]= size(cfgRelation1);
cfgRelation2 = zeros(relationRow + 1,1);%���õ�ʽ�ұߵľ���
cfgRelation2(1) = 1;


%����out_file����ȡ������������ı���
reachTimesData = importdata('data/out_file');  %�������ݣ�����һ�����еľ����У���һ��Ϊ�ڵ㣬�ڶ���Ϊ�������
[reachTimesData_row,~] = size(reachTimesData);
f = zeros(1,baseBlockNumber);
maxReachNumber = max(reachTimesData(:,2));
for i = 1 : reachTimesData_row
    f_pos = find(allBaseBlock == reachTimesData(i,1)); %��ȡ�ýڵ���±��
    f(f_pos) = reachTimesData(i,2) / maxReachNumber;
end
fprintf('CFG has been established successfully!\n');




