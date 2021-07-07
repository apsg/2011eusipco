N = 5000;
s = zeros(N, 1);
sv = 0.5;

v = sv*randn(size(s));
y = s+v;
N = 5000;
dzx = [];
d=[];
l1=[];
l2 = [];
for sw=0.00001:0.00005:0.001
    
    
    % l1 = [l1, 2*sv/sw];
    
    dz = sw/sv;
   % l1 = [l1,  1.3/(sqrt(sqrt(((dz^2)))))];
    l1 = [l1, 2.3/((dz^(1/6)))];
    dzx = [dzx,sw];
    l2 = [l2, 1/(sqrt(dz^4 + 0.25*(dz^2)) - dz^2)];
    
    vy = var(y(100:end-100));
    
    p=3;
    se = kalsmooth(y, p, sw, sv);
    vse = var(se(100:end-100));
    d =[d, vy/vse];
end
disp('---- real ----');
disp(mean(d))

figure;
plot(dzx, d, 'b')
hold on
plot(dzx, l1, 'r')
%plot(dzx, l2, 'g')

xlabel('\sigma_w')
ylabel('L_{\infty}')
legend('eksperymentalnie', 'analityczne uproszczone', 'analityczne dokladne')
% figure;
% plot(s), hold on
% plot(se, 'r');