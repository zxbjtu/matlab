clc,clear
cab = importdata('calibrationSession4.mat');
bx = cab.BoardSet.BoardPoints(:,1); 
by = cab.BoardSet.BoardPoints(:,2);
wx = cab.BoardSet.WorldPoints(:,1);  
wy = cab.BoardSet.WorldPoints(:,2);
X = wx;
Y = wy;
u = bx;
v = by;
u2 = u.^2;
v2 = v.^2;
uv = u.*v;
u3 = u.^3;
v3 = v.^3;
u2v = u.^2.*v;
uv2 = u.*v.^2;
u4 = u.^4;
v4 = v.^4;
u3v = u.^3.*v;
u2v2 = u.^2.*v.^2;
uv3 = u.*v.^3;
v4 = v.^4;
M = [ones(size(u)),u,v,uv,u2,v2,u3,u2v,uv2,v3];%,u4,u3v,u2v2,uv3,v4]
k(:,1) = regress(X,M);
k(:,2) = regress(Y,M);
save('标定结果.txt','k','-ascii');