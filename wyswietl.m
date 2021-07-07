function wyswietl(T)

s = '';

for i=1:size(T,2)
    s = [s, '\t & %2.4f '];
end

s = ['\t & A ', s,  ' \\\\ '];

for i=1:size(T,1)
    disp(sprintf(s,T(i,:)))
end