# deeplearning
=============================================================================================================
# 1.在卷积神经网络中,经过卷积层或池化层后还剩多少像素：      
这里不考虑边缘填充的问题，只讲方法帮助理解以便笔试中快速计算。
【图片尺寸-卷积核尺寸(或者池化尺寸)】/步长+1=卷积或者池化
后的尺寸....最后加1是因为比如1,2有两个数，2-1+1=2。。。      
例如:图片尺寸100*100,卷积核尺寸5*5,【按照卷积核窗口的最后一个像素为标准移动,一直
移动到图片的最后一个像素】      
   【步长为1时】，经过卷积层后的像素大小计算过程为，由于卷积核为5*5,那么图片的
		前5*5个像素是第1个点，然后向右移动一步则第2个到第6个像素的5*5个像素变成第2个点，
		以此类推,从第5个像素移动到第100个像素共有100-5+1=96个,即卷积层后图片变为了96*96,这是步长为1的情况。        
   【步长为2时】：是第5,7,9,11,...,99。总共移动了(99-5)/2+1=48次，即图片由100*100变为了48*48了。
		这里没考虑第100个像素，因为步长为2，最后只剩一列了，组合不了5*5，只有4*5.填充什么的我不考虑。     
   【步长为3时】，按照上面的方法就行了。5,8,11,...,98。。。核窗口的最后一个像素总共移
		动了(98-5)/3+1=32次，卷积或者池化后的尺寸为32*32     
	对于书中讲的【池化层】，比如2*2的池化窗口并没有重叠的，那是因为池化的步长为2.
	如果池化窗口为3*3,步长为3，那也是没有重叠的.
==============================================================================================================
# 2.关于权重初始化是否可为0的问题      
【1.神经网络】：隐藏层的每个神经元分别学习到不同的特征，如果权重全部初始化为0，那么
	各层的每个神经元都学习相同的特征，就相当于每层神经元都只有一个神经元，因此神经网络不能权重初始化为0.    
【2.单层感知机】只有一个神经元，他的权重可初始化为0      
【3.线性回归模型】相当于单层感知机，其权重也可以初始化为0

==============================================================================================================
# 3.关于梯度下降法        
【1】比如[x1 x2] = meshgrid(-5:5, -5:5);y=x1.^2+x2.^2  surf(x1,x2,y); 可把该代码在matlab中运行看图形是什么样。       
	这个表达式的图形就是一个把四个角吊起来的网。梯度为(2*x1,2*x2),该图的负梯度方向是平行于x1 x2平面
	并指向里面的方向，并不是该点的切线方向，也不是某个指向地面的容易让人混淆的切线.      
	
【2】但是对于只有一个变量的比如 y=x.^2,其梯度为2*x，即其负梯度方向为-2*x，即是其导数。
	对于线性函数比如y=x,其梯度就是其斜率。      

【3】#只需要记住，负梯度方向是使函数值减少最快的方向，但是是供变量迭代相加减的，并不是供函数值相加减的。
	只需要用变量加上负梯度方向就是变量的下一个迭代值:w1=w0-α*dy/dw0,α是步长,dy/dw0是在w0处的梯度方向。     
	
【4】在多变量时候还容易想通，对于一元二次函数，对变量迭代时，由于根据图像来推导，总是觉得梯度方向是跟
	变量迭代的加减扯不上关系的，不知道为什么要用变量加上步长乘以负梯度。似懂非懂，那就不管了吧，记住多变量的就好
	
==============================================================================================================

# 4.logistic回归--------(摘自吴恩达深度学习视频)
【0】logistic回归是二类分类问题，对应标签y为0和1。
	激活函数是sigmoid函数, a=σ(z)
	假设只有每个样本只有两个特征x1,x2：
		z=w(T)x + b = w1*x1+w2*x2+b,  
【编程时有种约定】da表示dL(a,y)/da ;dz表示dL(a,y)/dz     也就是说，把dL/省略了

