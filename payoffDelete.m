function payoffDelete(mixedStrategyDefender,mixedStrategyAttacker)

global baseBlockNumber;
global f;
global REWARD;
global pureSetDefender;
global pureSetAttacker;

rowD = size(pureSetDefender,1);
rowA = size(pureSetAttacker,1);
for i = 1:rowD
    %defender
    %计算Ud(D,a)
    payoffBestDefender = 0;
    for j = 1:rowA %attacker的纯策略个数
        payoffBestD = 0;
        for k = 1:baseBlockNumber %defender纯策略中的元素个数
            pd = 1 - exp(-5 * pureSetDefender(i,k) * pureSetAttacker(j,k));
            pt = 1 - exp(-5 * pureSetDefender(i,k) * f(k));
            payoffBestD = payoffBestD + (1 - pd) * pt * REWARD;
        end
        payoffBestDefender = payoffBestDefender + payoffBestD * mixedStrategyAttacker(j);
    end
    defenderMaxPayoff(i) = payoffBestDefender;
    
    %attacker
    %计算Ua(d,A)
    payoffBestAttacker = 0;
    for j = 1:rowD %defender的纯策略个数
        payoffBestA = 0;
        for k = 1:baseBlockNumber %defender纯策略中的元素个数
            pd = 1 - exp(-5 * pureSetDefender(j,k) * pureSetAttacker(i,k));
            pt = 1 - exp(-5 * pureSetDefender(j,k) * f(k));
            payoffBestA = payoffBestA - (1 - pd) * pt * REWARD;
        end
        payoffBestAttacker = payoffBestAttacker + payoffBestA * mixedStrategyDefender(j);
    end
    attackerMaxPayoff(i) = payoffBestAttacker;
end

[~,lineD] = min(defenderMaxPayoff);%用min找到defender的payoff最小的纯策略
[~,lineA] = min(attackerMaxPayoff);%用min找到attacker的payoff最小的纯策略

pureSetDefender(lineD,:) = [];%删除最小的纯策略
pureSetAttacker(lineA,:) = [];


