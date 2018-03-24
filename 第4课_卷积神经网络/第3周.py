# 第3.3课内容
滑动窗口目标检测法：
	首先选定一个特定大小的窗口，将这个窗口（从图片左上角开始）输入卷积网络，卷积网络开始进行预测，即判断该窗口内有没有汽车，
	然后将窗口稍向右滑动，并输入给卷积网络，检测这一个窗口内有没有汽车。即每次输入进卷积网络的只是这张大图片的某个小窗口范围内
	的图片。依次重复操作直到这个窗口滑过图像的每一个角落，对每个窗口位置的图片按0和1进行分类（即有或没有目标）。
	为了滑动得更快，可以选用较大的步幅。
	也可以选取更大的窗口进行滑动。
	
滑动窗口目标检测法有很明显的缺点，就是计算成本。因为你在图片中剪切出太多小方块，卷积网络要一个一个地处理。如果选用的步幅很大，
显然会减少输入卷积神经网络的窗口个数，但是粗粒度可能会影响性能。反之，如果采用小粒度或小步幅，传递给卷积网络的小窗口会特别多，
这意味着超高的计算成本。

所以在神经网络兴起之前，人们通常采用更简单的分类器进行对象检测，比如简单的线性分类器。至于误差，因为每个分类器的计算成本都很低，
它只是一个线性函数，所以滑动窗口目标检测算法表现很好。然而，卷积网络运行单个分类任务的成本却高得多，像这样滑动窗口太慢了。除非
采用超细力度或极小步幅，否则无法准确定位图片中的对象。不过，庆幸的是，计算成本问题已经有了很好的解决方案，大大提高了在卷积层上
应用滑动窗口目标检测器的效率。

----------------------------------------------------------------------------------------------------------------------------------
#第3.4课内容

把全连接层转化成卷积层：
比如 使用5*5的过滤器，在全连接层来实现卷积，若全连接层的前一层图像是5*5*16，全连接层有400个节点就使用400个5*5*16的过滤器对图像
进行卷积得到输出维度为1*1*400，我们不再把它看做一个含有400个节点的集合，而是一个1*1*400地输出层。从数学角度看，他和全连接层是一
样的，因为这400个节点中的每一个节点都有一个5*5*16维度的过滤器，所以每个值都是上一层这些5*5*16激活值经过某个任意线性函数的输出结果。
不管原来有几个全连接层，每个全连接层都可以这样转化成卷积层。

#【疑问】
为什么要把全连接层转化成卷积层呢？把图片拉成一个向量有什么不好？那么多过滤器，过滤器的参数都是一个个的慢慢训练数据得到的吗？
难道进行卷积速度会特别快？        
答：好像原因不是下面的这个回答。因为直接把5*5*16拉成一个向量根本不需要做什么运算，变成卷积层的话还得训练400个卷积核的参数，        
这样不是更麻烦吗？                           
这段我摘抄来的，不知道对不对。答：我们分类使用的网络通常会在最后连接几层全连接层，它会将原来二维的矩阵（图片）压扁成一维的，从而丢失了空间信息，最后训练输出      
一个标量，这就是我们的分类结果。而图像语义分割的输出需要是个分割图，且不论尺寸大小，但是至少是二维的。所以，我们需要丢弃全连接层，
换上全卷积层，而这就是全卷积网络了。具体定义请参看论文：Fully Convolutional Networks for Semantic Segmentation
答：因为卷积层有参数共享和稀疏连接两个优点。卷积网络减少参数的2种方法是：
	(1)参数共享。因为特征检测例如垂直边缘检测如果适用于图片的某个区域，那么它也可能适用于图片的其他区域。      
	(2)稀疏连接。输出矩阵的每个值都只与过滤器大小数量个输入矩阵像素值有关，而与输入矩阵的其他像素值无关。（即，不再像全连接那样下一层
	   的每个神经元都与上一层的每个神经元相连）        
		

#在卷积层上应用滑动窗口算法的内容，它提高了整个算法的效率。这种算法有个缺点，就是边界框的位置可能不够准确。
假设输入给卷积网络的图片大小是14*14*3，测试集图片是16*16*3，按照上节课的滑动窗口检测法，是先从左上角滑动，步幅为2，这样就有
四个子集。结果发现这四次卷积操作中的很多计算都是重复的。滑动窗口的卷积应用，使得卷积网络在这四次操作过程中很多计算都是重复的。
最终，在输出层这2*2的四个子方块中，蓝色的是图像左上部分14*14的输出。

