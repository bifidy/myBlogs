第二章 底层浅析——从二进制到对象

文/某鸟

在本篇开篇之初，你不妨先看看这篇文章：[逼格更高-让不懂编程的人爱上iPhone开发1-Swift+iOS8版 -开篇][1]。文章是笔者无意中在[CocoaChina][2]上看到的，其中**关于计算机语言**的举例非常适合科普。     

大部分的计算机原理总是散落在各个知识层面上，需要我们自己去归纳和体系化。从零散的知识当中理出一条清晰的脉络，也是学习的必备技能之一。笔者总是希望能够将所学的知识尽可能的落在实处，所以也对语言发展自底向上的做了一番分析，希望你能从本文有所收获。 


### **二进制**   

---
我们先来梳理下之前笼统的知识：通常的语言按层次与转化过程划分为高级语言 -> 汇编语言 -> 机器码，所有的程序代码到最后在储存和执行时，都会在不同时机被转化成为二进制数据。    

在计算机科学发展的历史中，从来不缺乏智慧。二进制先于电子科学被发明，却成为了电子科学的基石。就笔者自己观点而言，二进制可以看作是数学与逻辑的高度统一，虽然笔者自己也说不出什么是逻辑。另一方面，二进制使物理化、自动化的计算变的容易且高度可执行。  

我们都知道，所有的代码最终都将以二进制的形式存储在某个储存介质中，且以二进制的方式执行运算。笔者之前学过一捏捏[单片机][3]，其作为一个简陋却典型的计算机结构，可以清晰的为我们展示我们的代码是如何实际的物理设备当中存在和运行。  

鉴于出于展示的目的，笔者用`swift`编写了一个片段，来模拟演示单片机中是如何使用纯粹的逻辑进行计算的。（如果您之前还未接触过`swift`也无妨，只需要查看运算函数如何使用逻辑运算符进行运算即可。此外，笔者也将本篇文章的展示代码以`Playground`形式放在了[Github][4]上，您可下载至本地进行调试）。所以废话不多，先上代码：      


<pre lang = "swift">
// 单片机8位二进制加法模拟=========================
//1.模拟硬件环境
let I = true
let O = false

var ACC = [O,O,O,O,O,O,O,O] //累加器ACC
var B = [O,O,O,O,O,O,O,O] //寄存器B
var AC:Bool = false //半进位标志位

//传递值至累加器
func MOVA(input: [Bool]) -> Void{
    ACC = input
}

//不借位加法
func ADD(input: [Bool]) -> Void{
    B = input
    for index in 0...7{
        ACC[index] = ACC[index] != B[index]
    }
}

//借位加法
func ADDC(input: [Bool]) -> Void{
    B = input
    for var index = 7; index >= 0; --index{
        ACC[index] = ACC[index] != AC
        AC = !ACC[index] && AC
        ACC[index] = ACC[index] != B[index]
        AC = AC || (!ACC[index] && B[index])
        //PS:这段运算逻辑为本人臆测，或许有更简单的办法
    }
    AC = false
}

/**
赠品：将二进制转化为十进制并打印
:param: input 需要填入的二进制数组
:param: name  数组的名称
*/
func LOG(input: [Bool],name: String) -> Void{
    var decimal = 0
    var weight = 1
    for var index = 7; index >= 0; --index{
        if input[index] {
            decimal += weight
        }
        weight *= 2
    }
    println("\(name) is \(decimal)")
}

//2.开始测试
let R0 = [O,O,O,O,O,I,I,O]
let R1 = [O,O,O,I,I,O,O,O]
let R2 = [O,O,O,I,I,O,O,O]
LOG(R0, "R0") //R0 is 6
LOG(R1, "R1") //R0 is 24
LOG(R2, "R2") //R0 is 24
MOVA(R0)
ADD(R1)
LOG(ACC, "ACC") //ACC is 30
ADDC(R2)
LOG(ACC, "ACC") //ACC is 54
</pre>

