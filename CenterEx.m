close all
clear
clc
%%  进行图像读入，灰度化，二值化
%% 
I1 = imread('img3.bmp');
I2 = imread('img4.bmp');
G1 = rgb2gray(I1);
G2 = rgb2gray(I2);
G = G1-G2;
sigma = 1.6;
gausFilter = fspecial('gaussian',[5,5],sigma);
G = imfilter(G,gausFilter,'replicate');
imshow(G)

% figure;
% imshow(G);
[D,W]=size(G);
e=zeros(size(G));
thresh = graythresh(G);
BW=im2bw(G,thresh);
%figure;
%imshow(BW);
%%  去除孤立噪点
%% 
BW2=BW;
for i=2:D-1
    for j=2:W-1
        
        if BW(i,j)==1&&BW(i-1,j-1)+BW(i-1,j)+BW(i-1,j+1)+BW(i,j-1)+e(i,j+1)+BW(i+1,j-1)+BW(i+1,j)+BW(i+1,j+1)<=2
            BW2(i,j)=0;
        end
    end
end
% figure;
% imshow(BW2);
%% 膨胀以及腐蚀处理进行光条优化
%%  
se=strel('disk',3);
p=imdilate(BW2,se);
% figure;
% imshow(p);
p2=imerode(p,se);
 figure;
 imshow(p2);
%% 图像光条分割
%%
[B,L,N,A]=bwboundaries(p2,'noholes');
%% 将被分割光条独立标定
%%

 for v=1:N
     p=G;
    for i=1:D
        for j=1:W
            if L(i,j)~=v
                p(i,j)=0;
            end
        end
    end
 f=zeros(size(G));
 p=double(p);
 %figure,imshow(uint8(p))
 %% 平滑化处理
 %%
 for i=1:D                       
    for j=2:W-1
        c=p(i,j-1)+p(i,j)+p(i,j+1);
        f(i,j)=round(c/3);
    end
 end
%% 对第一类光条灰度分布类别进行处理
%%
for i=1:D
    [r,u]=find(f(i,:)==max(f(i,:)));
    if length(r)==1
        [Y,U]=max(f(i,:));
        if max(f(i,:))>=30
            x=[U-3:U+3];
            y=[f(i,U-3),f(i,U-2),f(i,U-1),f(i,U),f(i,U+1),f(i,U+2),f(i,U+3)];
            l=polyfit(x,y,2);
            m{v}(i)=-l(2)/2/l(1);
            G(i,round(m{v}(i)))=0;
        end
    end
%% 对第二类光条灰度分布类别进行处理
%%
    if rem(length(r),2)==0
             [Y,U]=max(f(i,:));
             le=length(r);
        if max(f(i,:))>=30                                 
            x=[U-2:U+1+le];
             y=[f(i,U-2:U+1+le)];
            l=polyfit(x,y,2);
            m{v}(i)=-l(2)/2/l(1);
            G(i,round(m{v}(i)))=0;
        end
    end
%% 对第三类光条灰度分布类别进行处理
%%
     if rem(length(r),2)==1&&length(r)~=1
         m{v}(i)=sum(u)/length(r);
        G(i,round(m{v}(i)))=0;
     end
    end
 end
  for i = 1:length(m)
      n{i} = find(m{i});
      m{i} = m{i}(m{i}~=0);
  end
  figure,imshow(double(G)/255);
  for i = 1:length(m)
      hold on
      plot(m{i},n{i},'r.')
  end
      
%% 结果汇总，标记展示

 dispG=uint8(G);
 figure;
 imshow(dispG);

        
        















