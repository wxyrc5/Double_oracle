%����defedner��best response�����������defender�Ļ�ϲ��Ժ͵�ǰ����
function [bestResponseAttacker,maxPayoffAttacker] = computeAttackerBest(mixedStrategyDefender)

%ȫ�ֱ���
global TOTAL_POTENTIAL_NUMBER;
global f;
global REWARD;
global pathRelationPart1;
global pathRelationPart2;
global pureSetDefender;

%attacker�����棬Ŀ�꺯��
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

x0 = zeros(TOTAL_POTENTIAL_NUMBER,1);%x�ĳ�ʼֵ
Aeq = pathRelationPart1;%��ʽ���
Beq = pathRelationPart2;%��ʽ�ұ�
lb = zeros(TOTAL_POTENTIAL_NUMBER,1);%x������ֵ
ub = ones(TOTAL_POTENTIAL_NUMBER,1);%x������ֵ
options=optimset('display','off');%�������ɹ���Ϣ
%����ֵ
[best,maxPayoff] = fmincon(@(x)payoffFunction(x),x0,[],[],Aeq,Beq,lb,ub,[],options);%����Сֵ
bestResponseAttacker = best';
maxPayoffAttacker = - maxPayoff;


% %����Ua(d,A)
% row = size(pureSetDefender,1);
% maxPayoffAttacker = 0;
% for l = 1:row %defender�Ĵ����Ը���
%     maxPayoffA = 0;
%     for k = 1:TOTAL_POTENTIAL_NUMBER %defender�������е�Ԫ�ظ���
%         pd = 1 - exp(-5 * pureSetDefender(l,k) * bestResponseAttacker(k));
%         pt = 1 - exp(-5 * pureSetDefender(l,k) * f(k));
%         maxPayoffA = maxPayoffA - (1 - pd) * pt * REWARD;
%     end
%     maxPayoffAttacker = maxPayoffAttacker + maxPayoffA * mixedStrategyDefender(l);
% end

end





