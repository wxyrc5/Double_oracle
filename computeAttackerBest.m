%����defedner��best response�����������defender�Ļ�ϲ��Ժ͵�ǰ����
function [bestResponseAttacker,maxPayoffAttacker] = computeAttackerBest(mixedStrategyDefender)

%ȫ�ֱ���
global blockNumber;
global f;
global REWARD;
global cfgRelation1;
global cfgRelation2;
global pureSetDefender;

%attacker�����棬Ŀ�꺯��
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

x0 = zeros(blockNumber,1);%x�ĳ�ʼֵ
Aeq = cfgRelation1;%��ʽ���
Beq = cfgRelation2;%��ʽ�ұ�
lb = zeros(blockNumber,1);%x������ֵ
ub = ones(blockNumber,1);%x������ֵ
options=optimset('display','off');%�������ɹ���Ϣ
%����ֵ
[best,maxPayoff] = fmincon(@(x)payoffFunction(x),x0,[],[],Aeq,Beq,lb,ub,[],options);%����Сֵ
bestResponseAttacker = best';
maxPayoffAttacker = - maxPayoff;

end





