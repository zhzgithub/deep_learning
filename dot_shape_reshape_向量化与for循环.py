# ==================================================================
# 吴恩达视频源代码
import numpy as np
import time
a=np.random.rand(1000000)	#百万维度的数组（由0到1之间的随机浮点数组成)
b=np.random.rand(1000000)

# 以下是向量化方法
tic=time.time()		#time.time()显示的形式为1505095164.431292
c=np.dot(a,b)
toc=time.time()
print(c)
print('Vertorized version:'+str(1000*(toc-tic))+'ms') #打印程序计算时间，toc-tic时间间隔单位为秒，乘1000后单位为ms
# 因为字符串相连接，必须所有都是字符串格式，所以得使用str()函数把浮点型转换成字符串形式

# 以下是for循环方法
c=0
tic=time.time()		
for i in range(1000000):
	c+=a[i]*b[i]
toc=time.time()
print(c)
print('for loop version:'+str(1000*(toc-tic))+'ms')
# ======================================================================

J=0;dw1=0;dw2=0;db=0
for i in range(1,m+1):	#遍历m个样本	#视频中的写法是 for i=1 to m 
	z[i]=w(t)*x[i]		#w(t)表示w的转置，x[i]表示第i个样本，不是滴i个特征
	a[i]=σ(z[i])
	J+=-y[i]log(a[i])+(1-y[i])log(1-a[i])
	dz[i]=a[i]-y[i]
	# 由于只有两个特征，下面的几行代码对特征不需要使用循环遍历，假如很多特征，就需要使用循环遍历了。
	# 但后面讲了for循环效率低下，要使用向量化方式
	
	# 假如很多特征的话：
	for j in range(n_x):		#n_x表示样本的特征数，不是样本个数
		dw[j]+=x[i][j]dz[i]		#x[i][j]表示第i个样本的第j个特征
	# 假如只有两个特征：
	dw1+=x1[i]dz[i]				#x1[i]表示第i个样本的第1个特征
	dw2+=x2[i]dz[i]
	
	db +=dz[i]
J/=m	#即把m个损失函数之和也就是成本函数，除以m个样本
dw1/=m 
dw2/=m
db/=m
----------------------------------------------------------------------------
把上面代码去掉一个for循环：就是去掉dw1,dw2那里的for循环(由于特征只有两个，就没写乘for循环)
J=0;db=0
####改动：
dw=np.zeros(n_x,1)	#n_x表示样本的特征数，不是样本个数

for i in range(1,m+1):	#遍历m个样本	#视频中的写法是 for i=1 to m 
	z[i]=w(t)*x[i]		#w(t)表示w的转置，x[i]表示第i个样本，不是滴i个特征
	a[i]=σ(z[i])
	J+=-y[i]log(a[i])+(1-y[i])log(1-a[i])
	dz[i]=a[i]-y[i]
	####改动：
	dw+=x[i]dz[i]
	
	db +=dz[i]
J/=m
dw/=m		#改动：
db/=m
	
	
# =====================================================================
使用numpy中内置的函数来快速计算，而不用for循环：
import numpy as np
v=np.zeros((n,1),dtype=np.uint8)	#v是n维列向量
np.exp(v)	#对v的每个元素都做e指数运算
np.log(v)	#对v的每个元素都做自然对数运算
np.abs(v)	#对v的每个元素都做绝对值运算
np.maximum(v)	#求v中所有元素的最大值
v**2 		#对v的每个元素都做平方运算
1/v			#对v的每个元素都做倒数运算




# ====================================================================

# 向量化方法
# import numpy as np
# w=[1,2,3]
# x=[4,5,6]
# z=np.dot(w,x)	#这里的dot()是求向量内积，其中w,x都得是一个维度的列表，不能是3*1维度的
# print(z)

# ===================================================================
# 这种方式写法会报错
# 要生成一个列向量形式的数组可以这么来：
# np.zeros((n,1),dtype=np.uint8)
# import numpy as np
# w=[[1,2,3]]
# x=[[4,5,6]]
# w=np.transpose(w)
# print(w)
# x=np.transpose(x)
# print(x)
# z=np.dot(w,x)
# print(z)

# =================================================================
# for循环方法
# import numpy as np
# w=[1,2,3]	
# x=[4,5,6]
# z=0
# for i in range(len(w)):
	# z+=w[i]*x[i]
# print(z)

# ===================================================================
# 只有数组array才有shape的属性和reshape(_,_)方法，列表没有
# 且列表是直接定义，而数组需要使用numpy包里面的array来定义，如：
# import numpy as np
# list1=[[1,2],[4,5]]
# # list1.shape	#会报错
# # list1.reshape(1,4)	#会报错

# # 直接把列表强制转换成数组
# array1=np.array(list1)	#array([[1, 2],
						# #	   [4, 5]])
						
# array2=np.array([1,2,3,4])		# 或者通过这种方式创建数组形式
						
# array3=np.ones((3,4),dtype=np.uint8)	# 或者通过这种方式创建数组形式
# array1.shape
# array1.reshape(1,4)


