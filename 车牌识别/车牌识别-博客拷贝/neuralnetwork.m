% 车辆牌照字符识别方法：采用人工神经网络法
close all;
clear all;
I0=pretreatment(imread('0.jpg')); 
I1=pretreatment(imread('1.jpg')); 
I2=pretreatment(imread('2.jpg')); 
I3=pretreatment(imread('3.jpg')); 
I4=pretreatment(imread('4.jpg')); 
I5=pretreatment(imread('5.jpg')); 
I6=pretreatment(imread('6.jpg')); 
I7=pretreatment(imread('7.jpg')); 
I8=pretreatment(imread('8.jpg')); 
I9=pretreatment(imread('9.jpg')); 
I10=pretreatment(imread('A.jpg')); 
I11=pretreatment(imread('B.jpg')); 
I12=pretreatment(imread('C.jpg')); 
I13=pretreatment(imread('D.jpg')); 
I14=pretreatment(imread('E.jpg')); 
I15=pretreatment(imread('F.jpg')); 
I16=pretreatment(imread('G.jpg')); 
I17=pretreatment(imread('H.jpg')); 
I18=pretreatment(imread('J.jpg')); 
I19=pretreatment(imread('K.jpg')); 
I20=pretreatment(imread('L.jpg')); 
I21=pretreatment(imread('M.jpg')); 
I22=pretreatment(imread('N.jpg')); 
I23=pretreatment(imread('P.jpg'));
I24=pretreatment(imread('Q.jpg')); 
I25=pretreatment(imread('R.jpg')); 
I26=pretreatment(imread('S.jpg')); 
I27=pretreatment(imread('T.jpg')); 
I28=pretreatment(imread('U.jpg')); 
I29=pretreatment(imread('V.jpg')); 
I30=pretreatment(imread('W.jpg')); 
I31=pretreatment(imread('X.jpg')); 
I32=pretreatment(imread('Y.jpg')); 
I33=pretreatment(imread('Z.jpg')); 

P=[I0',I1',I2',I3',I4',I5',I6',I7',I8',I9',I10',I11',I12',I13',I14',I15',I16',I17',I18',I19',I20',I21',I22',I23',I24',I25',I26',I27',I28',I29',I30',I31',I32',I33'];
T=eye(34,34);
net=newff(minmax(P),[2000,300,34],{'logsig','logsig','logsig'},'trainrp');%minmax()求矩阵每一行向量的最大值和最小值
%函数newff建立一个可训练的前馈网络。这需要4个输入参数。
%第一个参数是一个Rx2的矩阵以定义R个输入向量的最小值和最大值； 
%第二个参数是一个设定每层神经元个数的数组； 
%第三个参数是包含每层用到的传递函数名称的细胞数组；
%最后一个参数是用到的训练函数的名称。
net.inputWeights{1,1}.initFcn='randnr';
net.inputWeights{2,1}.initFcn='randnr';
net.trainparam.epochs=8000;
net.trainparam.show=50;
net.trainparam.goal=0.0000000001;
net=init(net);%初始化权重和偏置的工作用命令init来实现。这个函数接收网络对象并初始化权重和偏置后返回网络对象。
[net,tr]=train(net,P,T);

i=imread('chepai.jpg');
dw=location(i);%车牌定位，见上上篇文章
[PIN0,PIN1,PIN2,PIN3,PIN4,PIN5,PIN6]=stringsplit(dw);%字符分割，见上篇文章
PIN0=pretreatment(PIN0);
PIN1=pretreatment(PIN1);
PIN2=pretreatment(PIN2);
PIN3=pretreatment(PIN3);
PIN4=pretreatment(PIN4);
PIN5=pretreatment(PIN5);
PIN6=pretreatment(PIN6);

P0=[PIN0',PIN1',PIN2',PIN3',PIN4',PIN5',PIN6'];
for i=2:7
    T0=sim(net,P0(:,i));%T0为P0(:,i)输入神经网络得到的输出，T0为34x1的列向量
    T1=compet(T0);% compet是神经网络的竞争传递函数，用于指出矩阵中每列的最大值。对应最大值的行的值为1，其他行的值都为0
    d=find(T1==1)-1;
    if(d==10)
        str='A';
    elseif(d==11)
        str='B';
    elseif(d==12)
        str='C';
    elseif(d==13)
        str='D';
    elseif(d==14)
        str='E';
    elseif(d==15)
        str='F';
    elseif(d==16)
        str='G';
    elseif(d==17)
        str='H';
    elseif(d==18)
        str='J';
    elseif(d==19)
        str='K';
    elseif(d==20)
        str='L';
    elseif(d==21)
        str='M';
    elseif(d==22)
        str='N';
    elseif(d==23)
        str='P';
    elseif(d==24)
        str='Q';
    elseif(d==25)
        str='R';
    elseif(d==26)
        str='S';
    elseif(d==27)
        str='T';
    elseif(d==28)
        str='U';
    elseif(d==29)
        str='V';
    elseif(d==30)
        str='W';
    elseif(d==31)
        str='X';
    elseif(d==32)
        str='Y';
    elseif(d==33)
        str='Z'; 
    else
        str=num2str(d);
    end
    switch i
        case 2
            str1=str;
        case 3
            str2=str;
        case 4
            str3=str;
        case 5
            str4=str;
        case 6
            str5=str;
        otherwise
            str6=str;
    end
end
s=strcat('沪',str1,str2,str3,str4,str5,str6);
figure();
imshow(dw),title(s);