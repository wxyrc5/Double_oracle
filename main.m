clc;
close all;
clear all;
%����ȫ�ֱ���

global blockNumber;
global ATTACKER_CAPACITY;
global REWARD;
global MAX_ROUNDS;
global pureSetDefender;
global pureSetAttacker;
global f;

CFG();  %��ȡCFG��ϵͼ
REWARD = 10;  %��һ��bug��������defender��õ�����
MAX_ROUNDS = 200; %���������Ϊ��Ԥ�������ڴ�ռ䣬Ҳ��ֹ��ѭ��
PURE_SET_SIZE = 30; %�����Կռ䱣�������Ը���
ATTACKER_CAPACITY  = round(blockNumber/8);  %defender����ܲ����bug��


%����attacker��ʼ����
pureSetAttacker(1,1:blockNumber) = f;

%����defender�ĳ�ʼ����
bestResponseDefender = zeros(1,blockNumber);
bestResponseDefender(1:ATTACKER_CAPACITY) = 0.5;%������������defender�ĳ�ʼ����
pureSetDefender(1,1:blockNumber) = bestResponseDefender;

logMixedStrategyDefender = zeros(MAX_ROUNDS);
logMixedStrategyAttacker = zeros(MAX_ROUNDS);
%��ѭ����ֱ������
tic;
for round = 1:MAX_ROUNDS    
    %ͨ�������Ŵ����Լ��Ͻ���minimax��⣬���˫�����Ż�ϲ���
    [payoffMixedDefender,payoffMixedAttacker,mixedStrategyDefender,mixedStrategyAttacker] = computeMixedStrategy();
    mixedStrategyDefender = roundn(mixedStrategyDefender,-4); 
    mixedStrategyAttacker = roundn(mixedStrategyAttacker,-4);
    logDefenderMixPayoff(round) = payoffMixedDefender;
    
    %����˫�����Ŵ�����
    [bestResponseDefender,payoffBestDefender] = computeDefenderBest(mixedStrategyAttacker);
    [bestResponseAttacker,payoffBestAttacker] = computeAttackerBest(mixedStrategyDefender);
    bestResponseDefender = roundn(bestResponseDefender,-4);
    bestResponseAttacker = roundn(bestResponseAttacker,-4);
    logDefenderBestPayoff(round) = payoffBestDefender;
    logAttackerBestPayoff(round) = payoffBestAttacker;

    %�ڶԷ���ȡmixed srategyʱ��˫�����Ե�best response��õ�����û��mixed srategy��õ������ʱ����Ϊ����
    convergeDefender = payoffBestDefender - payoffMixedDefender;
    convergeAttacker = payoffBestAttacker - payoffMixedAttacker;
    if ((convergeDefender < 0.0001) && (convergeAttacker < 0.0001) || (round == MAX_ROUNDS))
        break;  %����������ѭ��
    else
        %��˫�����Ŵ�������Ϊ�µ�һ�м��뵽���Ŵ����Լ���
        pureSetDefender = [pureSetDefender;bestResponseDefender];
        pureSetAttacker = [pureSetAttacker;bestResponseAttacker];
        
        if(round >= PURE_SET_SIZE)
            %               payoffDelete(mixedStrategyDefender,mixedStrategyAttacker);%�ڶԷ���ǰ��ϲ����£�ɾ��һ�����������Լ�����������С�Ĵ�����
            %               voteDelete(PURE_SET_SIZE,mixedStrategyDefender,mixedStrategyAttacker); %ͳ��Ʊ��,ɾ��Ʊ�����ٵĴ�����
            %               probaDelete(mixedStrategyDefender,mixedStrategyAttacker); %���ջ�ϲ����и�������ɾ����С�Ĵ�����
        end
        
        fprintf('round = %d, convergeDefender = %d, convergeAttacker = %d\n',round,convergeDefender,convergeAttacker);%δ������������ּ�����
    end
end  %����������ѭ��
toc

%����������
fprintf('round = %d, convergeDefender = %d, convergeAttacker = %d \n',round,convergeDefender,convergeAttacker);
fprintf('Ua(A,d) = %d, Ua(a,d) = %d, Ud(a,D) = %d, Ud(a,d) = %d \n',payoffBestDefender,payoffMixedDefender,payoffBestAttacker,payoffMixedAttacker);

%������
result = resultProcess(round,logDefenderBestPayoff,logDefenderMixPayoff,logAttackerBestPayoff,mixedStrategyDefender,mixedStrategyAttacker);