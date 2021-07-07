% test szerokości okien
close all
sv = 0.25;

s = ones(1, 4000);
n = sv*randn(size(s));
y = s + n;

ss = var(y(500:end-500));
disp(sprintf(' ------ std(v) = %2.2f', ss))
hold off
plot(s, 'k'), hold on

for l=10:10:60
    ye1 = kalsmooth(y, 1, sigmaw(l, sv), sv);
    x1 = var(ye1(500:end-500));
    ye2 = kalsmooth(y, 2, sigmaw2(l, sv), sv);
    x2 = var(ye2(500:end-500));
    ye3 = kalsmooth(y, 3, sigmaw3(l, sv), sv);
    x3 = var(ye3(500:end-500));
    disp(sprintf('%2.4f \t %2.4f \t %2.4f', (ss/x1), (ss/x2), (ss/x3)))
end

plot(ye1, 'g');
plot(ye2, 'b');
plot(ye3, 'r');