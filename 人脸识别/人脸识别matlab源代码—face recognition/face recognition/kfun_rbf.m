function [ K ] = kfun_rbf(u,v,gamma)  
%SVM分类器的RBF核函数  
%   Detailed explanation goes here  
m1=size(u,1);  
m2=size(v,1);  
K=zeros(m1,m2);  
for i=1:m1  
    for j=1:m2  
        K(i,j)=exp(-gamma*norm(u(i,:)-v(j,:))^2);  
    end  
end  
end  