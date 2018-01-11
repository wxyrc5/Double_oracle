clear all;
close all;

%����exp��-5*d*a������a��d����α仯��
d = 0:0.001:1;
a = 0:0.001:1;
[D,A] = meshgrid(d,a);
Z = 1 - exp(-4 .* (1-D) .* A);

figure(1);
mesh(D,A,Z);%������άͼ
colorbar;
xlabel('bug�ĸ��Ӷ�'); % x ��ע��
ylabel('fuzzer�ļ����Դ'); % y ��ע��
zlabel('bug����⵽�ĸ���'); % z ��ע��

figure(2);
contour(D,A,Z,30);%���Ƶȸ���
colorbar;
xlabel('bug�ĸ��Ӷ�'); % x ��ע��
ylabel('fuzzer�ļ����Դ'); % y ��ע��

% %���� p = d*a ������ϵ
% a = 0:0.001:1;
% d = 0.5;
% y = d .* a;
% plot(a,y)



% %����exp��-5*d*a������a�ı仯
% a = 0:0.001:1;
% d = 0.1;
% y = 1 - exp(-5 * d .* a);
% plot(a,y)



