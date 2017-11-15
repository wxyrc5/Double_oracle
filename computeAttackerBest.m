%计算defedner的best response，输入参数是defender的混合策略和当前轮数
function [bestResponseAttacker,maxPayoffAttacker] = computeAttackerBest(mixedStrategyDefender)

%全局变量
global TOTAL_POTENTIAL_NUMBER;
global f;
global REWARD;
global pathRelationPart1;
global pathRelationPart2;
global pureSetDefender;

%attacker的收益，目标函数
function  y = payoffFunction(x)
    y = 0;
    row = size(pureSetDefender,1);
    for i = 1:TOTAL_POTENTIAL_NUMBER
        for j = 1:row
            pd = 1 - exp(-5 * pureSetDefender(j,i) * x(i));
            pt = 1 - exp(-5 * pureSetDefender(j,i) * f(i));
            y = y + ((1 - pd) * pt * REWARD * f(i)) * mixedStrategyDefender(j);
        end
    end
end

x0 = zeros(TOTAL_POTENTIAL_NUMBER,1);%x的初始值
Aeq = pathRelationPart1;%等式左边
Beq = pathRelationPart2;%等式右边
lb = zeros(TOTAL_POTENTIAL_NUMBER,1);%x的下限值
ub = ones(TOTAL_POTENTIAL_NUMBER,1);%x的上限值
options=optimset('display','off');%隐藏求解成功信息
%求最值
[best,maxPayoff] = fmincon(@(x)payoffFunction(x),x0,[],[],Aeq,Beq,lb,ub,[],options);%求最小值
bestResponseAttacker = best';
maxPayoffAttacker = - maxPayoff;


% %计算Ua(d,A)
% row = size(pureSetDefender,1);
% maxPayoffAttacker = 0;
% for l = 1:row %defender的纯策略个数
%     maxPayoffA = 0;
%     for k = 1:TOTAL_POTENTIAL_NUMBER %defender纯策略中的元素个数
%         pd = 1 - exp(-5 * pureSetDefender(l,k) * bestResponseAttacker(k));
%         pt = 1 - exp(-5 * pureSetDefender(l,k) * f(k));
%         maxPayoffA = maxPayoffA - (1 - pd) * pt * REWARD;
%     end
%     maxPayoffAttacker = maxPayoffAttacker + maxPayoffA * mixedStrategyDefender(l);
% end

end