所以该卷积操作的原理是：
我们不需把输入图片分割成四个子集分别执行前向传播，而是把它们作为一张图片输入给卷积网络进行计算，其中的公有区域可以共享很多计算。

我们不用依靠连续的卷积操作来识别图片中的汽车，我们可以对大小为28*28的整张图片进行卷积操作，一次得到所有预测值。

----------------------------------------------------------------------------------------------------------------------------------
# 第3.5课内容
# 指定边界框
# 有一个能得到更精确的边界框的算法是：YOLO算法
YOLO意思是，你只看一次。YOLO的方法是：比如，你的输入图像是100*100，然后在图像上放一个网格，为了介绍简单一点，我用3*3网格，在实际
实现的时候会用更精细的网格，可能是19*19。基本思路是，使用图像分类和定位算法（前面视频介绍过得算法），然后将算法逐一应用到9个格子上。     

更具体一点，你需要这样定义训练标签：即对于9个格子中的每一个，制定一个标签y,y是8维向量，[是否对象Pc,对象中心横坐标bx、纵坐标bw，对象
宽bw、高bh，有没有其他对象（三个对象：汽车c1、人c2、摩托车c3）]。对于有两个对象的整张图片，YOLO算法的方法是：取两个对象的中心坐标，
然后将这个对象分配给包含对象中心点的格子，即使有时候中心格子同时有两辆车的一部分。对于某个格子，都有一个目标标签（因为是训练集，并非
正在预测，所以有目标标签）。其中bx,by,bh,bw是指定边界框位置。最后，因为目标输出是3*3*8，所以总的输出尺寸也是3*3*8，即输出层的3*3*8
的9个向量(8维向量)对应于分割为3*3块的各块，由于3*3块，则每块最终输出的向量是由8维向量组成。      

至于输入到输出的中间网络结构，就是卷积层池化层等等构成的，还是用反向传播训练网络。      

YOLO算法的优点在于：神经网络可以输出精确的边界框，所以测试的时候，你做的事，喂入输入图像x，然后正向传播，直到你得到这个输出y，然后对
这里的3*3位置对应的9个输出向量中的元素分别标为0或1以及边框的中心坐标和宽高。只要每个格子中对象数目没有超过1个，这个算法应该是没问题的。
1个格子中存在多个对象的问题，我们稍后再讨论。

YOLO方法比滑动窗口法优点就是不会受到滑动窗口法分类器的步长大小限制，其次这是一个卷积实现，你并没有在3*3网格上跑9次算法，或者19*19的网
格上跑361次，相反，这次是单次卷积实现，你使用了一个卷积网络。有很多共享计算步骤，在处理这3*3计算中很多计算步骤是共享的。所以这个算法
的效率很高。实际上他的运行速度非常快，可以达到实时识别。

对于编码这个对象边界框时，有一个约定就是，该对象所在的格子左上角坐标为（0,0），右下角坐标为（1,1），对象中心横坐标bx是网格长度的百分
比，对象中心纵坐标by是网格高度的百分比，对象宽度bw是网格的宽度的百分比，高度bh是网格长度的百分比。



下面就是YOLO算法：      （YOLO算法不使用滑窗法）          
把整张图片分割为3*3或者19*19块，然后对每一块都进行卷积，但不是依次卷积，而是最终得到了
比如你把图片分割了3*3块，最终就得到了3*3*n的最终输出，输出层的3*3*n的9个向量(n维向量)对应于分割为3*3块的各块，由于3*3块，则每块最终
输出的向量是由8维向量[是否对象,对象中心横、纵坐标，对象宽、高，有没有其他对象（三个对象：汽车、人、摩托车）]组成。
这样就不需要使用滑窗法依次滑动输入卷积神经网络了来进行识别了。

