
sygnaly = {'Blocks', 'Bumps','Doppler', 'HeaviSine'};
for i=1:length(sygnaly)
   x = makesig(sygnaly{i}, 4096);
   sstd = std(x);
    a = 7/sstd;
    x = a*x;
   f = figure;
   set(f, 'Color', 'white')
   p = plot(1:4096, x,'k');
   set(p, 'LineWidth', 1);
   set(gca, 'FontSize', 18)
   set(gca, 'XLim', [0, 4096])
end