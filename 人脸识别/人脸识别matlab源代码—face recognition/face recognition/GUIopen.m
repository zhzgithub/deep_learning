global h_axes1  
[filename,pathname]=uigetfile({'*.pgm';'*.jpg';'*.tif';'*.*'},'请选择一张用于识别的照片');  
if filename==0  
    msgbox('请选择一张照片文件')  
else  
    filepath=[pathname,filename];  
    axes(h_axes1);  
    imshow(imread(filepath));  
end  