在上面这段代码中，展示了单片机的`MOV`、`ADD`、`ADDC`指令的具体实现。而这几个指令，其实全部来自汇编语言。  

对不同语言来说，将编写好的代码转化为汇编代码的时机和方式并不完全相同。对于C语言这样的静态面向过程的语言来说，当你编译代码的时候，编译器就会将所有的代码编译成一个汇编代码包了。而对于其他语言来说，转化的时机和过程就会相对复杂些。      

汇编语言到机器码的转换则相对简单，对一个8位单片机来说，每一个指令都对应着一个二进制操作码，然后与指令的参数（当然也是二进制）凑成8位的整数倍，存在一个叫做RAM的内存区域，用来按一定程序执行。对应的，所有的标志位，寄存器，和数据的储存会放在一个叫做ROM的内存区域。至此，我们就把一个程序完全转化成了二进制，储存在了内存中以待执行。（顺便一提，这种把程序和数据分开储存的架构就叫做[哈佛结构][5]）。  

随着计算机系统的复杂，真正的底层技术在上述的架构上进行了很多拓展和革新，但正如本文题目所言，万变不离其宗，数据，是这一切的原点。所有的一切，最终的物理归宿都是储存介质上的二进制数据，无一例外。  
笔者知识所限，以上代码的实现过程可能并不完全符合真实的汇编指令，只希望您能通过这个小例子理解我们所书写的代码在真实世界中到底是以怎样的形式存在。  

刚才提到过，每一个汇编指令都对应着一个二进制操作码，这里一定要说的一点是，在不同的运算芯片和计算机架构，这些对应并不完全相同，换言之，汇编语言的可移植性并不强。即便对于`iOS`开发来说，我们遇到的硬件底层数量已经大大降低，可就在本文书写的同时，我们的程序正要求从32位进化为64位，背后的原因当然是因为处理器。  

也所以，在一般的iOS开发中，我们并不用将过多的精力投入在汇编层中，即便在调试中，我们常看到程序`crash`在一大片的汇编指令中，它们提供的信息通常也是有限的。  
（或许是笔者经验太浅，没有接触过任何根据汇编指令进行调试的方法，如果以上表述有误，还请指出，不甚感谢。）  

### **基础数据类型**

---
  
刚才在讨论二进制的时候，着眼点是放在储存上的。现在我们已经知道了，我们编写的所有代码最终都会以二进制的方式储存在某个地方的时候，我们就可以换个着眼点了。  
在C语言中，基本的数据类型也同时伴随着一个关键字，如下表所示：

![DataTable][i1]
 
以上6种类型之所以称为基础类型，并以此分类，大部分是科学设计和长期开发实践的结果，这里不再纠结原因。而`Objective-C`（以下简称OC）作为C语言的超集，自然也是全盘接收。在OC中，还多出了一个`BOOL`类型。
不同的数据类型，储存空间不同，编码方式也不同。  

 * 整形变量会根据无符号整数(`unsigned`)的声明标志来确定是否使用[补码][6]来进行存储。  
 * 浮点型则将编码分为了数据与小数点位两部分，用来记录小数。  
 * 字符型则会采用标准化的字符集编码，C语言使用了`ASCII`，在OC中则可以选择字符的编码类型，例如`utf8`。  
 
（顺带一提，虽然BOOL型只需要一个二进制位就可以记录值，可实际上却占用了一个字节，也就是8位。想想也是挺浪费的，不过另外7位除了别的`BOOL`值也没其他类型可以用，更何况按位记录内存地址的开销又得花费额外的4位(0:0000~7:1111)，所以，别麻烦了，现代设备倒也不缺那点空间，就这样吧= =）  

