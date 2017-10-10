function inp=pretreatment(I)
%此函数是将字符图片均转换成一维向量
if isrgb(I)
    I1=rgb2gray(I);
else
    I1=I;
end
I1=imresize(I1,[20,10]);%归一化
I1=im2bw(I1,0.9);
[m,n]=size(I1);
inp=zeros(1,m*n);
for j=1:n
    for i=1:m
        inp(1,m*(j-1)+i)=I1(i,j);
    end
end