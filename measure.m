clear all
I1 = imread('img14.bmp');
I2 = imread('img15.bmp');
G1 = rgb2gray(I1);
G2 = rgb2gray(I2);
G = G1-G2;
sigma = 1.6;
gausFilter = fspecial('gaussian',[5,5],sigma);
G = imfilter(G,gausFilter,'replicate');
G = double(G);
[D,W] = size(G);
center = [];
for i = 1:D
    row = G(i,G(i,:)>160);
    j = find(G(i,:)>160);   
    if length(row) == 0
        continue;
    end
    for k = 1:length(row)
        num1(k) = j(k)*row(k);
        num2(k) = row(k);
    end
    center_u = sum(num1)/sum(num2);
    num1 = [];
    num2 = [];
    center_v = i;
    center = [center;[center_u,center_v]];
end
SSY_LineSmooth3Points(center(:,1));
imshow(double(G)/255);
hold on
plot(center(:,1),center(:,2),'r.');
save('1.txt','center','-ascii');