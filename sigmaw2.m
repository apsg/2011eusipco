function sw = sigmaw2(l, sigmav)

%sw = (4^2)*sigmav / (l^2);
sw = sqrt((sigmav^2 * 1.4^4)/(4*l^4));