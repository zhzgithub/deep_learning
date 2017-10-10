% function [d]=main()
 close all
 clc    % 清空命令窗口的所有输入和输出，类似于清屏

%自动弹出提示框读入图像
 [filename,filepath]=uigetfile('.jpg','输入一个需要识别的车牌图像');% 直接自动读入%
 file=strcat(filepath,filename); %strcat函数：连接字符串；把filepath的字符串与filename的连接，即路径/文件名
 I=imread(file);
 figure('name','原图'),imshow(I);title('原图')
 %图像增强
 % h=ones(5,5)/25; %过滤器h
 % I=imfilter(I,h);%真彩色增强
 % figure('name','真彩色增强');imshow(I);title('真彩色增强');

I1=rgb2gray(I); % RGB图像转灰度图像
 % %figure('name','灰度处理前'),subplot(1,2,1),imshow(I1);title('灰度处理前的灰度图');
% % subplot(1,2,2),imhist(I1);title('灰度处理前的灰度图直方图');
%线性灰度变换
 I1=imadjust(I1,[0.3,0.7],[]);
 figure('name','灰度处理后'),subplot(1,2,1),imshow(I1);title('灰度处理后的灰度图');
 subplot(1,2,2),imhist(I1);title('灰度处理后的灰度图直方图');
%进行中值滤波
 I1=medfilt2(I1);
 figure,imshow(I1);title('中值滤波');

%边缘检测：sobel,roberts,canny,prewitt等
 I2=edge(I1,'roberts',0.25,'both'); %边缘检测算法，强度小于阈值0.15的边缘被省略掉,'both'两个方向检测（缺省默认）
figure('name','边缘检测'),imshow(I2);title('robert算子边缘检测') 
 se=[1;1;1];
 I3=imerode(I2,se);% 腐蚀Imerode(X,SE).其中X是待处理的图像，SE是结构元素对象
figure('name','腐蚀后图像'),imshow(I3);title('腐蚀后的图像');
 se=strel('rectangle',[20,20]);% 25X25的矩形 strel???
 I4=imclose(I3,se);% 用25*25的矩形对图像进行闭运算(先膨胀后腐蚀)有平滑边界作用
 figure('name','平滑处理'),imshow(I4);title('平滑图像的轮廓');
 I5=bwareaopen(I4,1000);% 从二进制图像中移除所有少于2000像素的连接对象，消失的是连续的白色像素数量少于2000的字符
 figure('name','移除小对象'),imshow(I5);title('从对象中移除小对象');
 [y,x,z]=size(I5);% y是行数，x是列数，z是维数
 myI=double(I5);% 转成双精度型
 tic   % 开始计时
 Blue_y=zeros(y,1);% zeros(M,N) 表示的是M行*N列的全0矩阵
 for i=1:y
     for j=1:x
          if(myI(i,j,1)==1) %% 判断蓝色像素
            Blue_y(i,1)= Blue_y(i,1)+1;% 蓝色像素点统计 
          end  
      end       
 end
 [temp MaxY]=max(Blue_y);% Y方向车牌区域确定 [temp MaxY]临时变量MaxY
 PY1=MaxY;  % 以下为找车牌Y方向最小值
 while ((Blue_y(PY1,1)>=5)&&(PY1>1))%% 为什么判断蓝色像素点>=5（才算蓝色）？？？？
         PY1=PY1-1;
 end    
 PY2=MaxY; % 以下为找车牌Y方向最大值 ???难道最大值不是MaxY????
 while ((Blue_y(PY2,1)>=5)&&(PY2<y))
         PY2=PY2+1;
 end
 % IY=I(PY1:PY2,:,:);
 %%%%%%%%%%%%%%%%% X方向 %%%%%%%%%
 Blue_x=zeros(1,x);% 进一步确定x方向的车牌区域
 for j=1:x
      for i=PY1:PY2  % 只需扫描的行
          if(myI(i,j,1)==1) %% 判断蓝色像素
             Blue_x(1,j)= Blue_x(1,j)+1; % 蓝色像素点统计             
          end 
      end   
 end

 PX1=1;% 以下为找车牌X方向最小值
 while ((Blue_x(1,PX1)<5)&&(PX1<x))%% 为什么判断蓝色像素点<3（不算蓝色？）？？？？
        PX1=PX1+1;
 end    
 PX2=x;% 以下为找车牌X方向最大值
 while ((Blue_x(1,PX2)<3)&&(PX2>PX1))
         PX2=PX2-1;
 end
 PY1=PY1-2;% 对车牌区域的校正 为什么要这么+－？？？
 PX1=PX1-2;
 PX2=PX2+3;
 PY2=PY2+10;


 dw=I(PY1:PY2-8,PX1:PX2,:);% 裁剪图像
 toc %t=toc; % 停止计时
 %figure(7),subplot(1,2,1),imshow(IY),title('行方向合理区域');
 figure('name','定位剪切后的彩色车牌图像'),%subplot(1,2,2),
 imshow(dw),title('定位剪切后的彩色车牌图像')
 imwrite(dw,'dw.jpg');
 % 直接自动读入%[filename,filepath]=uigetfile('dw.jpg','输入一个定位裁剪后的车牌图像');
 %jpg=strcat(filepath,filename); % strcat函数：连接字符串；把filepath的字符串与filename的连接，即路径/文件名
 a=imread('dw.jpg');
 b=rgb2gray(a);
 imwrite(b,'1.车牌灰度图像.jpg');
