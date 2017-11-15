clc;
clear all;
close all;

%����ȫ�ֱ���
global TOTAL_POTENTIAL_NUMBER;
global ATTACKER_CAPACITY;
global REWARD;
global MAX_ROUNDS;
global pathRelationPart1;
global pathRelationPart2;
global f;
global pureSetDefender;
global pureSetAttacker;

REWARD = 10;   %��һ��bug��������defender��õ�����
MAX_ROUNDS = 150;%���������Ϊ��Ԥ�������ڴ�ռ䣬Ҳ��ֹ��ѭ��

%����·����״
%�ó���·���еĽ�������Ⱥͳ�������ʾ·��֮��Ĺ�ϵ������
%�þ����ʾ��ÿ�д���һ������㣬ÿ�д���һ��·�������Ϊ-1������Ϊ1

% pathRelationPart1 = [1 1 0 0 0 0; -1 0 1 1 0 0; 0 -1 0 -1 1 1];%3������㣬6��·��
% pathRelationPart2 = [1; 0; 0];
% f = [0.2 0.8 0.1 0.1 0.5 0.4];  %��ʾ��û�в�ȡ�κβ��ԣ�������нṹ������fuzzing��Դ���ķ������
% TOTAL_POTENTIAL_NUMBER = 6;   %�����е�·����������Ǳ�ڲ��������
% ATTACKER_CAPACITY  = TOTAL_POTENTIAL_NUMBER/3;  %defender����ܲ����bug��

% pathRelationPart1 = [1 1];%1������㣬2��·��
% pathRelationPart2 = [1];
% f = [0.6 0.4];  %��ʾ��û�в�ȡ�κβ��ԣ�������нṹ������fuzzing��Դ���ķ������
% TOTAL_POTENTIAL_NUMBER = 2;   %�����е�·����������Ǳ�ڲ��������
% ATTACKER_CAPACITY  = 1;  %defender����ܲ����bug��


%��ʽ���
pathRelationPart1 = zeros(10,24);%10������㣬24��·��
%point1
pathRelationPart1(1,1:3) = 1;
%point2
pathRelationPart1(2,1) = -1;
pathRelationPart1(2,4:6) = 1;

pathRelationPart1(3,2) = -1;
pathRelationPart1(3,7:9) = 1;

pathRelationPart1(4,3) = -1;
pathRelationPart1(4,10:11) = 1;

pathRelationPart1(5,5) = -1;
pathRelationPart1(5,12) = -1;
pathRelationPart1(5,14:15) = 1;

pathRelationPart1(6,6:7) = -1;
pathRelationPart1(6,12:13) = 1;

pathRelationPart1(7,9:10) = -1;
pathRelationPart1(7,16:18) = 1;

pathRelationPart1(8,13) = -1;
pathRelationPart1(8,8) = -1;
pathRelationPart1(8,19:20) = 1;

pathRelationPart1(9,20) = -1;
pathRelationPart1(9,16) = -1;
pathRelationPart1(9,21:22) = 1;

pathRelationPart1(10,19) = -1;
pathRelationPart1(10,21) = -1;
pathRelationPart1(10,23:24) = 1;

%��ʽ�Ҳ�
pathRelationPart2 = zeros(10,1);
pathRelationPart2(1) = 1;

f = [0.6 0.3 0.1 0.1 0.2 0.3 0.15 0.1 0.05 0.07 0.03 0.15...
     0.3 0.25 0.1 0.05 0.03 0.04 0.25 0.15 0.13 0.07 0.14 0.24];
TOTAL_POTENTIAL_NUMBER = 24;   %�����е�·����������Ǳ�ڲ��������
ATTACKER_CAPACITY  = TOTAL_POTENTIAL_NUMBER/6;  %defender����ܲ����bug��

%����attacker��ʼ����
% bestResponseAttacker = [0.3 0.7 0.2 0.1 0.3 0.5];%�������ü����Դ�������
% bestResponseAttacker = [0.8 0.2];
bestResponseAttacker = f;  %���߽�attacker��ʼ��������Ϊ������з������
pureSetAttacker(1,1:TOTAL_POTENTIAL_NUMBER) = bestResponseAttacker;

%����defender�ĳ�ʼ����
% bestResponseDefender = [0 0 0.1 0 0.9 0];  %������������defender�ĳ�ʼ����
% bestResponseDefender = [0 0.1];
bestResponseDefender = zeros(1,24);
bestResponseDefender(4:7) = 0.5;%������������defender�ĳ�ʼ����
pureSetDefender(1,1:TOTAL_POTENTIAL_NUMBER) = bestResponseDefender;