相对来说，数据的储存空间不同对程序的影响会更大。在C语言中，当我们声明一个变量的时候，变量其实包含了3个值。一个是它的标识符，也就是名字。一个是它的地址，而这个变量真正储存的值，是通过用标识符找到对应的地址，然后从地址当中读出来的。这里的关键点在于地址值，要知道我们的内存区域其实是个排好了序号的矩阵，每个最小单元就数据而言，还是一个字节，也就是8位二进制。比如说一个float型的数据用了4个字节来存储，那我们应该如何去记录它的地址值呢？  

C语言的做法是，只记录一个变量的起始地址，然后根据变量类型去计算和取出数据。这样的设计，使所有变量的地址值都变得短小、等长、且又唯一。  
这里给出一段C语言的片段来证明：

<pre>
short shortArray[2]={1,1}; //00000000 00000001 00000000 00000001
int *intpoint = shortArray;
NSLog(@"%d",*intpoint); //return 65537
</pre>

例子中，我们利用了一些C语言的特性。首先，C语言数组的地址是连续的，而两个2字节的`short`型数据同一个4字节的`int`型数据储存空间大小恰巧相同。所以我们声明了一个int型的指针指向了该数组的首地址，就会读出一个1*65536+1的数字了。  

对于数据来说，在物理上唯一对应的只有储存该数据的内存地址，所有的寻址方式到最后都是通过该地址来获得地址的。但与此同时，数据对应的内存地址却又往往是变动的，仅能保证程序每次运行时，地址是相对不变的。   

所以针对这种情况，分层解决问题的思路会省很多事，我们只负责通过标识符来存取数据，而物理地址相关的工作一律交给编译器和系统环境。本身不是什么很费脑子的解决方法，只是多几句话把它点出来。  

### **结构化数据**

---
 
如果从物理储存中看数据，他们彼此都是独立的，每个数据占几个小格子，仅此而已。   

随着数据量的增大，仅仅用内存地址来标识某个数据，开始挑战人的记忆力极限，我们就发明了标识符，起一些更为直观的名字来对应一个地址，然后再去取值。为了让存取更为容易，每一个程序其实都会为自己的变量与对应地址建立一个动态的映射表。当然，这还有另外一个更具决定性的原因，操作系统会在程序每一次启动的时候，都会重新分配对应的内存区域，或者说，内存地址对于程序依旧是个变量，只不过是由系统而非我们来控制。  

将一个变量以符号表示，当做常量来使用，解方程的时候我们这么做，设计程序的时候也一样。技术的发展历程中总是充满了解决问题的智慧，在使用和理解机制的时候，我们或许只是觉得容易，但当我们设身处地的思考发明者当时究竟以怎样的思路发明了方法时，就会发现设计者的高度理性与科学思维，对笔者而言，这也是技术的魅力之一。  

说回开发，我们已经猜想到了基础数据类型的划分，猜想到了发明标识符的原因，说到底，都是为了解决两个问题。一个是与底层的转化效率，另一个，则是为了人。一方面，让人们更简单的使用和操控硬件，另一方面，让我们更容易的解决实际发生的问题。  

现实中遇到的问题远非只是加减乘除一群独立的数据这么简单，如果我们希望能够解决更复杂的事，我们就需要额外的工具。让数据产生关系，甚至结构化，系统化就是其中之一。只因为我们要解决的问题，往往来源于现实生活中的抽象，让数据模拟现实生活中的关系，也是解决问题的前提之一。  