figure('name','车牌处理');subplot(3,2,1),imshow(b),title('1.车牌灰度图像')

%g_max=double(max(max(b)));% 以下作阈值化（灰度图转二值图）
 %g_min=double(min(min(b)));% max(a)求的每列的最大值，是一维数据；max(max(a)) 是求这一维数据的最大值。
 %T=round(g_max-(g_max-g_min)/2); % T 为二值化的阈值  round：取整为最近的整数
 %[m,n]=size(b);% m:b的行向量数 n:b的列向量数
 %d=(double(b)>=T);  % d:二值图像
 %imwrite(d,'2.车牌二值图像.jpg');

%线性灰度变换
 b=imadjust(b,[0.3,0.7],[]);
 subplot(3,2,2),imshow(b);title('2.线性灰度处理后的灰度图');

%进行二值化处理
 d=im2bw(b,0.4);%将灰度图像进行二值化处理
 imwrite(d,'2.车牌二值图像.jpg');
 subplot(3,2,3),imshow(d),title('3.车牌二值图像');%显示二值化图像

%进行中值滤波
 d=medfilt2(d);
 imwrite(d,'4.均值滤波后.jpg');
 subplot(3,2,4),imshow(d);title('4.中值滤波后');

% 均值滤波
 %h=fspecial('average',3);
 %d=im2bw(round(filter2(h,d)));% 滤波后，im2bw()：将图像转成二值图像 (可以不用round函数 也是一样的)
 %imwrite(d,'4.均值滤波后.jpg');
 %subplot(3,2,4),imshow(d),title('4.均值滤波后')

% 某些图像进行操作
 % 膨胀或腐蚀  ？？？感觉没什么效果咧？？？
 % se=strel('square',3);  % 使用一个3X3的正方形结果元素对象对创建的图像进行膨胀
 % 'line'/'diamond'/'ball'/'square'/'dish'... 线/菱形/球/正方形/圆
 se=eye(2); % eye(n) 返回n乘n单一矩阵； 单位矩阵
 [m,n]=size(d);
 if bwarea(d)/m/n>=0.365 % 函数bwarea 计算目标物的面积，单位是像素；bwarea/m/n即为单个像素？？
     d=imerode(d,se);% 腐蚀
 elseif bwarea(d)/m/n<=0.235
     d=imdilate(d,se);% 膨胀
 end
 imopen(d,se);

