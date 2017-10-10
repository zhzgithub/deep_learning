clc,clear  
npersons=40;%选取40个人的脸  
global imgrow;  
global imgcol;  
global edit2  
imgrow=112;  
imgcol=92;  
  
set(edit2,'string','读取训练数据......')%显示在句柄为edit2的文本框里  
drawnow     %更新窗口的内容，不然程序结束时才会显示，这样只能看到最后一句  
f_matrix=ReadFace(npersons,0);%读取训练数据  
nfaces=size(f_matrix,1);%样本人脸的数量  
  
set(edit2,'string','训练数据PCA特征提取......')  
drawnow  
mA=mean(f_matrix);  
k=20;%降维至20维  
[pcaface,V]=fastPCA(f_matrix,k,mA);%主成分分析法特征提取  
  
set(edit2,'string','训练数据规范化......')  
drawnow  
lowvec=min(pcaface);  
upvec=max(pcaface);  
scaledface = scaling( pcaface,lowvec,upvec);  
  
set(edit2,'string','SVM样本训练......')  
drawnow  
gamma=0.0078;  
c=128;  
multiSVMstruct=multiSVMtrain( scaledface,npersons,gamma,c);  
save('recognize.mat','multiSVMstruct','npersons','k','mA','V','lowvec','upvec');  
  
set(edit2,'string','读取测试数据......')  
drawnow  
[testface,realclass]=ReadFace(npersons,1);  
  
set(edit2,'string','测试数据特征降维......')  
drawnow  
m=size(testface,1);  
for i=1:m  
    testface(i,:)=testface(i,:)-mA;  
end  
pcatestface=testface*V;  
  
set(edit2,'string','测试数据规范化......')  
drawnow  
scaledtestface = scaling( pcatestface,lowvec,upvec);  
  
set(edit2,'string','SVM样本分类......')  
drawnow  
class= multiSVM(scaledtestface,multiSVMstruct,npersons);  
set(edit2,'string','测试完成！')  
accuracy=sum(class==realclass)/length(class);  
msgbox(['识别准确率：',num2str(accuracy*100),'%。'])