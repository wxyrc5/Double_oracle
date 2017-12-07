clc;
close all;
clear;
%声明全局变量
global TOTAL_POTENTIAL_NUMBER;
global ATTACKER_CAPACITY;
global REWARD;
global MAX_ROUNDS;
global pathRelationPart1;
global pathRelationPart2;
global f;
global pureSetDefender;
global pureSetAttacker;
global voteD;
global voteA;
pureSetDefender(:,:) = [];
pureSetAttacker(:,:) = [];

REWARD = 10;  %若一个bug被触发，defender获得的收益
MAX_ROUNDS = 200; %最大轮数，为了预设矩阵的内存空间，也防止死循环
PURE_SET_SIZE = 30; %纯策略空间保留纯策略个数

voteD = zeros(PURE_SET_SIZE,1);
voteA = zeros(PURE_SET_SIZE,1);

%设置路径形状
%用程序路径中的交叉点的入度和出度来表示路径之间的关系和限制
%用矩阵表示，每行代表一个交叉点，每列代表一条路径。入度为-1，出度为1
pathRelationPart1 = xlsread('24.xlsx');%等式左侧
pathRelationPart2 = zeros(10,1);%等式右侧
pathRelationPart2(1) = 1;

f = [0.6 0.3 0.1 0.1 0.2 0.3 0.15 0.1 0.05 0.07 0.03 0.15...
     0.3 0.25 0.1 0.05 0.03 0.04 0.25 0.15 0.13 0.07 0.14 0.24];
TOTAL_POTENTIAL_NUMBER = 24;  %程序中的路径数量，即潜在插入点数量
ATTACKER_CAPACITY  = TOTAL_POTENTIAL_NUMBER/8;  %defender最多能插入的bug数

%设置attacker初始策略
bestResponseAttacker = [0.4 0.3 0.3 0.1 0.2 0.1 0.1 0.1 0.1 0.2 0.1 0.05...
     0.15 0.15 0.1 0.1 0.1 0.1 0.1 0.15 0.15 0.1 0.15 0.1];
pureSetAttacker(1,1:TOTAL_POTENTIAL_NUMBER) = bestResponseAttacker;

%设置defender的初始策略
bestResponseDefender = zeros(1,TOTAL_POTENTIAL_NUMBER);
bestResponseDefender(10:10+ATTACKER_CAPACITY-1) = 0.9;%或者任意设置defender的初始策略
pureSetDefender(1,1:TOTAL_POTENTIAL_NUMBER) = bestResponseDefender;

logMixedStrategyDefender = zeros(MAX_ROUNDS);
logMixedStrategyAttacker = zeros(MAX_ROUNDS);
%主循环，直至收敛
tic;
for round = 1:MAX_ROUNDS    
    %通过对最优纯策略集合进行minimax求解，求出双方最优混合策略
    [payoffMixedDefender,payoffMixedAttacker,mixedStrategyDefender,mixedStrategyAttacker] = computeMixedStrategy();
    mixedStrategyDefender = roundn(mixedStrategyDefender,-4); 
    mixedStrategyAttacker = roundn(mixedStrategyAttacker,-4);
    logDefenderMixPayoff(round) = payoffMixedDefender;
    
    %计算双方最优纯策略
    [bestResponseDefender,payoffBestDefender] = computeDefenderBest(mixedStrategyAttacker);
    [bestResponseAttacker,payoffBestAttacker] = computeAttackerBest(mixedStrategyDefender);
    bestResponseDefender = roundn(bestResponseDefender,-4);
    bestResponseAttacker = roundn(bestResponseAttacker,-4);
    logDefenderBestPayoff(round) = payoffBestDefender;
    logAttackerBestPayoff(round) = payoffBestAttacker;
    
    %记录mixed strategy
%     logMixedStrategyDefender(1:round,round) = mixedStrategyDefender;
%     logMixedStrategyAttacker(1:round,round) = mixedStrategyAttacker;

    %在对方采取mixed srategy时，双方各自的best response获得的收益没有mixed srategy获得的收益大时，即为收敛
    convergeDefender = payoffBestDefender - payoffMixedDefender;
    convergeAttacker = payoffBestAttacker - payoffMixedAttacker;
    if ((convergeDefender < 0.01) && (convergeAttacker < 0.01) || (round == MAX_ROUNDS))
        break;  %收敛，跳出循环
    else
        if(round >= PURE_SET_SIZE)  
%               payoffDelete(mixedStrategyDefender,mixedStrategyAttacker);%在对方当前混合策略下，删除一个己方纯策略集合中收益最小的纯策略
%               voteDelete(PURE_SET_SIZE,mixedStrategyDefender,mixedStrategyAttacker); %统计票数,删除票数最少的纯策略
%               probaDelete(mixedStrategyDefender,mixedStrategyAttacker); %按照混合策略中概率排序，删除最小的纯策略
        end
        
        %将双方最优纯策略作为新的一行加入到最优纯策略集合
        pureSetDefender = [pureSetDefender;bestResponseDefender];
        pureSetAttacker = [pureSetAttacker;bestResponseAttacker];
        
        fprintf('round = %d, convergeDefender = %d, convergeAttacker = %d\n',round,convergeDefender,convergeAttacker);%未收敛，输出本轮计算结果
    end
end  %收敛，跳出循环
toc

%输出收敛结果
fprintf('round = %d, convergeDefender = %d, convergeAttacker = %d \n',round,convergeDefender,convergeAttacker);
fprintf('Ua(A,d) = %d, Ua(a,d) = %d, Ud(a,D) = %d, Ud(a,d) = %d \n',payoffBestDefender,payoffMixedDefender,payoffBestAttacker,payoffMixedAttacker);

%处理结果
result = resultProcess(round,logDefenderBestPayoff,logDefenderMixPayoff,logAttackerBestPayoff,mixedStrategyDefender,mixedStrategyAttacker);