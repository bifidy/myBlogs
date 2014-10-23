第二章 万变不离其宗——数据

###从二进制到对象

---

在本篇开篇之初，你不妨先看看这篇文章：[逼格更高-让不懂编程的人爱上iPhone开发1-Swift+iOS8版 -开篇][1]。文章是笔者无意中在[CocoaChina][2]上看到的，其中**关于计算机语言**的举例非常适合科普。
大部分的计算机原理总是散落在各个知识层面上，需要我们自己去归纳和体系化。从零散的知识当中理出一条清晰的脉络，也是学习的必备技能之一。  

 * **二进制**   
在计算机科学发展的历史中，从来不缺乏智慧。二进制先于电子科学被发明，却成为了电子科学的基石。就笔者自己观点而言，二进制可以看作是数学与逻辑的高度统一，虽然笔者自己也说不出什么是逻辑。另一方面，二进制使物理化、自动化的计算变的容易且高度可执行。  
仅仅出于展示的目的，笔者用`swift`编写了一个片段来模拟演示，即如何使用纯粹的逻辑进行计算。如果您之前还未接触过`swift`也无妨，只需要查看运算函数如何使用即可。此外，笔者也将本篇文章的展示代码以`Playground`形式放在了[Github][3]上，您可下载指本地进行调试：  

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

###常量与变量

---

再次把常量提到一个高度，已经是swift的时代了。在此之前，常量在各个语言中并不是很受重视。


###结构体、指针与对象

---



###函数、方法与block

---



###数据的传递方式

---

值传递，地址传递，引用传递。

###然后

---

《编译原理》


[1]: http://zhuanlan.zhihu.com/kidscoding/19855085
[2]: http://www.cocoachina.com
[3]: http://www.github.com