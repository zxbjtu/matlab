clear all
I1 = imread('img5.bmp');
I2 = imread('img6.bmp');
G1 = rgb2gray(I1);
G2 = rgb2gray(I2);
G = G1-G2;
sigma = 1.6;
gausFilter = fspecial('gaussian',[5,5],sigma);
G = imfilter(G,gausFilter,'replicate');
[D,W] = size(G);
imshow(G)
thresh = graythresh(G);
BW = im2bw(G,0.6);
%imshow(bw);
 se=strel('disk',3);
    p = imdilate(BW,se);
    p = imerode(p,se);
    skel = bwmorph(p,'skel',inf);
    spur = bwmorph(skel,'spur',30);
    imshow(spur)
    for j = 1:D    %去除剪枝后骨架的分叉点
        m = find(spur(j,:));
        if length(m)>1
            for k = 1:length(m)
                spur(j,m(k)) = 0;
            end
            spur(j,floor(sum(m)/length(m))) = 1;
        end
    end
%     figure
%     hold on 
%     imshow(spur);
    [row,col] = find(spur);
    gray = double(G)/255;
    spur_pix = [row,col];
    for j = 1:length(row)   %灰度重心法
        pixel = spur_pix(j,:);
        for k = 1:9
            num1(k) = gray(pixel(1),pixel(2)-5+k)*(pixel(2)-5+k);
            num2(k) = gray(pixel(1),pixel(2)-5+k);
            num3(k) = gray(pixel(1),pixel(2)-5+k)*pixel(1);
        end
        center_u = sum(num1)/sum(num2);
        center_v = sum(num3)/sum(num2);
        center(j,:) = [center_u,center_v];
    end
    Center = center;    %光条中心像素坐标
    center = [];
    imshow(double(G)/255);
    hold on
    plot(Center(:,1),Center(:,2),'r.');
    save('1.txt','Center','-ascii');
