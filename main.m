clc;
close all;
clear all;
%声明全局变量

global blockNumber;
global ATTACKER_CAPACITY;
global REWARD;
global MAX_ROUNDS;
global pureSetDefender;
global pureSetAttacker;
global f;

CFG();  %读取CFG关系图
REWARD = 10;  %若一个bug被触发，defender获得的收益
MAX_ROUNDS = 200; %最大轮数，为了预设矩阵的内存空间，也防止死循环
PURE_SET_SIZE = 30; %纯策略空间保留纯策略个数
ATTACKER_CAPACITY  = round(blockNumber/8);  %defender最多能插入的bug数


%设置attacker初始策略
pureSetAttacker(1,1:blockNumber) = f;

%设置defender的初始策略
bestResponseDefender = zeros(1,blockNumber);
bestResponseDefender(1:ATTACKER_CAPACITY) = 0.5;%或者任意设置defender的初始策略
pureSetDefender(1,1:blockNumber) = bestResponseDefender;

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

    %在对方采取mixed srategy时，双方各自的best response获得的收益没有mixed srategy获得的收益大时，即为收敛
    convergeDefender = payoffBestDefender - payoffMixedDefender;
    convergeAttacker = payoffBestAttacker - payoffMixedAttacker;
    if ((convergeDefender < 0.0001) && (convergeAttacker < 0.0001) || (round == MAX_ROUNDS))
        break;  %收敛，跳出循环
    else
        %将双方最优纯策略作为新的一行加入到最优纯策略集合
        pureSetDefender = [pureSetDefender;bestResponseDefender];
        pureSetAttacker = [pureSetAttacker;bestResponseAttacker];
        
        if(round >= PURE_SET_SIZE)
            %               payoffDelete(mixedStrategyDefender,mixedStrategyAttacker);%在对方当前混合策略下，删除一个己方纯策略集合中收益最小的纯策略
            %               voteDelete(PURE_SET_SIZE,mixedStrategyDefender,mixedStrategyAttacker); %统计票数,删除票数最少的纯策略
            %               probaDelete(mixedStrategyDefender,mixedStrategyAttacker); %按照混合策略中概率排序，删除最小的纯策略
        end
        
        fprintf('round = %d, convergeDefender = %d, convergeAttacker = %d\n',round,convergeDefender,convergeAttacker);%未收敛，输出本轮计算结果
    end
end  %收敛，跳出循环
toc

%输出收敛结果
fprintf('round = %d, convergeDefender = %d, convergeAttacker = %d \n',round,convergeDefender,convergeAttacker);
fprintf('Ua(A,d) = %d, Ua(a,d) = %d, Ud(a,D) = %d, Ud(a,d) = %d \n',payoffBestDefender,payoffMixedDefender,payoffBestAttacker,payoffMixedAttacker);

%处理结果
result = resultProcess(round,logDefenderBestPayoff,logDefenderMixPayoff,logAttackerBestPayoff,mixedStrategyDefender,mixedStrategyAttacker);