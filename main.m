clc;
clear all;
close all;

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

REWARD = 10;   %若一个bug被触发，defender获得的收益
MAX_ROUNDS = 150;%最大轮数，为了预设矩阵的内存空间，也防止死循环

%设置路径形状
%用程序路径中的交叉点的入度和出度来表示路径之间的关系和限制
%用矩阵表示，每行代表一个交叉点，每列代表一条路径。入度为-1，出度为1

% pathRelationPart1 = [1 1 0 0 0 0; -1 0 1 1 0 0; 0 -1 0 -1 1 1];%3个交叉点，6条路径
% pathRelationPart2 = [1; 0; 0];
% f = [0.2 0.8 0.1 0.1 0.5 0.4];  %表示在没有采取任何策略，程序固有结构决定的fuzzing资源流的分配比例
% TOTAL_POTENTIAL_NUMBER = 6;   %程序中的路径数量，即潜在插入点数量
% ATTACKER_CAPACITY  = TOTAL_POTENTIAL_NUMBER/3;  %defender最多能插入的bug数

% pathRelationPart1 = [1 1];%1个交叉点，2条路径
% pathRelationPart2 = [1];
% f = [0.6 0.4];  %表示在没有采取任何策略，程序固有结构决定的fuzzing资源流的分配比例
% TOTAL_POTENTIAL_NUMBER = 2;   %程序中的路径数量，即潜在插入点数量
% ATTACKER_CAPACITY  = 1;  %defender最多能插入的bug数


%等式左侧
pathRelationPart1 = zeros(10,24);%10个交叉点，24条路径
%point1
pathRelationPart1(1,1:3) = 1;
%point2
pathRelationPart1(2,1) = -1;
pathRelationPart1(2,4:6) = 1;

pathRelationPart1(3,2) = -1;
pathRelationPart1(3,7:9) = 1;

pathRelationPart1(4,3) = -1;
pathRelationPart1(4,10:11) = 1;

pathRelationPart1(5,5) = -1;
pathRelationPart1(5,12) = -1;
pathRelationPart1(5,14:15) = 1;

pathRelationPart1(6,6:7) = -1;
pathRelationPart1(6,12:13) = 1;

pathRelationPart1(7,9:10) = -1;
pathRelationPart1(7,16:18) = 1;

pathRelationPart1(8,13) = -1;
pathRelationPart1(8,8) = -1;
pathRelationPart1(8,19:20) = 1;

pathRelationPart1(9,20) = -1;
pathRelationPart1(9,16) = -1;
pathRelationPart1(9,21:22) = 1;

pathRelationPart1(10,19) = -1;
pathRelationPart1(10,21) = -1;
pathRelationPart1(10,23:24) = 1;

%等式右侧
pathRelationPart2 = zeros(10,1);
pathRelationPart2(1) = 1;

f = [0.6 0.3 0.1 0.1 0.2 0.3 0.15 0.1 0.05 0.07 0.03 0.15...
     0.3 0.25 0.1 0.05 0.03 0.04 0.25 0.15 0.13 0.07 0.14 0.24];
TOTAL_POTENTIAL_NUMBER = 24;   %程序中的路径数量，即潜在插入点数量
ATTACKER_CAPACITY  = TOTAL_POTENTIAL_NUMBER/6;  %defender最多能插入的bug数

%设置attacker初始策略
% bestResponseAttacker = [0.3 0.7 0.2 0.1 0.3 0.5];%任意设置检测资源分配比例
% bestResponseAttacker = [0.8 0.2];
bestResponseAttacker = f;  %或者将attacker初始策略设置为程序固有分配比例
pureSetAttacker(1,1:TOTAL_POTENTIAL_NUMBER) = bestResponseAttacker;

%设置defender的初始策略
% bestResponseDefender = [0 0 0.1 0 0.9 0];  %或者任意设置defender的初始策略
% bestResponseDefender = [0 0.1];
bestResponseDefender = zeros(1,24);
bestResponseDefender(4:7) = 0.5;%或者任意设置defender的初始策略
pureSetDefender(1,1:TOTAL_POTENTIAL_NUMBER) = bestResponseDefender;

