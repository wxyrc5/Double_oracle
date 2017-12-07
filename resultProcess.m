function result = resultProcess(round,logDefenderBestPayoff,logDefenderMixPayoff,logAttackerBestPayoff,mixedStrategyDefender,mixedStrategyAttacker)
global pureSetDefender;
global pureSetAttacker;
global TOTAL_POTENTIAL_NUMBER;

%���ƽ��ͼ��
x = 1:round;
plot(x,logDefenderBestPayoff,'-rs',x,logDefenderMixPayoff,':ko',x,-logAttackerBestPayoff,'-.b^');
legend('defender best','minimax','attacker best'); % ���߱�ʶ

%��¼���ջ�ϲ���(ֻ������ϲ��Դ���0.001����Щ������)
m = 1;
rowD = size(pureSetDefender,1);
for i = 1:rowD
    if(roundn(mixedStrategyDefender(i),-4) > 0.001)
        result(m,1:TOTAL_POTENTIAL_NUMBER) = pureSetDefender(i,1:TOTAL_POTENTIAL_NUMBER);%������
        result(m,TOTAL_POTENTIAL_NUMBER+1) = roundn(mixedStrategyDefender(i),-4);%��ϲ��Ը���
        m = m+1;
    end
end
m = m+1;
rowA = size(pureSetAttacker,1);
for i = 1:rowA
    if(roundn(mixedStrategyAttacker(i),-4) > 0.001)
        result(m,1:TOTAL_POTENTIAL_NUMBER) = pureSetAttacker(i,1:TOTAL_POTENTIAL_NUMBER);%������
        result(m,TOTAL_POTENTIAL_NUMBER+1) = roundn(mixedStrategyAttacker(i),-4);%��ϲ��Ը���
        m = m+1;
    end
end

% %��¼���ջ�ϲ���
% rowD = size(pureSetDefender,1);
% for i = 1:rowD
%         %defender
%         result(i,1:TOTAL_POTENTIAL_NUMBER) = pureSetDefender(i,1:TOTAL_POTENTIAL_NUMBER);%������
%         result(i,TOTAL_POTENTIAL_NUMBER+2) = roundn(mixedStrategyDefender(i),-4);%��ϲ��Ը���
%         %attacker
%         result(i,TOTAL_POTENTIAL_NUMBER+4:2*TOTAL_POTENTIAL_NUMBER+3) = pureSetAttacker(i,1:TOTAL_POTENTIAL_NUMBER);
%         result(i,2*TOTAL_POTENTIAL_NUMBER+5) = roundn(mixedStrategyAttacker(i),-4);
% end


% subplot(2,1,1);
% plot(x,logDefenderBestPayoff,'-rs',x,logDefenderMixPayoff,':kh');
% legend('best response  Ud(D,a)','mixed strategy  Ud(d,a)'); % ���߱�ʶ
% title('Defender'); % С����
%
% subplot(2,1,2);
% plot(x,logAttackerBestPayoff,'-.b^',x, logAttackerMixPayoff,'--k*');
% legend('best response  Ua(d,A)','mixed strategy  Ua(d,a)'); % ���߱�ʶ
% title('Attacker'); % С����