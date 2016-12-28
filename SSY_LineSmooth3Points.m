function LineCenter1 = SSY_LineSmooth3Points(LineCenter1,m)
% ================线条的3点平均滑动平滑处理====================
% m 平滑次数，默认取3
% LineCenter1 = SSY_LineSmooth3Times(LineCenter1,m)
% LineCenter1 = SSY_LineSmooth3Times(LineCenter1)
if nargin == 1
   m = 3;
end
n = length(LineCenter1);
for k = 1:m
    LineCenter2(1) = (2*LineCenter1(1)+LineCenter1(2))/3;
    for j = 2:n-1
        LineCenter2(j) = (LineCenter1(j-1)+LineCenter1(j)+LineCenter1(j+1))/3;
    end    
    LineCenter2(n) = (LineCenter1(n-1)+2*LineCenter1(n))/3;
    LineCenter1 = LineCenter2;
end