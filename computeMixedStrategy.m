%����minimax����˫����mixed strategy�����������˫����best response�ļ��Ϻ͵�ǰ����
function [payoffMixedDefender,payoffMixedAttacker,mixedStrategyDefender,mixedStrategyAttacker] =...
    computeMixedStrategy()
%ȫ�ֱ���
global f;
global REWARD;
global MAX_ROUNDS;
global TOTAL_POTENTIAL_NUMBER;
global pureSetDefender;
global pureSetAttacker;

%����������
payoff = zeros(MAX_ROUNDS,MAX_ROUNDS);%��ʼ������������Ԥ�ȷ������Ŀռ�
rowD = size(pureSetDefender,1);
rowA = size(pureSetAttacker,1);
for i = 1:rowD %defender ������
    for j = 1:rowA %attacker ������
       for k = 1:TOTAL_POTENTIAL_NUMBER %�����е�Ԫ�ظ���
           pd = 1 - exp(-5 * pureSetDefender(i,k) * pureSetAttacker(j,k));
           pt = 1 - exp(-5 * pureSetDefender(i,k) * f(k));
           payoff(i,j) = payoff(i,j) + ((1 - pd) * pt * REWARD);
        end
    end
end
%ȡ������Ԫ�صľ���飬��Ϊ�������������
row = size(pureSetDefender,1);%��ʵdefender��attacker�����Լ��ϵĴ�С��һ���ģ������Ƿ���
for i = 1:row
    payoffMatrix(1:i,1:i) = payoff(1:i,1:i);
end

%defender���Թ滮���
fA = ones(row,1);%Ŀ�꺯��
AA = - payoffMatrix';%����ʽ���
bA = - ones(row,1);%����ʽ�Ҳ�
lbA = zeros(row,1);%������
options=optimset('display','off');%���ء�Optimization terminated��
[xDefender,maxDefender] = linprog(fA,AA,bA,[],[],lbA,[],[],options);
mixedStrategyDefender = xDefender / maxDefender;
payoffMixedDefender = 1 / maxDefender;

%attacker���Թ滮���
fD = - ones(row,1);%Ŀ�꺯��
AD = payoffMatrix;%����ʽ���
bD = ones(row,1);%����ʽ�Ҳ�
lbD = zeros(row,1);%������
[xAttacker,maxAttacker] = linprog(fD,AD,bD,[],[],lbD,[],[],options);
mixedStrategyAttacker = xAttacker' / -maxAttacker;
payoffMixedAttacker = 1 / maxAttacker;

