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
    %����Ud(D,a)
    payoffBestDefender = 0;
    for j = 1:rowA %attacker�Ĵ����Ը���
        payoffBestD = 0;
        for k = 1:baseBlockNumber %defender�������е�Ԫ�ظ���
            pd = 1 - exp(-5 * pureSetDefender(i,k) * pureSetAttacker(j,k));
            pt = 1 - exp(-5 * pureSetDefender(i,k) * f(k));
            payoffBestD = payoffBestD + (1 - pd) * pt * REWARD;
        end
        payoffBestDefender = payoffBestDefender + payoffBestD * mixedStrategyAttacker(j);
    end
    defenderMaxPayoff(i) = payoffBestDefender;
    
    %attacker
    %����Ua(d,A)
    payoffBestAttacker = 0;
    for j = 1:rowD %defender�Ĵ����Ը���
        payoffBestA = 0;
        for k = 1:baseBlockNumber %defender�������е�Ԫ�ظ���
            pd = 1 - exp(-5 * pureSetDefender(j,k) * pureSetAttacker(i,k));
            pt = 1 - exp(-5 * pureSetDefender(j,k) * f(k));
            payoffBestA = payoffBestA - (1 - pd) * pt * REWARD;
        end
        payoffBestAttacker = payoffBestAttacker + payoffBestA * mixedStrategyDefender(j);
    end
    attackerMaxPayoff(i) = payoffBestAttacker;
end

[~,lineD] = min(defenderMaxPayoff);%��min�ҵ�defender��payoff��С�Ĵ�����
[~,lineA] = min(attackerMaxPayoff);%��min�ҵ�attacker��payoff��С�Ĵ�����

pureSetDefender(lineD,:) = [];%ɾ����С�Ĵ�����
pureSetAttacker(lineA,:) = [];