%se=eye(7);
 %imopen(d,se);
 imwrite(d,'5.膨胀或腐蚀处理后.jpg');
 subplot(3,2,5),imshow(d),title('5.膨胀或腐蚀处理后')
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%进行字符识别%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 寻找连续有文字的块，若长度大于某阈值，则认为该块有两个字符组成，需要分割
 d=qiege(d);% 调用qiege()子程序
 [m,n]=size(d);
 figure,subplot(2,1,1),imshow(d),title(n)
 k1=1;k2=1;
 j=1;
 s=sum(d);%sum(x)就是竖向相加，求每列的和，结果是行向量;sum(x,2)表示矩阵x的横向相加，求每行的和，结果是列向量。sum(X(:))表示矩阵求和

while j~=n   %%%%% 什么原理？？？
     while s(j)==0  %% 无文字？？？为什么？？？
         j=j+1;
     end
     k1=j;
     while s(j)~=0 && j<=n-1
         j=j+1;
     end
     k2=j-1;
     if k2-k1>=round(n/6.5)
         [val,num]=min(sum(d(:,[k1+5:k2-5])));
         d(:,k1+num+5)=0;  % 分割
     end
 end
 % 再切割
 %d=qiege(d);
 % 切割出 7 个字符
 y1=10;y2=0.25;flag=0;word1=[];
 while flag==0  % flag为自定义，以便标记循环用
     [m,n]=size(d);
   left=1;
     wide=0;
     while sum(d(:,wide+1))~=0 % 二值图像：黑色像素代表感兴趣的对象而白色像素代表背景。逻辑矩阵只包括0(显示为黑色)和1(显示为白色)
         wide=wide+1;% ？wide的意义？
     end
     if wide<y1   % 认为是左侧干扰 为什么是10？
         d(:,[1:wide])=0; % 将白色汉字前的白色弄成黑色
 %       figure,imshow(d);
         d=qiege(d); % 处理干扰后再次调用切割子程序
     else
         temp=qiege(imcrop(d,[1 1 wide m]));% imcrop函数截取图像[xmin ymin width height]
         [m,n]=size(temp);
         all=sum(sum(temp));
         two_thirds=sum(sum(temp([round(m/3):2*round(m/3)],:)));
         if two_thirds/all>y2 %？？什么意思？？
             flag=1;word1=temp;   %第一个字符
         end
         d(:,[1:wide])=0;d=qiege(d); %？为什么又处理一次？
     end
 end
 % 分割出第二个字符
 [word2,d]=getword(d);
 % 分割出第三个字符
 [word3,d]=getword(d);
 % 分割出第四个字符
 [word4,d]=getword(d);
 % 分割出第五个字符
 [word5,d]=getword(d);
 % 分割出第六个字符
 [word6,d]=getword(d);
 % 分割出第七个字符
 [word7,d]=getword(d);
 subplot(5,7,1),imshow(word1),title('1');
 subplot(5,7,2),imshow(word2),title('2');
 subplot(5,7,3),imshow(word3),title('3');
 subplot(5,7,4),imshow(word4),title('4');
 subplot(5,7,5),imshow(word5),title('5');
 subplot(5,7,6),imshow(word6),title('6');
 subplot(5,7,7),imshow(word7),title('7');
 [m,n]=size(word1);

% 商用系统程序中归一化大小为 40*20,此处演示
 word1=imresize(word1,[40 20]);%imresize对图像做缩放处理，常用调用格式为：B=imresize(A,ntimes,method)；其中method可选nearest,bilinear（双线性）,bicubic,box,lanczors2,lanczors3等
 word2=imresize(word2,[40 20]);
 word3=imresize(word3,[40 20]);
 word4=imresize(word4,[40 20]);
 word5=imresize(word5,[40 20]);
 word6=imresize(word6,[40 20]);
 word7=imresize(word7,[40 20]);

