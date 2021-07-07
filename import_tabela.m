
sygnaly = {'Blocks', 'Bumps','Doppler', 'HeaviSine'};
P = 10;


load 'W' W;
path='pliki';
szum = 'L';

for id = 1:4
    
    s = makesig(sygnaly{id}, 4096);
    sstd = std(s);
    a = 7/sstd;
    s = a*s;
    szumID = 0;
    for sv = [0.1, 0.5, 1, 2, 5]
        
        for i = 1:P
            imName = sprintf('%s_%2.2f', sygnaly{id}, sv);
            x = read_signal(sprintf('%s/%s_%s_%d_visu.dat', path, imName,szum, i));
            W(szumID*4+id,1) = W(szumID*4+id,1) + mse(x',s);
        end
        szumID = szumID+1;
    end
end
wyswietl(W);