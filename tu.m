% a1 = 0:0.001:1;
% a2 = 1-a1;
% % p = 0:0.001:1;
% % 
% % x1 = log(1+(f1./a))./(5*f1);
% % x2 = log(1+(f2./(1-a)))./(5*f2);
% 
% f1 = 0.2;
% f2 = 0.8;
% 
% % y1 = exp(-5*x1.* a) .* (1 - exp(-5*x1*f1)) * 1;
% % y2 = exp(-5*x2.*(1 - a)) .* (1 - exp(-5*x2*f2)) * 3;
% % 
% % plot(a,y1,a,y2)
% 
% y1 = (a1 ./ (a1+f1)).^(a1/f1) * f1 ./ (a1+f1);
% y2 = (a2 ./ (a2+f2)).^(a2/f2) * f2 ./ (a2+f2);
% plot(a1,y1,a1,y2)
% 
% % [A,P] = meshgrid(a,p);
% % [X1,X2] = meshgrid(x1,x2);
% % y1 = exp(-5*X1.* A) .* (1 - exp(-5*X1*f1));
% % y2 = exp(-5*X2.*(1 - A)) .* (1 - exp(-5*X2*f2));
% % y = y1 .* P + y2 .* (1-P);
% % mesh(A,P,y)
% 
% % y = (a./(a+f)).^(a./f) .* (f./(a+f));
% % plot(a,y)
% 
clear all;
d = 0:0.001:1;
a = 0.3;
f = 0.6;
y = exp(-5 .* d * a) .* (1 - exp(-2 .* d * f));
% hold on;
plot(d,y)

