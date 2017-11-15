%利用minimax计算双方的mixed strategy，输入参数是双方的best response的集合和当前轮数
function [payoffMixedDefender,payoffMixedAttacker,mixedStrategyDefender,mixedStrategyAttacker] =...
    computeMixedStrategy()
%全局变量
global f;
global REWARD;
global MAX_ROUNDS;
global TOTAL_POTENTIAL_NUMBER;
global pureSetDefender;
global pureSetAttacker;

%求解收益矩阵
payoff = zeros(MAX_ROUNDS,MAX_ROUNDS);%初始化收益计算矩阵，预先分配最大的空间
rowD = size(pureSetDefender,1);
rowA = size(pureSetAttacker,1);
for i = 1:rowD %defender 矩阵左
    for j = 1:rowA %attacker 矩阵上
       for k = 1:TOTAL_POTENTIAL_NUMBER %策略中的元素个数
           pd = 1 - exp(-5 * pureSetDefender(i,k) * pureSetAttacker(j,k));
           pt = 1 - exp(-5 * pureSetDefender(i,k) * f(k));
           payoff(i,j) = payoff(i,j) + ((1 - pd) * pt * REWARD);
        end
    end
end
%取出含有元素的矩阵块，作为真正的收益矩阵
row = size(pureSetDefender,1);%其实defender和attacker纯策略集合的大小是一样的，所以是方阵
for i = 1:row
    payoffMatrix(1:i,1:i) = payoff(1:i,1:i);
end

%defender线性规划求解
fA = ones(row,1);%目标函数
AA = - payoffMatrix';%不等式左侧
bA = - ones(row,1);%不等式右侧
lbA = zeros(row,1);%大于零
options=optimset('display','off');%隐藏“Optimization terminated”
[xDefender,maxDefender] = linprog(fA,AA,bA,[],[],lbA,[],[],options);
mixedStrategyDefender = xDefender / maxDefender;
payoffMixedDefender = 1 / maxDefender;

%attacker线性规划求解
fD = - ones(row,1);%目标函数
AD = payoffMatrix;%不等式左侧
bD = ones(row,1);%不等式右侧
lbD = zeros(row,1);%大于零
[xAttacker,maxAttacker] = linprog(fD,AD,bD,[],[],lbD,[],[],options);
mixedStrategyAttacker = xAttacker' / -maxAttacker;
payoffMixedAttacker = 1 / maxAttacker;

