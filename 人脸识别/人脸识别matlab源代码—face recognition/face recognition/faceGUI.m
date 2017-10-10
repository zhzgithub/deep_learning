global h_axes1;  
global h_axes2;  
global edit2;  
h_f=figure('name','人脸识别系统','position',[300,200,600,400]);  
clf reset;  
set(h_f, 'defaultuicontrolfontsize' ,12);    
set(h_f, 'defaultuicontrolfontname' , '宋体' );    
  
h_axes1=axes('parent',h_f,'position',[0.2 0.28 0.25 0.56],'Unit','normalized','visible','off');  
h_axes2=axes('parent',h_f,'position',[0.55 0.28 0.25 0.56],'Unit','normalized','visible','off');  
  
figcolor=get(h_f,'color');  
edit2=uicontrol(h_f,'style','text','position',[150,330,300,40],'backgroundcolor',figcolor);  
button_open=uicontrol(h_f,'style','push','string','选择照片','position',[250 50 100 50],'callback','GUIopen');  
button_recg=uicontrol(h_f,'style','push','string','测试准确率','position',[100 50 100 50],'callback','face');  
button_match=uicontrol(h_f,'style','push','string','图像匹配','position',[400 50 100 50],'callback','GUIrecg'); 