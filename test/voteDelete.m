function voteDelete(PURE_SET_SIZE,mixedStrategyDefender,mixedStrategyAttacker)
global pureSetDefender;
global pureSetAttacker;
global voteD;
global voteA;

%ͶƱ
for i = 1:PURE_SET_SIZE  %����ÿһ��
    if(mixedStrategyDefender(i) == 0)%����Ϊ0��Ʊ����һ
        voteD(i) = voteD(i)-1;
    else
        voteD(i) = voteD(i)+1;
    end
    
    if(mixedStrategyAttacker(i) == 0)%
        voteA(i) = voteA(i)-1;
    else
        voteA(i) = voteA(i)+1;
    end
end

[~,lineD] = min(voteD);
[~,lineA] = min(voteA);

pureSetDefender(lineD,:) = [];%ɾ����С�Ĵ�����
pureSetAttacker(lineA,:) = [];

for j = lineD:(PURE_SET_SIZE - 1) %ɾ����Ӧ��vote,��������Ĳ��䵽ǰ����
     voteD(j) = voteD(j+1);
end
for k = lineA:(PURE_SET_SIZE - 1) 
     voteA(k) = voteA(k+1);
end
voteD(PURE_SET_SIZE) = 0;
voteA(PURE_SET_SIZE) = 0;