----------------------------------------------------------------------------------------------------------------------------------
# 第3.6课内容
# 交并比（IoU:intersection over union）
# 交并比 用来评价你的对象定位算法是否精准，衡量了两个边界框重叠的相对大小。
在对象检测算法中，你希望同时还能够定位对象（不光检测到对象，还要定位对象）。所以如果实际的边界框和你的算法给出的边界框不一致，那么该
怎样评价这个算法的好坏呢？
交并比函数做的就是：计算两个边界框交集和并集（面积）之比.
一般约定，在计算机检测任务中，如果IoU>=0.5，就说检测正确。如果预测器和实际边界框完美重叠，IoU就是1，因为交集等于并集。但是一般来说，
只要IoU>=0.5，那么结果是可以接受的。你也可以设置为0.6或者更高。所以这是衡量定位精确度的一种方式，你只需要统计算法正确地检测和定位对象
的次数，判断对象定位是否准确。

# 我有一个问题：他的实际边框怎么得到的呢？靠人工标注起来，然后再计算吗？如果这样那也太麻烦了吧？
答：因为是测试集，所以测试集还是有目标标签的。测试集就是用来评价算法好坏的，当然会有目标值与预测值的比对。因此，目标标签的边框与预测
值的边框就都有了。
K折交叉验证 http://sofasofa.io/forum_main_post.php?postid=1000354&

----------------------------------------------------------------------------------------------------------------------------------
# 第3.7课内容
# 非最大值抑制
对象检测中的一个问题是，你的算法可能对同一个对象作出多次检测，所以算法不是对某个对象检测出一次，而是检测出多次。非最大值抑制这个方法
可以确保你的算法对每个对象只检测一次。
假设你需要在这张图片里检测杏仁核汽车，你可能会在上面放19*19网格，理论上这辆车只有一个中点，所以他应该只分配到一个格子里，即理论上应该
只有一个格子作出有车的预测，实践中当你跑对象分类和定位算法时，对于每个格子都跑一次，因为这辆车会占据好几个格子，所以这好几个格子都会
作出有车的预测。
分步介绍非最大值抑制是怎么起效的：
当你跑算法的时候，最后可能会对同一个对象作出多次检测，非最大值抑制做的就是清理这些检测结果，这样的话一辆车只检测一次，而不是每辆车都
触发多次检测。具体上，这个算法做的是：首先看看每次报告，每个检测结果相关的概率Pc。首先看概率最大的那个，这个例子中是0.9，然后就说这
是最可靠的检测。然后非最大值抑制就会逐一审视剩下的矩形框（即所有和这个最大的边界框有很高交并比、高度重叠的其他边界框），这些边界框输
出就会被抑制，所以这两个Pc分别是0.6、0.7的矩形框和0.9的矩形框重叠程度很高，所以会被抑制。同理，接下来，逐一审视剩下别的对象（比如另
一辆车）的矩形，找出概率最大的一个矩形，然后非最大值抑制算法就会去掉其他IoU值很高的矩形。

非最大值抑制意味着你知输出概率最大的分类结果，但是抑制很接近但不是最大的其他预测结果。

算法的细节：首先，在这个19*19网格上跑一下算法，你会得到19*19*8的输出尺寸。但是对于这个例子来说，我们简化一下，就说你只做汽车检测，去掉
C1、C2、C3，然后假设这条线对于19*19的每一个输出，你会得到这样的输出预测，即[有对象的概率，边界框的四个参数]。如果你只检测一种对象，那
么就没有C1、C2、C3这些预测分量。对于多个对象处于一个格子中的情况，吴恩达会放在编程练习中。
现在要实现非最大值抑制，你可以做的第一件事情是，去掉所有边界框，我们就将所有的预测，所有的边界框PC<=某个阈值比如0.6的边界框去掉，这样
就抛弃了所有概率比较低的输出边界框。所以思路是对于这361个位置，你输出一个边界框以及其概率Pc。所以我们只是抛弃所有低概率的边界框。

如果要检测多个类别的对象，如行人，摩托车，汽车，最好的方法是独立进行三次非最大值抑制，对每个输出类别都做一次。