tic;
%��ѭ����ֱ������
for round = 1:MAX_ROUNDS
    
    %ͨ�������Ŵ����Լ��Ͻ���minimax��⣬���˫�����Ż�ϲ���
    [payoffMixedDefender,payoffMixedAttacker,mixedStrategyDefender,mixedStrategyAttacker] = computeMixedStrategy(pureSetDefender,pureSetAttacker);
    
    %����˫�����Ŵ�����
    [bestResponseAttacker,payoffBestAttacker] = computeAttackerBest(mixedStrategyDefender);
    [bestResponseDefender,payoffBestDefender] = computeDefenderBest(mixedStrategyAttacker);
    
    %��¼minimax����
    logDefenderMixPayoff(round) = payoffMixedDefender;
    logAttackerMixPayoff(round) = payoffMixedAttacker;
    %��¼best����
    logDefenderBestPayoff(round) = payoffBestDefender;
    logAttackerBestPayoff(round) = payoffBestAttacker;

    %�ж�����
    %�ڶԷ���ȡmixed srategyʱ��˫�����Ե�best response��õ�����û��mixed srategy��õ������ʱ����Ϊ����
    convergeDefender = payoffBestDefender - payoffMixedDefender;
    convergeAttacker = payoffBestAttacker - payoffMixedAttacker;
    if ((convergeDefender < 0.001) && (convergeAttacker < 0.001) || (round == MAX_ROUNDS))   
        break;  %����������ѭ��
    else
%         if(round > 10)  %�ڶԷ���ǰ��ϲ����£�ɾ��һ�����������Լ�����������С�Ĵ�����
%             deleteStrategy(mixedStrategyDefender,mixedStrategyAttacker);
%         end

        %��˫�����Ŵ�������Ϊ�µ�һ�м��뵽���Ŵ����Լ���
        pureSetDefender = [pureSetDefender;bestResponseDefender];
        pureSetAttacker = [pureSetAttacker;bestResponseAttacker];

        fprintf('round = %d, convergeDefender = %d, convergeAttacker = %d\n',round,convergeDefender,convergeAttacker);%δ������������ּ�����
    end
end

toc %��¼����ʱ��

%��¼�������
fprintf('round = %d, convergeDefender = %d, convergeAttacker = %d \n',round,convergeDefender,convergeAttacker);
fprintf('Ua(A,d) = %d, Ua(a,d) = %d, Ud(a,D) = %d, Ud(a,d) = %d \n',payoffBestDefender,payoffMixedDefender,payoffBestAttacker,payoffMixedAttacker);

%���ƽ��ͼ��
x = 1:round;
% plot(x,logDefenderBestPayoff,'-rs',x,logDefenderMixPayoff,':ko',x,-logAttackerBestPayoff,'-.b^');
% legend('defender best','minimax','attacker best'); % ���߱�ʶ
% 
subplot(2,1,1);
plot(x,logDefenderBestPayoff,'-rs',x,logDefenderMixPayoff,':kh');
legend('best response  Ud(D,a)','mixed strategy  Ud(d,a)'); % ���߱�ʶ
title('Defender'); % С����

subplot(2,1,2);
plot(x,logAttackerBestPayoff,'-.b^',x, logAttackerMixPayoff,'--k*');
legend('best response  Ua(d,A)','mixed strategy  Ua(d,a)'); % ���߱�ʶ
title('Attacker'); % С����

%��¼���ջ�ϲ���
row = size(pureSetDefender,1);
for i = 1:row
    %defender
    result(i,1:TOTAL_POTENTIAL_NUMBER) = pureSetDefender(i,1:TOTAL_POTENTIAL_NUMBER);%������
    result(i,TOTAL_POTENTIAL_NUMBER+2) = roundn(mixedStrategyDefender(i),-4);%��ϲ��Ը���
    %attacker
    result(i,TOTAL_POTENTIAL_NUMBER+4:2*TOTAL_POTENTIAL_NUMBER+3) = pureSetAttacker(i,1:TOTAL_POTENTIAL_NUMBER);
    result(i,2*TOTAL_POTENTIAL_NUMBER+5) = roundn(mixedStrategyAttacker(i),-4);    
end
fprintf('Done! \n');



