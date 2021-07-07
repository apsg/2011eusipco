function [ye, eo] = kalsmooth(y, p, sw, sv)
% 
% s = makesig('Blocks', 4000);
% sv = 0.1;
% sw = 0.01;
% y = s + sv*randn(size(s));
% p=3;

%-------

N = length(y);
% xx = y;
% if(p>1)
%     for i=2:p
%         xx = [xx; zeros(1, i-1), y(1:N-i+1)];
%     end
% end

ksi = sw/sv;
c = zeros(p,1);
c(1) = 1;

F = zeros(p,p);
for i=1:p
    F(1,i) = -(((-1)^i) * nad(p,i));
end
if(p>1)
    for i=2:p
        F(i,i-1) = 1;
    end
end

x = zeros(p,N);
xp = zeros(size(x));
P = zeros(p,p,N);
Pp = zeros(size(P));
ep = zeros(size(y));
z = zeros(size(y));
k = zeros(p,N);
G = zeros(p,1);
G(1) = 1;

%P(:,:,1) = diag(5*ones(p,1));

for t=2:N
    xp(:,t) = F*x(:,t-1);
    Pp(:,:,t) = F*P(:,:,t-1)*F' + G*G'*(ksi^2);
    ep(t) = y(t) - c'*xp(:,t);
    z(t) = 1 + c'*Pp(:,:,t)*c;
    k(:,t) = Pp(:,:,t)*c / z(t);
    x(:,t) = xp(:,t) + k(:,t)*ep(t);
    P(:,:,t) = Pp(:,:,t) - k(:,t)*k(:,t)'*z(t);
    
end

ye = x(1,:);

% BF smooth

B = zeros(size(P));
r = zeros(p,N);
R = zeros(size(B));
xN = zeros(size(x));
I = diag(ones(p,1));
PN = zeros(size(P));
q = zeros(size(y));
e = zeros(size(y));
eo = zeros(size(y));

for t=N:-1:2
   B(:,:,t) = F*(I - k(:,t)*c');
   r(:,t-1) = B(:,:,t)'*r(:,t) + c*ep(t)/z(t);
   R(:,:,t-1) = B(:,:,t)'*R(:,:,t)*B(:,:,t) + c*c'/z(t);
   xN(:,t) = xp(:,t) + Pp(:,:,t)*r(:,t-1);
   PN(:,:,t) = Pp(:,:,t) - Pp(:,:,t)*R(:,:,t-1)*P(:,:,t);
   e(t) = y(t) - c'*xN(:,t);
   q(t) = c'*PN(:,:,t)*c;
   eo(t) = e(t) /(1-q(t));
end

yeBF = xN(1,:);

%ye = yeBF;

% ---- RTS ---- sprawdzenie
% 
% xN = zeros(size(x));
% A = zeros(size(P));
% PN = zeros(size(P));
% xN(:,N) = x(:,N);
% PN(:,:,N) = P(:,:,N);
% 
% for t=N-1:-1:1
%    A(:,:,t) = P(:,:,t)*F'/(Pp(:,:,t+1)); 
%    xN(:,t) = x(:,t) + A(:,:,t)*(xN(:,t+1) - xp(:,t+1));
%    PN(:,:,t) = P(:,:,t) + A(:,:,t)*(PN(:,:,t+1) - Pp(:,:,t+1))*A(:,:,t)';
%    
% end
% yeRTS = xN(1,:);

%-------
% figure;
% plot(s, 'k'); hold on
% plot(y, 'r');
% plot(ye, 'b');
% plot(yeBF,'g');
% plot(yeRTS, 'm');
% 
% disp(sum(yeBF(100:end-100) - yeRTS(100:end-100)))
