global h_axes1  
global h_axes2  
global edit2  
load('recognize.mat');  
set(edit2,'string','读取测试数据......')  
drawnow  
disp('读取测试数据...')  
disp('.................................................')  
img=getimage(h_axes1);%获得之前选中的照片的信息  
if isempty(img)  
    msgbox('请先选择一张图片！')  
    %break  
end  
testface=img(:)';  
set(edit2,'string','测试数据降维......')  
drawnow  
disp('测试数据特征降维...')  
disp('.................................................')  
Z=double(testface)-mA;  
pcatestface=Z*V;  
set(edit2,'string','测试特征数据规范化......')  
drawnow  
disp('测试特征数据规范化...')  
disp('.................................................')  
scaledtestface=-1+(pcatestface-lowvec)./(upvec-lowvec)*2;  
set(edit2,'string','SVM样本识别......')  
drawnow  
disp('SVM样本识别...')  
disp('.................................................')  
voting=zeros(1,npersons);  
for i=1:npersons-1  
    for j=i+1:npersons  
        class=svmclassify(multiSVMstruct{i}{j},scaledtestface);  
        voting(i)=voting(i)+(class==1);  
        voting(j)=voting(j)+(class==0);  
    end  
end  
[~,class]=max(voting);  
set(edit2,'string','识别完成！')  
drawnow  
axes(h_axes2);  
imshow(imread(['.\ORL_face\s',num2str(class),'\1.pgm']));  
msgbox(['样本识别为第',num2str(class),'个人'])