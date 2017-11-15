%����defender��best response�����������attacker�Ļ�ϲ��ԡ�

%����˼·������attacker�Ĵ����Լ��Ϻͻ�ϲ��ԣ�defender���Եõ�ÿ��Ǳ�ڲ�������ʽ���溯����ֻ��һ��δ֪��d����
%          ����ÿ��Ǳ�ڲ���㣬�������溯���󵼣����������洦��d��������Ǳ�ڲ����������������ȡǰn���Ǳ�ڲ���㣬����bug
function [bestResponseDefender,payoffBestDefender] = computeDefenderBest(mixedStrategyAttacker)

%ȫ�ֱ���
global TOTAL_POTENTIAL_NUMBER;
global f;
global REWARD;
global ATTACKER_CAPACITY;
global pureSetAttacker;

payoffSet = zeros(1,TOTAL_POTENTIAL_NUMBER);
xSet = zeros(1,TOTAL_POTENTIAL_NUMBER);
options=optimset('display','off');%�������ɹ���Ϣ
for i = 1:TOTAL_POTENTIAL_NUMBER  %��ÿһ��Ǳ�ڲ���㣬���Ǳ�ڲ����ɻ�õ��������
 	[xmax,payoffmax]=fminbnd(@(x)payFunction(x,i),0,1,options);
	payoffSet(i) = - payoffmax;%ÿ��Ǳ�ڲ����ɻ�õ����payoff
    xSet(i) = xmax;%����ʹÿ��Ǳ�ڲ�������������Ĳ������
end

%���溯��
function y = payFunction(x,i)
    %��ÿ��Ǳ�ڲ���������attacker�Ļ�ϲ��Խ����ۼӣ���ø�Ǳ�ڲ��������溯��
    rowA = size(pureSetAttacker,1);
    y = 0;
	for j = 1:rowA 
        pd = 1 - exp(-5 * x * pureSetAttacker(j,i));
        pt = 1 - exp(-5 * x * f(i));
        y = y - ((1 - pd) * pt * REWARD * f(i)) * mixedStrategyAttacker(j);
    end
end

%������Ǳ�ڲ����ɻ�õ����payoff��������,ѡ��ǰn���Ǳ�ڲ����
bestResponseDefender(1:TOTAL_POTENTIAL_NUMBER) = 0;%��ʼ��defender��best response
payoffBestDefender = 0;
for k = 1:ATTACKER_CAPACITY
	[maxPayoff,position] = max(payoffSet);%�ҵ�����ֵ��λ��
    payoffSet(position) = -1;%����λ�õ�ֵ��Ϊ-1���Ա�Ѱ����һ�����ֵ
    bestResponseDefender(position) = xSet(position);%�����ֵ����a����best response������
    payoffBestDefender = payoffBestDefender + maxPayoff;%�����õ�payoff
end

% %����Ud(D,a)
% rowA = size(pureSetAttacker,1);
% payoffBestDefender = 0;
% for i = 1:rowA %attacker�Ĵ����Ը���
%     payoffBestD = 0;
%     for k = 1:TOTAL_POTENTIAL_NUMBER %defedner�������е�Ԫ�ظ���
%         pd = 1 - exp(-5 * bestResponseDefender(k) * pureSetAttacker(i,k));
%         pt = 1 - exp(-5 * bestResponseDefender(k) * f(k));
%         payoffBestD = payoffBestD + (1 - pd) * pt * REWARD;
%     end
%     payoffBestDefender = payoffBestDefender + payoffBestD * mixedStrategyAttacker(i);
% end
end