tic;
%主循环，直至收敛
for round = 1:MAX_ROUNDS
    
    %通过对最优纯策略集合进行minimax求解，求出双方最优混合策略
    [payoffMixedDefender,payoffMixedAttacker,mixedStrategyDefender,mixedStrategyAttacker] = computeMixedStrategy(pureSetDefender,pureSetAttacker);
    
    %计算双方最优纯策略
    [bestResponseAttacker,payoffBestAttacker] = computeAttackerBest(mixedStrategyDefender);
    [bestResponseDefender,payoffBestDefender] = computeDefenderBest(mixedStrategyAttacker);
    
    %记录minimax收益
    logDefenderMixPayoff(round) = payoffMixedDefender;
    logAttackerMixPayoff(round) = payoffMixedAttacker;
    %记录best收益
    logDefenderBestPayoff(round) = payoffBestDefender;
    logAttackerBestPayoff(round) = payoffBestAttacker;

    %判断收敛
    %在对方采取mixed srategy时，双方各自的best response获得的收益没有mixed srategy获得的收益大时，即为收敛
    convergeDefender = payoffBestDefender - payoffMixedDefender;
    convergeAttacker = payoffBestAttacker - payoffMixedAttacker;
    if ((convergeDefender < 0.001) && (convergeAttacker < 0.001) || (round == MAX_ROUNDS))   
        break;  %收敛，跳出循环
    else
%         if(round > 10)  %在对方当前混合策略下，删除一个己方纯策略集合中收益最小的纯策略
%             deleteStrategy(mixedStrategyDefender,mixedStrategyAttacker);
%         end

        %将双方最优纯策略作为新的一行加入到最优纯策略集合
        pureSetDefender = [pureSetDefender;bestResponseDefender];
        pureSetAttacker = [pureSetAttacker;bestResponseAttacker];

        fprintf('round = %d, convergeDefender = %d, convergeAttacker = %d\n',round,convergeDefender,convergeAttacker);%未收敛，输出本轮计算结果
    end
end

toc %记录运行时间

%记录收敛结果
fprintf('round = %d, convergeDefender = %d, convergeAttacker = %d \n',round,convergeDefender,convergeAttacker);
fprintf('Ua(A,d) = %d, Ua(a,d) = %d, Ud(a,D) = %d, Ud(a,d) = %d \n',payoffBestDefender,payoffMixedDefender,payoffBestAttacker,payoffMixedAttacker);

%绘制结果图像
x = 1:round;
% plot(x,logDefenderBestPayoff,'-rs',x,logDefenderMixPayoff,':ko',x,-logAttackerBestPayoff,'-.b^');
% legend('defender best','minimax','attacker best'); % 曲线标识
% 
subplot(2,1,1);
plot(x,logDefenderBestPayoff,'-rs',x,logDefenderMixPayoff,':kh');
legend('best response  Ud(D,a)','mixed strategy  Ud(d,a)'); % 曲线标识
title('Defender'); % 小标题

subplot(2,1,2);
plot(x,logAttackerBestPayoff,'-.b^',x, logAttackerMixPayoff,'--k*');
legend('best response  Ua(d,A)','mixed strategy  Ua(d,a)'); % 曲线标识
title('Attacker'); % 小标题

%记录最终混合策略
row = size(pureSetDefender,1);
for i = 1:row
    %defender
    result(i,1:TOTAL_POTENTIAL_NUMBER) = pureSetDefender(i,1:TOTAL_POTENTIAL_NUMBER);%纯策略
    result(i,TOTAL_POTENTIAL_NUMBER+2) = roundn(mixedStrategyDefender(i),-4);%混合策略概率
    %attacker
    result(i,TOTAL_POTENTIAL_NUMBER+4:2*TOTAL_POTENTIAL_NUMBER+3) = pureSetAttacker(i,1:TOTAL_POTENTIAL_NUMBER);
    result(i,2*TOTAL_POTENTIAL_NUMBER+5) = roundn(mixedStrategyAttacker(i),-4);    
end
fprintf('Done! \n');



