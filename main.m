clc;
close all;
clear;
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
pureSetDefender(:,:) = [];
pureSetAttacker(:,:) = [];

REWARD = 10;  %��һ��bug��������defender��õ�����
MAX_ROUNDS = 200; %���������Ϊ��Ԥ�������ڴ�ռ䣬Ҳ��ֹ��ѭ��
% PURE_SET_SIZE = 90; %�����Կռ䱣�������Ը���

%����·����״
%�ó���·���еĽ�������Ⱥͳ�������ʾ·��֮��Ĺ�ϵ������
%�þ����ʾ��ÿ�д���һ������㣬ÿ�д���һ��·�������Ϊ-1������Ϊ1
pathRelationPart1 = xlsread('24.xlsx');%��ʽ���
pathRelationPart2 = zeros(10,1);%��ʽ�Ҳ�
pathRelationPart2(1) = 1;

f = [0.6 0.3 0.1 0.1 0.2 0.3 0.15 0.1 0.05 0.07 0.03 0.15...
     0.3 0.25 0.1 0.05 0.03 0.04 0.25 0.15 0.13 0.07 0.14 0.24];
TOTAL_POTENTIAL_NUMBER = 24;  %�����е�·����������Ǳ�ڲ��������
ATTACKER_CAPACITY  = TOTAL_POTENTIAL_NUMBER/8;  %defender����ܲ����bug��

%����attacker��ʼ����
bestResponseAttacker = [0.4 0.3 0.3 0.1 0.2 0.1 0.1 0.1 0.1 0.2 0.1 0.05...
     0.15 0.15 0.1 0.1 0.1 0.1 0.1 0.15 0.15 0.1 0.15 0.1];
pureSetAttacker(1,1:TOTAL_POTENTIAL_NUMBER) = bestResponseAttacker;

%����defender�ĳ�ʼ����
bestResponseDefender = zeros(1,TOTAL_POTENTIAL_NUMBER);
bestResponseDefender(10:10+ATTACKER_CAPACITY-1) = 0.9;%������������defender�ĳ�ʼ����
pureSetDefender(1,1:TOTAL_POTENTIAL_NUMBER) = bestResponseDefender;

logMixedStrategyDefender = zeros(MAX_ROUNDS);
logMixedStrategyAttacker = zeros(MAX_ROUNDS);
avelogMixedStrategyDefender = logMixedStrategyDefender;
avelogMixedStrategyAttacker = logMixedStrategyAttacker;
%��ѭ����ֱ������
tic;
for round = 1:MAX_ROUNDS
    
    %ͨ�������Ŵ����Լ��Ͻ���minimax��⣬���˫�����Ż�ϲ���
    [payoffMixedDefender,payoffMixedAttacker,mixedStrategyDefender,mixedStrategyAttacker] = computeMixedStrategy();
    mixedStrategyDefender = roundn(mixedStrategyDefender,-4); 
    mixedStrategyAttacker = roundn(mixedStrategyAttacker,-4);
    
    %����˫�����Ŵ�����
    [bestResponseDefender,payoffBestDefender] = computeDefenderBest(mixedStrategyAttacker);
    [bestResponseAttacker,payoffBestAttacker] = computeAttackerBest(mixedStrategyDefender);
    bestResponseDefender = roundn(bestResponseDefender,-4);
    bestResponseAttacker = roundn(bestResponseAttacker,-4);
    
    %��¼mixed strategy
    logMixedStrategyDefender(1:round,round*2-1) = mixedStrategyDefender; 
    logMixedStrategyAttacker(1:round,round*2-1) = mixedStrategyAttacker; 
    
    totallogMixedStrategyDefender = sum(logMixedStrategyDefender,2);%��ÿ�����
    totallogMixedStrategyAttacker = sum(logMixedStrategyAttacker,2);
    for i = 1:round  %��ÿһ����ƽ��
        avelogMixedStrategyDefender(i,round*2) = totallogMixedStrategyDefender(i)/(round-i+1);
        avelogMixedStrategyAttacker(i,round*2) = totallogMixedStrategyAttacker(i)/(round-i+1);
    end
%     %��¼minimax����
%     logDefenderMixPayoff(round) = payoffMixedDefender;
%     logAttackerMixPayoff(round) = payoffMixedAttacker;
%     %��¼best����
%     logDefenderBestPayoff(round) = payoffBestDefender;
%     logAttackerBestPayoff(round) = payoffBestAttacker;
    
    %�ж�����
    %�ڶԷ���ȡmixed srategyʱ��˫�����Ե�best response��õ�����û��mixed srategy��õ������ʱ����Ϊ����
    convergeDefender = payoffBestDefender - payoffMixedDefender;
    convergeAttacker = payoffBestAttacker - payoffMixedAttacker;
    if ((convergeDefender < 0.05) && (convergeAttacker < 0.05) || (round == MAX_ROUNDS))
        break;  %����������ѭ��
    else
%         if(round > PURE_SET_SIZE)  %�ڶԷ���ǰ��ϲ����£�ɾ��һ�����������Լ�����������С�Ĵ�����
%             deleteStrategy(mixedStrategyDefender,mixedStrategyAttacker);
%         end
        
        %��˫�����Ŵ�������Ϊ�µ�һ�м��뵽���Ŵ����Լ���
        pureSetDefender = [pureSetDefender;bestResponseDefender];
        pureSetAttacker = [pureSetAttacker;bestResponseAttacker];
        
        fprintf('round = %d, convergeDefender = %d, convergeAttacker = %d\n',round,convergeDefender,convergeAttacker);%δ������������ּ�����
    end
end  %����������ѭ��
toc

%����������
fprintf('round = %d, convergeDefender = %d, convergeAttacker = %d \n',round,convergeDefender,convergeAttacker);
fprintf('Ua(A,d) = %d, Ua(a,d) = %d, Ud(a,D) = %d, Ud(a,d) = %d \n',payoffBestDefender,payoffMixedDefender,payoffBestAttacker,payoffMixedAttacker);

%������
% resultProcess(round,logDefenderBestPayoff,logDefenderMixPayoff,logAttackerBestPayoff,mixedStrategyDefender,mixedStrategyAttacker);
logMixedStrategyDefender = logMixedStrategyDefender + avelogMixedStrategyDefender;
logMixedStrategyAttacker = logMixedStrategyAttacker + avelogMixedStrategyAttacker;
