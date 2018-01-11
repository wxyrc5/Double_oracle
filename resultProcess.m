function result = resultProcess(round,logDefenderBestPayoff,logDefenderMixPayoff,logAttackerBestPayoff,mixedStrategyDefender,mixedStrategyAttacker)
global pureSetDefender;
global pureSetAttacker;
global blockNumber;
global allBaseBlock;

%��¼���ջ�ϲ���(ֻ������ϲ��Դ���0.001����Щ������)
m = 1;
rowD = size(pureSetDefender,1);
for i = 1:rowD
    if(roundn(mixedStrategyDefender(i),-4) > 0.001)
        result(m,1:blockNumber) = pureSetDefender(i,1:blockNumber);%������
        result(m,blockNumber+1) = roundn(mixedStrategyDefender(i),-4);%��ϲ��Ը���
        m = m+1;
    end
end

fid=fopen('bug_postion.txt','wt');%��Ҫ����bug��λ�ú��޸ĳ���д���ļ�
tmp = [allBaseBlock result(:,1:blockNumber)'];
[m,n]=size(tmp);
 for i=1:1:m
    for j=1:1:n
       if j==n
         fprintf(fid,'%g\n',tmp(i,j));
      else
        fprintf(fid,'%g\t\t\t\t',tmp(i,j));
       end
    end
end
fclose(fid);

m = m+1;
rowA = size(pureSetAttacker,1);
for i = 1:rowA
    if(roundn(mixedStrategyAttacker(i),-4) > 0.001)
        result(m,1:blockNumber) = pureSetAttacker(i,1:blockNumber);%������
        result(m,blockNumber+1) = roundn(mixedStrategyAttacker(i),-4);%��ϲ��Ը���
        m = m+1;
    end
end

%���ƽ��ͼ��
x = 1:round;

subplot(2,1,1);
plot(x,logDefenderBestPayoff,'-bs',x,logDefenderMixPayoff,':kh');
legend('best response  Ud(D,a)','mixed strategy  Ud(d,a)'); % ���߱�ʶ
title('Defender'); % С����

subplot(2,1,2);
plot(x,logAttackerBestPayoff,'-.r^',x, -logDefenderMixPayoff,'--k*');
legend('best response  Ua(d,A)','mixed strategy  Ua(d,a)'); % ���߱�ʶ
title('Attacker'); % С����

% plot(x,logDefenderBestPayoff,'-bs',x,logDefenderMixPayoff,':ko',x,-logAttackerBestPayoff,'-.r^');
% legend('defender best','minimax','attacker best'); % ���߱�ʶ