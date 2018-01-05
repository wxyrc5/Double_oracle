%����defender��best response�����������attacker�Ļ�ϲ��ԡ�

%����˼·������attacker�Ĵ����Լ��Ϻͻ�ϲ��ԣ�defender���Եõ�ÿ��Ǳ�ڲ�������ʽ���溯����ֻ��һ��δ֪��d����
%          ����ÿ��Ǳ�ڲ���㣬�������溯���󵼣����������洦��d��������Ǳ�ڲ����������������ȡǰn���Ǳ�ڲ���㣬����bug
function [bestResponseDefender,payoffBestDefender] = computeDefenderBest(mixedStrategyAttacker)

%ȫ�ֱ���
global baseBlockNumber;
global f;
global REWARD;
global ATTACKER_CAPACITY;
global pureSetAttacker;

payoffSet = zeros(1,baseBlockNumber);
xSet = zeros(1,baseBlockNumber);
options=optimset('display','off');%�������ɹ���Ϣ
for i = 1:baseBlockNumber  %��ÿһ��Ǳ�ڲ���㣬���Ǳ�ڲ����ɻ�õ��������
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
        y = y - ((1 - pd) * pt * REWARD) * mixedStrategyAttacker(j);
    end
end

%������Ǳ�ڲ����ɻ�õ����payoff��������,ѡ��ǰn���Ǳ�ڲ����
bestResponseDefender(1:baseBlockNumber) = 0;%��ʼ��defender��best response
payoffBestDefender = 0;
for k = 1:ATTACKER_CAPACITY
	[maxPayoff,position] = max(payoffSet);%�ҵ�����ֵ��λ��
    payoffSet(position) = -1;%����λ�õ�ֵ��Ϊ-1���Ա�Ѱ����һ�����ֵ
    bestResponseDefender(position) = xSet(position);%�����ֵ����a����best response������
    payoffBestDefender = payoffBestDefender + maxPayoff;%�����õ�payoff
end

end

