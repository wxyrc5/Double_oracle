function probaDelete(mixedStrategyDefender,mixedStrategyAttacker)
global pureSetDefender;
global pureSetAttacker;

[~,lineD] = min(mixedStrategyDefender); 
[~,lineA] = min(mixedStrategyAttacker); 

pureSetDefender(lineD,:) = [];%ɾ����С�Ĵ�����
pureSetAttacker(lineA,:) = [];