在C语言中，提供的工具是构造类型，大概有这么几种，指针、数组、枚举、结构体。C语言的设计十分久远，所以其与硬件底层接轨的痕迹还比较重。这里说的痕迹主要体现在内存的操作方式上。通过基础数据类型确定了每种数据需要占用的内存单元个数之后，通过内存地址来寻址变的容易多了。而在C语言中定义的关系，实质上只是内存地址的计算。  

 * **指针**：指针本身也是一个数据类型，拥有自己的标识符，内存地址，和地址中所储存的值。不过除此之外，指针还额外记录了自身所指向变量的内存个数，也限制了自己的值一定是内存地址。  
 这样的设计从实现上只是加了一个指针标记和类型记录，但其作用却出奇的大。
 有了指针的出现，我们就可以通过对地址值进行计算，来存取某个内存单元，这是对存取值的方式拓展。而指针的存在，搭配数组和结构体，对基于内存地址的数据存取会变得更为灵活。  
 
 * **数组**：C语言的数组功能在今天看来或许稍显简陋。他只是作为固定数量相同类型的数据集合出现，其特殊之处在于有序性。而C语言数组的有序性其实是因为内存地址的顺序储存。  
 数组从实现上来讲，其实是一个记录了额外数据的指针，指针记录指向数据类型，数组则记录元素的数据类型，而后再记录自己元素的个数，并为自己做一个数组的标记就可以实现数组的有序存取值了。具体的方式非常简单，数组作为指针，先记录了首元素的地址，而后取第几个元素，这个地址就以记录的数据类型为单位长度加几次，取到相应位置的数据。之前展示C语言变量设计的时候，就利用了这个特性。  
 
 * **结构体**：相对于数组来说，结构体就灵活了许多。结构体不限制元素的类型，包括之前的指针与数组，都可以当做结构体的成员。当然了，作为C语言的构造类型，结构体成员数据的内存地址依旧是尽可能连续的，这里说尽可能连续，是因为涉及到了“[内存对齐][7]”这样的寻址优化，这里就不深入解释了。   
 抛开这个优化过程，结构体的内存地址结构也是数组一般的按顺序储存，只不过因为内部元素相对复杂，通过顺序数来取值就不如用成员标识符来得方便了。当然了，你也可以在结构体中设计若干数量的同类型数据，再额外设计一个对应指针指向首元素，通过对该指针值的加减来取值，实现效果与数组会惊人的相似~  

C语言作为一门历史悠久的编程语言，其对于底层还是很透明的。一方面我们还像汇编语言一样基于内存地址存取进行运算，但另一方面却开始以人的思考方式重新定义了如何去操作机器，这也算是编程语言开始步入高级的里程碑了吧。  

###对象

---
 
作为一门编程语言，C语言还有很多令人惊叹其设计思路的特性，鉴于笔者知识有限，就不再介绍了。只是通过C语言的构造类型来解释，构造一个数据体系时，其物理底层对应的实现方式。  

不过以这个阶段为分水岭，在C语言这样基础的语言之后，我们对底层的接触就变的越来越少了，虽然OC作为C语言的超集存在，但其利用内存的方式不再那么透明，一方面，开发的考虑重点已经从物理底层转移到了面向对象。另一方面，在面向对象频繁的指针调用和继承机制下，再让开发者通过操作底层内存的形式去写实现，实在是有点惨绝人寰。所以，说OC与C语言之间还经过了一次翻译也不为过。  

其实从C语言开始，我们就已经试着去屏蔽底层的物理细节，而把程序构建在一个抽象化的环境之中。不过真正享受到这种抽象带来的便利，却是面向对象的架构。  

OC作为C语言的超集，其面向对象的实现方式也基本都是由C语言编写的。为了让面向对象实现的更为纯粹，OC引入了新的语法和关键字，也开发了专用的编译器。  

在OC中，更习惯称函数为方法，一方面用以区别C语言的函数，另一方面，基于OC的对象特性与动态特性，OC的方法与C语言的函数在实现上也有所不同。不过，即便不再是单片机那个年代，OC也还是选择了一如既往的将数据与计算过程分开储存。所以在知晓这个前提的同时，我们不妨稍微剖析一下OC的内存机制。  

首先，在OC中对象机制最重要的工具是指针。由于在面向对象时，我们所需要的内存不再向C语言那样都是固定的数量，而是随时都发生着变化，我们需要引入一个机制来管理内存，否则一味的占用新内存的话，一个大数量的for循环就足以引发程序crash了。在OC中，我们使用的机制是引用计数（Reference Counting），我们只负责修改引用计数，系统会根据这个数字来调用对应对象的构造函数`alloc`和析构函数`dealloc`。当然，在引入自动引用计数（ARC）之后，我们基本上就不用再去编写管理内存的代码了。只需要知道，在引用计数机制下，决定一个对象存在与否的是指向它的指针。  

