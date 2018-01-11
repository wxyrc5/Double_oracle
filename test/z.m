clear all;
close all;

%测试exp（-5*d*a）关于a和d是如何变化的
d = 0:0.001:1;
a = 0:0.001:1;
[D,A] = meshgrid(d,a);
Z = 1 - exp(-4 .* (1-D) .* A);

figure(1);
mesh(D,A,Z);%绘制三维图
colorbar;
xlabel('bug的复杂度'); % x 轴注解
ylabel('fuzzer的检测资源'); % y 轴注解
zlabel('bug被检测到的概率'); % z 轴注解

figure(2);
contour(D,A,Z,30);%绘制等高线
colorbar;
xlabel('bug的复杂度'); % x 轴注解
ylabel('fuzzer的检测资源'); % y 轴注解

% %测试 p = d*a 函数关系
% a = 0:0.001:1;
% d = 0.5;
% y = d .* a;
% plot(a,y)



% %测试exp（-5*d*a）关于a的变化
% a = 0:0.001:1;
% d = 0.1;
% y = 1 - exp(-5 * d .* a);
% plot(a,y)



