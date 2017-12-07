function voteDelete(PURE_SET_SIZE,mixedStrategyDefender,mixedStrategyAttacker)
global pureSetDefender;
global pureSetAttacker;
global voteD;
global voteA;

%投票
for i = 1:PURE_SET_SIZE  %处理每一行
    if(mixedStrategyDefender(i) == 0)%概率为0，票数减一
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

pureSetDefender(lineD,:) = [];%删除最小的纯策略
pureSetAttacker(lineA,:) = [];

for j = lineD:(PURE_SET_SIZE - 1) %删除相应的vote,并将后面的补充到前面来
     voteD(j) = voteD(j+1);
end
for k = lineA:(PURE_SET_SIZE - 1) 
     voteA(k) = voteA(k+1);
end
voteD(PURE_SET_SIZE) = 0;
voteA(PURE_SET_SIZE) = 0;