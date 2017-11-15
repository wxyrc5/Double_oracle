%计算defender的best response，输入参数是attacker的混合策略。

%函数思路：给定attacker的纯策略集合和混合策略，defender可以得到每个潜在插入点的显式收益函数（只有一个未知数d）。
%          对于每个潜在插入点，对其收益函数求导，求出最大收益处的d。将所有潜在插入点的收益进行排序，取前n大的潜在插入点，部署bug
function [bestResponseDefender,payoffBestDefender] = computeDefenderBest(mixedStrategyAttacker)

%全局变量
global TOTAL_POTENTIAL_NUMBER;
global f;
global REWARD;
global ATTACKER_CAPACITY;
global pureSetAttacker;

payoffSet = zeros(1,TOTAL_POTENTIAL_NUMBER);
xSet = zeros(1,TOTAL_POTENTIAL_NUMBER);
options=optimset('display','off');%隐藏求解成功信息
for i = 1:TOTAL_POTENTIAL_NUMBER  %对每一个潜在插入点，求该潜在插入点可获得的最大收益
 	[xmax,payoffmax]=fminbnd(@(x)payFunction(x,i),0,1,options);
	payoffSet(i) = - payoffmax;%每个潜在插入点可获得的最大payoff
    xSet(i) = xmax;%可以使每个潜在插入点获得最大收益的插入深度
end

%收益函数
function y = payFunction(x,i)
    %对每个潜在插入点的所有attacker的混合策略进行累加，求得该潜在插入点的收益函数
    rowA = size(pureSetAttacker,1);
    y = 0;
	for j = 1:rowA 
        pd = 1 - exp(-5 * x * pureSetAttacker(j,i));
        pt = 1 - exp(-5 * x * f(i));
        y = y - ((1 - pd) * pt * REWARD * f(i)) * mixedStrategyAttacker(j);
    end
end

%对所有潜在插入点可获得的最大payoff进行排序,选出前n大的潜在插入点
bestResponseDefender(1:TOTAL_POTENTIAL_NUMBER) = 0;%初始化defender的best response
payoffBestDefender = 0;
for k = 1:ATTACKER_CAPACITY
	[maxPayoff,position] = max(payoffSet);%找到最大的值的位置
    payoffSet(position) = -1;%将该位置的值改为-1，以便寻找下一个最大值
    bestResponseDefender(position) = xSet(position);%将最大值处的a放入best response策略中
    payoffBestDefender = payoffBestDefender + maxPayoff;%计算获得的payoff
end

% %计算Ud(D,a)
% rowA = size(pureSetAttacker,1);
% payoffBestDefender = 0;
% for i = 1:rowA %attacker的纯策略个数
%     payoffBestD = 0;
%     for k = 1:TOTAL_POTENTIAL_NUMBER %defedner纯策略中的元素个数
%         pd = 1 - exp(-5 * bestResponseDefender(k) * pureSetAttacker(i,k));
%         pt = 1 - exp(-5 * bestResponseDefender(k) * f(k));
%         payoffBestD = payoffBestD + (1 - pd) * pt * REWARD;
%     end
%     payoffBestDefender = payoffBestDefender + payoffBestD * mixedStrategyAttacker(i);
% end
end

