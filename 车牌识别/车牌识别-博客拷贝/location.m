function dw=location(i)
% 此车牌定位法采用的是：边缘检测+形态学运算的方法。 
% 缺点：此方法对于车辆牌照周围灰度变化剧烈的情况容易定位错误。
%车牌定位方法
i1=rgb2gray(i);%灰度化
i2=edge(i1,'roberts');%边缘检测
imshow(i2);
se=[1;1;1];%列腐蚀算子，腐蚀算子的形状很重要
i3=imerode(i2,se);%此腐蚀可将非车牌区域的噪声信息腐蚀掉
figure,imshow(i3);
se1=strel('rectangle',[25,25]);%方形闭环算子
i4=imclose(i3,se1);%闭环运算 需要选择大的算子
figure,imshow(i4);
i5=bwareaopen(i4,1500);%将连通域面积小于1500像素的区域都删除，此方法是为了把除车牌以外的区域都删除
figure,imshow(i5);
[y,x,z]=size(i5);
i6=double(i5);
Y1=zeros(y,1);
for ii=1:y%统计每一行的像素值为1的个数
    for jj=1:x
        if(i6(ii,jj,1)==1)
            Y1(ii,1)=Y1(ii,1)+1;
        end
    end
end
[temp,MaxY]=max(Y1);%temp为Y1的最大值，MaxY为其所在的行数
figure,plot(1:y,Y1);
PY1=MaxY;
while((Y1(PY1,1)>=50)&&(PY1>1))%求车牌上边界
    PY1=PY1-1;
end
PY2=MaxY;
while((Y1(PY2,1)>=50)&&(PY2<y))%求车牌下边界
    PY2=PY2+1;
end

X1=zeros(1,x);
for jj=1:x%统计每一列的像素值为1的个数，只统计车牌上下边界之间的像素数
    for ii=PY1:PY2
        if(i6(ii,jj,1)==1)
            X1(1,jj)=X1(1,jj)+1;
        end
    end
end
figure,plot(1:x,X1);

PX1=1;
while((X1(1,PX1)<15)&&(PX1<x))%求车牌左边界
    PX1=PX1+1;
end
PX2=x;
while((X1(1,PX2)<15)&&(PX2>PX1))%求车牌右边界
    PX2=PX2-1;
end
PX1=PX1-1;
PX2=PX2+1;
dw=i(PY1:PY2,PX1:PX2,:);%求得车牌区域
figure,imshow(dw);