【1】单个样本损失函数：L(a,y)=-[ylog(a)+(1-y)log(1-a)] ,#【这个公式很重要，记清楚】
	其中a是预测值、激活值,a属于0到1之间的值,也就是y帽,y是标签。      
	
【1.0】L(a,y)对a求导得：	
		dL(a,y)/da = -y/a + (1-y)/(1-a);#【这个公式很重要，记清楚】  

		dL(a,y)/dz = a-y;     #【这个公式很重要，记清楚】  
		# 证明：
		# 因为dL/dz = (dL/da)(da/dz),	
		# 又公式σ'(z)=σ(z)*[1-σ(z)]		#【这个公式很重要，记清楚,橙色深度学习上有推导】
		# 所以dL(a,y)/dz = a-y    
		
		dL/dw1 = (dL/dz)(dz/dw1) =x1*(dL/dz);
		dL/dw2 = x2*(dL/dz);(同理)
		dL/db  = dL/dz       
		
	编程中会把上面的式子这么表示：
	dw1 = dL/dw1 = x1*dz;
	dw2 = dL/dw2 = x2*dz;
	 db = dL/db  = dz	【这三行行中的dz表示dL(a,y)/dz】
	
	【重点来了】求出了上面的这些式子，就可以求出单个样本的一次梯度迭代(更新)了：
	w1 = w1-α*dw1			即[w1 = w1-α*x1*(a-y)]
	w2 = w2-α*dw2			即[w2 = w2-α*x2*(a-y)]
	 b = b -α*db			即[ b = b -α*(a-y)]
       
【1.1】当标签y为0时,损失函数为-log(1-a),为使损失函数越小,就必须使a无限接近0。
		即标签为0时，让损失函数越小会使得其预测值(激活值)会趋向于等于0，正是趋向于正确答案的操作。           
【1.2】当标签y为1时,损失函数为-log(a)  ,为使损失函数越小,就必须使a无限接近1。
		即标签为1时，让损失函数越小会使得其预测值(激活值)会趋向于等于1，正是趋向于正确答案的操作。
		
【2】总体成本函数：
		J(w,b)=-1/m *Σ[y(i)log(a(i))+(1-y(i))log(1-a(i))],即对m个样本求和后再平均，Σ是求和符号  
		也即J(w,b)=-1/m *ΣL(a(i),y)		其中a=σ(z)，a(i)=σ(z(i))是第i个样本的激活值(预测值)
		
【3.1】损失函数：是衡量单一训练样本的效果      
【3.2】成本函数：用于衡量参数w和b的效果,他是在全部训练集上来衡量

编程代码：【伪代码，不能运行，只是讲解帮助理解】
	# 以只有两个特征的样本为例：
J=0
dw1=0
dw2=0
db=0
for i in range(1,m+1):	#遍历m个样本	#视频中的写法是 for i=1 to m 
	z[i]=w[t]*x[i]
	a[i]=σ(z[i])
	J+=-y[i]log(a[i])+(1-y[i])log(1-a[i])
	dz[i]=a[i]-y[i]
	# 由于只有两个特征，下面的几行代码对特征不需要使用循环遍历，假如很多特征，就需要使用循环遍历了。
	# 但后面讲了for循环效率低下，要使用向量化方式
	dw1+=x1[i]dz[i]
	dw2+=x2[i]dz[i]
	db +=dz[i]
J/=m	#即把m个损失函数之和也就是成本函数，除以m个样本
dw1/=m 
dw2/=m
db/=m

dw1=fy(j)/fy(w1)  #fy是求偏导符号，我自己简写的
w1 = w1-α*dw1		
w2 = w2-α*dw2			
b  = b -α*db
# 以上代码只对所有样本进行了一次迭代
# 可能会有的疑问：求出了成本函 数J，为什么没有最小化成本函数J?
# 答：最小化成本函数J的方法就是梯度下降法，上面的代码就是迭代就是在运用梯度下降法。