指针方式与C语言中变量的标识符其实很相似。变量和结构体在构造之初就拥有一个固定的标识符与地址一一对应。而指针则是储存了每个对象的地址，不同之处在于标识符与地址的对应是存储在一个索引表里的，而每个指针本身就是一个变量，它们的标识符存在索引表对应自己的地址，而自己的值存储着指向对象的地址。  

使用指针来代替对象有一个好处，就是储存空间不再连续。在C语言中，一个`char[n]`的数组，就意味着它会占用连续的n字节内存（`char`是1字节的数据类型）。而在OC中，我们记录的是每个对象的指针，所以一个`NSArray`的存储可以散布在内存的各个区域。当然我们可以也可以在C语言中构造一个储存指针的数组，但反过来看，在OC当中占用一片连续的内存就变的艰难了。而且并不仅限于数组，OC中任何一个对象管理类内实例的方式也都是通过指针，所以，我们大概要和指针的计算说再见了。  

在OC中，每个对象的构建其实也还是通过结构体实现的。只不过利用指针的特性规避了连续和固定内存空间的限制，对象的灵活性被大大提升了。所以说，指针机制可以说是OC实现面向对象的核心机制，当然，这仅仅是从数据和内存管理的角度。  

作为面向对象的语言，其另外一个区别于结构体的特征是拥有自己的方法。惭愧的说，虽然笔者是个iOS程序员，但是涉及到OC的底层实现接触的也不多，所以对于方法储存的具体实现过程也没有详细学习过。不过笔者曾接触过一捏捏`python`，在python中，声明一个类内的函数等价于声明一个函数的第一个参数为该类的实例。如此想来，其实一个类的函数或者方法就如同对象一样，只要记录其对应的储存地址就可以了，剩下的就是判断标志和调用方法了。  

而如此分析下来，当硬件上不再分开提供RAM和ROM，而是由编译器自主划分的时候，其实一方面方法和数据在物理上就已经处于同一片内存区域了。而另一方面，当指针机制充斥整个面向对象的架构时，数据也不再连续储存，那么数据与方法的储存只从地址上作以区别也再无不可，毕竟方法也好，函数也好，究其本质依然是一堆二进制而已。  

这个思路在swift中也有了另一种形式的证明，即函数开始拥有数据类型的特征，究其所以，一方面可以优化内存管理的手段，另一方面，也算是为储存过程的数据类型正名吧。毕竟在之前，OC中的block作为储存过程的对象闭包，在整个OC语法中，还是稍显另类。  

###总结

---

从底层向上演化的方式其实也是语言发展的方式，当我们接触的开发方式越来越智能，甚至将抽象的概念从关注点开始重新变的具体时，也总是很赞叹诸位前辈们的智慧。     

文章只是笔者的一番思考，究其重点，还是有很多地方是依靠推断而没有足够的知识与工具去证实，开发学习的过程从来不是一蹴而就，追求捷径总是知其然而不知其所以然的。文中关于OC部分的论述还过于笼统，这些内容会在后面的文章中再一一补充，希望能够帮助大家以一个新的方式来看待开发，学习开发。    

不一定是因为喜欢，只是想做到心里有数。   





[1]: http://zhuanlan.zhihu.com/kidscoding/19855085
[2]: http://www.cocoachina.com
[3]: http://baike.baidu.com/view/1012.htm
[4]: https://github.com/bifidy/myBlogs
[5]: http://baike.baidu.com/view/368294.htm
[6]: http://baike.baidu.com/view/377340.htm
[7]: http://baike.baidu.com/view/4786260.htm

 [i1]:  http://bifidy.qiniudn.com/2014-10-28-DataTable.png