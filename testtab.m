s = RandStream('mcg16807','Seed',0);
RandStream.setDefaultStream(s);


sygnaly = {'Blocks', 'Bumps','Doppler', 'HeaviSine'};
P = 10;
szum = 'G';

W = zeros(20,4);

for id = 1:4
    
    s = makesig(sygnaly{id}, 4096);
    sstd = std(s);
    a = 7/sstd;
    s = a*s;
    szumID = 0;
    for sv = [0.1, 0.5, 1, 2, 5]
        
        for i = 1:P
            
           % y = s + L(s, 0, sv);
            y = s + sv*randn(size(s));
            path='pliki';
            imName = sprintf('%s_%2.2f', sygnaly{id}, sv);
            save_file(sprintf('%s/%s_%s_%d.dat', path, imName, szum, i), y);
            
            [ye11, eo11] = kalsmooth(y, 1, sigmaw(10, sv), sv);
            [ye21, eo21] = kalsmooth(y, 2, sigmaw2(10, sv), sv);
            [ye31, eo31] = kalsmooth(y, 3, sigmaw3(10, sv), sv);
            
            [ye12, eo12] = kalsmooth(y, 1, sigmaw(30, sv), sv);
            [ye22, eo22] = kalsmooth(y, 2, sigmaw2(30, sv), sv);
            [ye32, eo32] = kalsmooth(y, 3, sigmaw3(30, sv), sv);
            
            [ye13, eo13] = kalsmooth(y, 1, sigmaw(90, sv), sv);
            [ye23, eo23] = kalsmooth(y, 2, sigmaw2(90, sv), sv);
            [ye33, eo33] = kalsmooth(y, 3, sigmaw3(90, sv), sv);
%             
%             [ym1, em1] = smmed(y, 11);
%             [ym2, em2] = smmed(y, 31);
%             [ym3, em3] = smmed(y, 91);
            
            Y1 = [ye11; ye12; ye13];
            E1 = [eo11; eo12; eo13];
            
            Y2 = [ye11; ye12; ye13;ye21; ye22; ye23];
            E2 = [eo11; eo12; eo13;eo21; eo22; eo23];
            
            Y3 = [ye11; ye12; ye13;ye21; ye22; ye23;ye31; ye32; ye33];
            E3 = [eo11; eo12; eo13;eo21; eo22; eo23;eo31; eo32; eo33];
%             
%             Y4 = [ye11; ye12; ye13; ym1; ym2; ym3];
%             E4 = [eo11; eo12; eo13; em1; em2; em3];
%             
%             Y5 = [ye11; ye12; ye13;ye21; ye22; ye23; ym1; ym2; ym3];
%             E5 = [eo11; eo12; eo13;eo21; eo22; eo23; em1; em2; em3];
%             
%             Y6 = [ye11; ye12; ye13;ye21; ye22; ye23;ye31; ye32; ye33; ym1; ym2; ym3];
%             E6 = [eo11; eo12; eo13;eo21; eo22; eo23;eo31; eo32; eo33; em1; em2; em3];
%             
            yc1 = kalmed(Y1, E1, 1);
            yc2 = kalmed(Y2, E2, 1);
            yc3 = kalmed(Y3, E3, 1);
%             yc4 = kalmed(Y4, E4, 2);
%             yc5 = kalmed(Y5, E5, 2);
%             yc6 = kalmed(Y6, E6, 2);
            
            W(szumID*4+id, 2) =W(szumID*4+id, 2) + mse(s,yc1);
            W(szumID*4+id, 3) =W(szumID*4+id, 3) + mse(s,yc2);
            W(szumID*4+id, 4) =W(szumID*4+id, 4) + mse(s,yc3);
            
%             W(szumID*4+id, 5) =W(szumID*4+id, 5) + mse(s,yc4);
%             W(szumID*4+id, 6) =W(szumID*4+id, 6) + mse(s,yc5);
%             W(szumID*4+id, 7) =W(szumID*4+id, 7) + mse(s,yc6);
            
            disp(szumID*4+id);
        end
        szumID=szumID+1;
    end
end

save 'G' W
        
        figure;
        plot(s, 'k'), hold on
        plot(yc1, 'g--');
        plot(yc2, 'b--');
        plot(yc3, 'r--');