# 疑问：第3.5课讲的没说一个对象被多个格子占据的情况，只说了一个格子中对象的中心坐标以及长和宽。本节课却讲的是输出多个边界框，这么多
#的边界框是怎么得出来的，为什么包围汽车会有只包围一半的矩形框？难道是因为预测出来的结果不准确？这非最大值抑制算法是用在训练的时候呢
#还是用在测试的时候呢？由于是优化，那肯定是在训练阶段的优化算法咯？真的凌乱了！搞不清楚

----------------------------------------------------------------------------------------------------------------------------------
# 第3.8课内容
# anchor box

到目前为止，对象检测中存在的一个问题是，每个格子只能检测出一个对象。如果你想让一个格子检测出多个对象，你可以这么做：anchor box。
例如一张图片中，行人的中点和汽车的中点都落入在同一个格子中。对于这个格子，如果输出向量y为[pc,bx,by,bh,bw,c1,c2,c3]，你可以检测这
三个类别行人、汽车和摩托，他讲无法输出检测结果，所以我必须从两个检测结果中选一个，而anchor box的思路是：预先定义两个不同形状的
anchor box。把预测结果和这两个anchor box关联起来，一般来说，你可能会用更多的anchor box，可能要5个甚至更多。对于本讲视频，
我们就用两个anchor box，这样介绍起来简答一些。你要做的是定义类别标签y=[pc,bx,by,bh,bw,c1,c2,c3;pc,bx,by,bh,bw,c1,c2,c3]，16维，该向
量不是重复两遍，而是上半部分是属于anchor box1，下半部分是属于anchor box2。因为行人的形状更类似于anchor box1（形状是细高的长方
形），y的前8个元素对应于行人的分类及边框，即Pc为1表示有对象，c1=1,c2=0,c3=0,表示对象为行人；汽车的形状更类似于anchor box2（形状是
长扁的长方形），y的后8个元素对应于汽车的分类及边框，即Pc为1表示有对象，c1=0,c2=1,c3=0,表示对象为汽车。

总结一下，用anchor box之前，你做的是：对于训练集图像中的每个对象，都根据那个对象的重点位置，分配到对应的格子中，所以输出y就是3*3*8.
因为是3*3网格，对于每个网格位置，我们有输出向量，包含Pc，然后边界框参数，然后c1,c2,c3。现在用到anchor box这个概念，是这么做的：
现在每个对象都和之前一样分配到同一个格子中，分配到对象中点所在的格子中，但是他还分配到一个anchor box，分配到一个格子和一个和对象
形状交并比最高的anchor box。所以这里有两个anchor box，你就取这个对象。不管选的是哪一个，这个对象不止分配到一个格子中，而是分配到
一对（格子，anchor box）对。这就是对象在目标标签中的编码方式，所以现在输出y就是3*3*16，或者看做3*3*2*8。


这个算法有两种处理不好的情况：
（1）只对于两个对象出现在一个格子中处理的不错，但是对于三个对象同时出现在一个格子中，处理的很不好。
（2）对于两个对象都分配到一个格子中，并且他们的anchor box形状也一样，这种算法处理的也很不好。
以上两种情况出现了的话，你需要引入一些打破僵局的默认手段，专门处理这种情况。不过希望你的数据里不会出现这种情况。

anchor box是为了处理两个对象出现在同一个格子中的情况，实践中，这种情况很少发生，特别是如果你是用的是19*19网格而不是3*3网格，因为两个
对象中点处于361个格子中同一个格子中的概率很低。anchor box能让你的学习算法能够更有针对性，特别是如果你的数据集有一些很瘦很高的对象，
比如说行人，还有项汽车一样很宽的对象，这样你的算法一些输出单元就能够更有针对性的处理很宽很胖的对象比如说车子，另一些输出单元可以针
对检测很高很瘦的对象，比如说行人。人们一般手工指定anchor box形状，你可以选择5到10个anchor box形状，覆盖到多种不同的形状，可以涵盖
你想要检测的对象的各种形状。
更高级的版本：后期YOLO论文中有更好的做法：使用Kmeans将两类对象形状聚类，如果我们用它来选择一组anchor box,选择最具代表性的一组anchor
 box，可以代表你试图检测的十几个对象类别，但这其实是自动选择anchor box的高级方法。一般来说，直接人工指定anchor box形状即可。


 ----------------------------------------------------------------------------------------------------------------------------------
# 第3.9课内容
# YOLO对象检测算法
