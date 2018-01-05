function probaDelete(mixedStrategyDefender,mixedStrategyAttacker)
global pureSetDefender;
global pureSetAttacker;

[~,lineD] = min(mixedStrategyDefender); 
[~,lineA] = min(mixedStrategyAttacker); 

pureSetDefender(lineD,:) = [];%删除最小的纯策略
pureSetAttacker(lineA,:) = [];