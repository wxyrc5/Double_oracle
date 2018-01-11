%计算defedner的best response，输入参数是defender的混合策略和当前轮数
function [bestResponseAttacker,maxPayoffAttacker] = computeAttackerBest(mixedStrategyDefender)

%全局变量
global blockNumber;
global f;
global REWARD;
global cfgRelation1;
global cfgRelation2;
global pureSetDefender;

%attacker的收益，目标函数
function  y = payoffFunction(x)
    y = 0;
    row = size(pureSetDefender,1);
    for i = 1:blockNumber
        for j = 1:row
            pd = 1 - exp(-5 * pureSetDefender(j,i) * x(i));
            pt = 1 - exp(-5 * pureSetDefender(j,i) * f(i));
            y = y + ((1 - pd) * pt * REWARD) * mixedStrategyDefender(j);
        end
    end
end

x0 = zeros(blockNumber,1);%x的初始值
Aeq = cfgRelation1;%等式左边
Beq = cfgRelation2;%等式右边
lb = zeros(blockNumber,1);%x的下限值
ub = ones(blockNumber,1);%x的上限值
options=optimset('display','off');%隐藏求解成功信息
%求最值
[best,maxPayoff] = fmincon(@(x)payoffFunction(x),x0,[],[],Aeq,Beq,lb,ub,[],options);%求最小值
bestResponseAttacker = best';
maxPayoffAttacker = - maxPayoff;

end