subplot(5,7,15),imshow(word1),title('11');
 subplot(5,7,16),imshow(word2),title('22');
 subplot(5,7,17),imshow(word3),title('33');
 subplot(5,7,18),imshow(word4),title('44');
 subplot(5,7,19),imshow(word5),title('55');
 subplot(5,7,20),imshow(word6),title('66');
 subplot(5,7,21),imshow(word7),title('77');
 imwrite(word1,'1.jpg'); % 创建七位车牌字符图像
 imwrite(word2,'2.jpg');
 imwrite(word3,'3.jpg');
 imwrite(word4,'4.jpg');
 imwrite(word5,'5.jpg');
 imwrite(word6,'6.jpg');
 imwrite(word7,'7.jpg');
 liccode=char(['0':'9' 'A':'Z' '京辽陕苏鲁浙']);  %建立自动识别字符代码表；'京津沪渝港澳吉辽鲁豫冀鄂湘晋青皖苏赣浙闽粤琼台陕甘云川贵黑藏蒙桂新宁'
 % 编号：0-9分别为 1-10;A-Z分别为 11-36;
 % 京  津  沪  渝  港  澳  吉  辽  鲁  豫  冀  鄂  湘  晋  青  皖  苏
 % 赣  浙  闽  粤  琼  台  陕  甘  云  川  贵  黑  藏  蒙  桂  新  宁
 % 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 
 % 60 61 62 63 64 65 66 67 68 69 70
 SubBw2=zeros(40,20); % 创建一个40行20列的0矩阵
 l=1;
 for I=1:7
       ii=int2str(I); % 将整型数据转换为字符串型数据
      t=imread([ii,'.jpg']);% 依次读入七位车牌字符
       SegBw2=imresize(t,[40 20],'nearest'); % 对读入的字符进行缩放
         if I==1                 % 第一位汉字识别
             kmin=37;
             kmax=42;
         elseif I==2             % 第二位 A~Z 字母识别
             kmin=11;
             kmax=36;
         else   I>=3         % 第三位以后是字母或数字识别 ;即I>=3
             kmin=1;
             kmax=36;        
         end
         
         for k2=kmin:kmax
             fname=strcat('namebook\',liccode(k2),'.jpg'); % strcat函数：连接字符串
             SamBw2 = imread(fname);
             for  i=1:40
                 for j=1:20
                     SubBw2(i,j)=SegBw2(i,j)-SamBw2(i,j);
                 end
             end
            % 以上相当于两幅图相减得到第三幅图 进行匹配
             Dmax=0; % 与模板不同的点个数
             for k1=1:40
                 for l1=1:20
                     if  ( SubBw2(k1,l1) > 5 | SubBw2(k1,l1) < -5 ) % "|"/"||" 或操作 （>2 15）20以上无区别
                         Dmax=Dmax+1;
                     end
                 end
             end
             Error(k2)=Dmax; % 记录下字符与模板k2不同的点个数
         end      
         Error1=Error(kmin:kmax);
         MinError=min(Error1); % 差别最小的
         findc=find(Error1==MinError); % 找出差别最小的模板
       %  Code(l)=liccode(findc(1)+kmin-1); % 此处用2*l-1且后面的2*l=' ',第隔一空格输出一个字符
        % Code(3)=' ';Code(4)=' ';
       %  l=l+1;
       %  if  l==3;% 后五位与前两位字符隔开
        %     l=l+2;
      %   end
         Code(l*2-1)=liccode(findc(1)+kmin-1);
        Code(l*2)=' ';
        l=l+1;
 end
 figure(10),subplot(5,7,1:7),imshow(dw),title('第一步：车牌定位'),
 xlabel({'第二步：车牌分割'}); %'',

subplot(6,7,15),imshow(word1);
 subplot(6,7,16),imshow(word2);
 subplot(6,7,17),imshow(word3);
 subplot(6,7,18),imshow(word4);
 subplot(6,7,19),imshow(word5);
 subplot(6,7,20),imshow(word6);
 subplot(6,7,21),imshow(word7);

subplot(6,7,22:42),imshow('dw.jpg');%
 xlabel(['第三步：识别结果为(已存入excel表格):', Code],'Color','b');
 xlswrite('C:\Users\MrLevo\Desktop\模式识别大作业_徐凯\车牌记录.xls',Code,'A1:M1'); %存入excel表格，表格需要存储在桌面时请更改路径，并且以管理员权限打开matlab
% % handles = guihandles(gcf);              %若没有excel则创立
 % %set(handles.text1,'string',num2str(Code)); %本来用于gui可视化的。
 