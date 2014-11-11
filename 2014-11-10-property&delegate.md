第四章 类内实例——从Property到Delegate

文/某鸟

从本章内容开始，会逐渐具化的展示在OC当中常见的一些概念和


###属性标记

在[第三章 语法浅析——从C语言到Objecitve-C][1]中，笔者已经展示了编译器在遇到`@property`之后，替我们添加的一系列代码。不过在常见的代码示例里，我们遇到的属性声明往往是这个样子的：

<pre>
@property (nonatomic,weak) IBOutlet UIView *view;
</pre>

主要的功能拓展都在圆括号中以参数的方式提交给编译器，让编译器在生成属性的时候，添置额外代码。常见的参数可以分为四类。

 * **多线程保护**  即`nonatomic`与`atomic`，简单来说，就是当属性为`atomic`时，代码中会附加对该属性的线程保护，如此做会保证该属性的线程安全，但也会消耗额外的储存资源。默认情况下，当你不附加参数时，属性是以`atomic`方式生成的，当属性不涉及线程操作时，我们应该为属性声明`nonatomic`。

 * **可读可写**  即`readonly`与`readwrite`。在`readonly`声明下，编译器将只生成该属性的`getter`，以确保我们无法调用`setter`来修改该属性的值。而`readwrite`则意味着`setter`与`getter`都被生成，默认情况下，属性的该参数为`readwrite`。

 * **内存管理**  常见的参数是`strong`与`weak`，除此之外还有`copy`与不常见到的`unsafe_unretained`等等，这类参数直接对应着指针的内存管理，我们在下文中会详细介绍。默认情况下,属性的该参数为`strong`。

 * **存取方法**  这个参数可以修改属性的`getter`与`setter`方法名，写法类似于`getter = anotherName`。这个参数的使用中，比较常见的是`UIView`的`hidden`属性，它的`getter`是`isHidden`。需要注意的是，`readonly`声明下，是不会生成`setter`的，这时候即使你声明了`setter = setValue`，该`setter`也不会被生成。

常见的文献讨论中，大部分会过于倚重对于名词的讲解，而忽略了以上的分类。其实在日常的开发中，线程保护、可读写、与内存管理标记，都是非彼即此的。像以下的两句声明，其实是等价的：

<pre>
@property (atomic,strong,readwrite) NSObject *obj;
@property NSObject *obj;
</pre>

关于属性的声明，更为详细的方法与解释可以参考这篇[官方文档][2]，在此不再赘述。

###点语法

提到了`getter`与`setter`，我们就顺便说一说点语法了。用`.`来表示拥有和调用，始于C语言结构体调用内部变量的语法（这里笔者没有做考证，语言历史太庞杂了ಥ_ಥ）。`.`是C语言中优先级最高的运算符之一，它是一个从左向右结合的双目运算符，计算的返回值是左侧结构体中以右侧标识符命名的变量，比如:

<pre>
CGRect *rect;
rect.size.height = 1;
rect.size.width = rect.size.height;
</pre>

OC对这个运算符做了拓展，当左侧为一个对象时，该运算实质上等价于调用了类内`getter`或`setter`型的方法：

 * `getter`方法就是取值方法，它是一个只有返回值的无参方法。通常，我们要求这类方法的名称与它返回类内实例变量或属性的标识符相同。不过实际上，什么都可以= =

 * `setter`方法则是赋值方法，它是一个无返回值且拥有单一参数的方法。这类方法在命名时需要遵循规则，即大写预先定义好的标识符首字母，再加上一个set前缀。

当且仅当点语法处于`=`符号左边，即赋值语句时，我们会调用`setter`方法，除此之外，都是在调用`getter`方法。以下是声明示例：
<pre>
//getter
-(id)method;

//setter
-(void)setMethod:(id)sender;
</pre>

点语法的好处在于，我们可以以一种更为统一的表达方式去表示内部实例变量的存取，且让语句显得直观易读。OC为了代码的易读性刻意调整表达方式的小措施有很多，点语法也是其中一个。

不过，点语法作为一种便捷语法出现，虽然为类内实例变量的存取而生，但实际上并非只有在这种情况下才使用。在实际情况下，我们既可以重写`setter`与`getter`来实现额外的效果，更可以依靠以上描述的方法定义随意的使用点语法来调用方法。

更为离机的是，点语法是不分类方法(+)与实例方法的(-)。也就是说，其实我们可以这样生成一个对象：`NSObject *obj = NSObject.alloc.init`。

为了让整个语法显得更丧心病狂，笔者还特地准备了一段demo:

<pre>
@implementation BCObject

+(BCObject *)classMethod{
    return [BCObject new];
}

+(void)setClassMethod:(id)sender{
    BCObject.classMethod.method = sender;
}

-(id)method{
    return self;
}

-(void)setMethod:(id)sender{
    if ([sender isKindOfClass:[NSString class]]) {
        NSLog(@"%@",sender);
    }else{
        return;
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //实例方法的点语法
        BCObject *obj = [BCObject new];
        NSLog(@"%@",[obj.method class]);
        obj.method = @"Hello world.";
        //类方法的点语法
        id obj2 = BCObject.classMethod;
        NSLog(@"%@",[obj2 class]);
        BCObject.classMethod = @"Hello world, too.";
    }
    return 0;
}
/*输出结果
BCObject
Hello world.
BCObject
Hello world, too.
*/
@end	
</pre>

####**慎用点语法**####

如果再不加以声明的话，这就有点教坏小朋友的节奏了。点语法除了是属性存取的利器之外，也是混淆视听的好手，在debug与阅读源码的时候记得为每个点语法追根溯源，并不是每个点都意味着一个属性与实例的存在。

说到点语法，这里顺便为大家推荐一下[raywenderlich的OC编码风格建议][4]，里面会提到很多书写建议，帮助大家规范自己的代码。嗯，应该已经说的挺多了。


###内存管理

在[第二章 底层浅析——从二进制到对象][3]中，笔者曾简单的交待过OC中的内存管理机制——引用计数机制（Reference Counting）。这个机制的关键在于控制OC在初识化对象的时候就为我们生成的一个属性：`retainCount`。在以前的MRC时代，这个属性是可读的，你可以随时用该值来判断某个对象的内存状态。不过在ARC中，我们已经大大简化了管理方式，基本上，我们只需要面对或`strong`或`weak`的属性。或许在个别情况下还是会用到其他声明，笔者实力有限，就不细加列举了。

在ARC中，关于`strong`与`weak`，需要明确的规则只有两条。

 * 被`strong`指针指向的对象一定是存在的，当且仅当一个对象没有被任何`strong`型的指针指向时，它才会被释放。
 * 当你不确定指针指向的对象是否一直存在，或者你并不希望该对象一直存在时，就为这个指针声明`weak`。

第二条规则算是有的放矢，前半句为了防止访问不存在的变量，后半句则是防止循环引用（retain cycle）。
在OC中有一个很有用的机制，是一个weak属性并没有指向某个具体的对象时，系统会让该指针指向`nil`，而`nil`可以响应一切方法，响应的结果是什么事情也不会发生，没有报错，没有`crash`，当然因为是nil，方法里的一切代码也不会被执行。

简单解释一下循环引用，就是两个对象互相拥有一个指向对方的强指针，导致彼此都无法被释放，关于为什么可以参见上面的第一条规则。但在理论上，一切对象在最终都应该被释放，那么如何既让两个对象可以相互指向并进行调用，又能够互不影响的释放呢？对对对= =，当然是`weak`。

顺便说一说MRC，在MRC时代，内存管理机制更多依靠的是约定俗成。

 * 谁生成/持有，谁释放。真正意义上的`retainCount`修改操作方法只有两个，`retain`与`release`，一个+1，一个-1。通常在文献中还会把`autorelease`也与其并列，而其实，`autorelease`只是release的延时封装，用于处理某些不希望被立即释放的对象。这里的“谁”有两层意思，一层意思是进行生成/持有操作的指针应该与释放操作的指针相对应，否则的话，说不定会出现以下的代码：

<pre>
for(int i = 0 ; i < obj.retainCount ; i++){
	[obj release];
}//千万别这么写= =
</pre>

 而另一层意思相对隐晦些，是在说一个指针的释放时机与该指针的声明周期要相符合，也就是作用域。比如方法内的临时指针要在方法内释放，类内实例的释放则在析构函数`dealloc`里。每一次`retainCount`的+1都意味着一个指针会至少经历**出现**，**存在**，**释放**三个阶段，而每一句`release`都同时决定着**存在时长**与**不再存在**两件事，还请稍稍多体会些。

* 所有以alloc,copy,retain开头的方法都封装了`retain`操作，需要手动释放。而其他成对的生成/持有与释放成对存在的方法也可能存在类似性质，如`addSubview`与`removeFromSuperview`，务必成对引用。这类约定俗成往往需要编码者来完成，不要随意以以上开头写方法，不要在额外的方法里[self retain];，需成对使用的方法请在注释和文档里注明。

在MRC下面管理内存是一件比较繁琐与精细的事情，稍微一个马虎就可能引发程序奔溃或者内存不足。ARC的引入一定程度上也是在降低开发者的门槛，具体的使用就不再赘述了。

###类内实例

没有之前在底层实现上的铺垫，讲到这里往往需要花费很多时间。如果你之前接触过数据结构，会知道数据结构其实是包含着**逻辑结构**与**物理结构**（储存结构）的，且两者并不一定要统一。C语言的数组是为数不多逻辑结构与储存结构相同的数据结构之一，但是在实践中，让逻辑结构与物理结构统一并不是一件好事。比如一个C语言的数组中间所有值为0的位置即便再也用不到，只要数组还在，你就无法使用那些内存。

与这样的思路一脉相承，我们在构造类内实例的时候，其实只是构造了它们的逻辑结构，而在实际上，任何两个对象是不存在谁属于谁的。在物理存储上，他们的等级是完全平行的。唯一用以标记这种逻辑关系的，只不过是一个类内的指针而已。真正在物理上具有所属关系的，反倒是一个对象和这个对象内的指针。

与此相区别的是面向对象的继承机制，相对于类内实例的模拟来说。父类与子类的逻辑关系就严谨的多，从数据结构来说，它们类似于单向链表，即所有的子类都记录了自己的父类，但父类则不会记录自己的子类，而所有的继承遍历都严格按照这个结构自底向上。好吧，我们扯远了= =

对象间的关系都是两点一线的，两个独立的实例，一个从一点指向另一点的指针。因为是指向，所以具有方向性，被指向的指针永远不知道是谁指向自己，即便我们用两个指针相互指向，但站在对象的视角上，这一来一去，已然是两个不同的角色了。

最后补充一点可能模糊的地方，指针的指向，是为了调用，而调用，则是为了读写（或者存取？其实一个意思）。在类的内部，我们即可以使用实例的指针，也可以使用这个类的`setter`与`getter`来调用这个实例，比如一个`UIViewController`的`_view`和`self.view`是相同的效果，当然前提是你没有重写`_view`的`getter`。

而在类的外部，我们通常使用`setter`和`getter`来调用属性。当然，我们也可以使用`->`来调用`@public`声明的实例，不过，已经很少有人这么做了。

###代理与协议

通常来说，当我们讨论代理与协议的时候，都是将其归结在对模式的讨论中。作为实现回调的一种选择，这种模式大面积的出现在OC框架的各个地方。甚至为其设立了专门的语法标记，相比较而言，其它的模式都只是几个特定的类与方法而已。

不过，站在模式的角度上去讲代理与协议，就需要将不同的代码成分归结为模式里的各种模型。模式作为一个理论化模型，代码实现是多种多样的，即使在OC中已经为我们设计了理想的实现方案，可实际上，模式与代码实现是没有必然性的。

将模式具化在代码里，实质在于让代码实现该模式的各个特性。笔者初学模式的时候，遇到的总是讲一大堆代理/协议模式实现了什么功能，然后展示代码示例。感觉就像是有人向自己展示了一张拼图，然后把拼图倒给自己看一样。你TM在逗我？（好吧= =笔者又吐槽了。。。）引几位初学者的共同心声：“认识，见到知道是。会用，但是不懂，也不会写= =”

所以，在本章讨论里，对代理与协议，笔者打算去掉模式相关的概念。而模式相关的理解，请期待下一章:]

其实在上文中已经做了充分的铺垫，这里我们就具体一点说明问题：如何实现两个对象的相互调用？

说的更具体一点，现在我们假设有`ClassA`和`ClassB`两个类，每个类都有`methodA`和`methodB`两个方法，而我们要求`ClassA`调用`MethodA`时，`ClassB`也调用`methodA`，`ClassB`调用`MethodB`时亦然。

是不是被上面的A和B搞的有点蒙圈？我们来个形象点的比喻，我和你面对面站着，游戏规则是，我举起左手的时候你得举起左手，而你举起右手的时候我也得举起右手。

代码该怎么实现呢？其实很简单，两个类相互有一个指向对方的指针，在自己的方法实现里调用另一个实例的对应方法不是就可以了么？对了，据说如果两个对象相互都有一个`strong`的指针指向另一个对象，是会导致两个对象都无法被释放，引发引用循环的！所以，只要至少有一个指针是`weak`就可以了吧？对，答案就是这样= =

于是按照上面这段（坑爹的）描述，我们来写两个类好了，为了方便阅读，笔者依旧将声明和实现部分写在了同一个文件里，再次敬告，在自己写代码的时候，千万不要这样做= =！：

<pre>
@import Foundation;
//ClassB的前向引用申明，下章我们再说它 :]
@class ClassB;

//ClassA的声明部分
@interface ClassA : NSObject

/**
 *  weak型指针属性，指向一个ClassB类的对象
 */
@property (nonatomic,weak) ClassB *B;

-(void)methodA;

-(void)methodB;

@end

//ClassB的声明部分
@interface ClassB : NSObject

/**
 *  weak型指针属性，指向一个ClassA类的对象
 */
@property (nonatomic,weak) ClassA *A;

-(void)methodA;

-(void)methodB;

@end

//ClassA的实现部分
@implementation ClassA

-(void)methodA{
    NSLog(@"method A @Class A");
    [self.B methodA];
}

-(void)methodB{
    NSLog(@"method B @Class A");
}

@end

//ClassB的实现部分
@implementation ClassB

-(void)methodA{
    NSLog(@"method A @Class B");
}

-(void)methodB{
    NSLog(@"method B @Class B");
    [self.A methodB];
}

@end

//附上测试代码：

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //分别新建两个类的对象
        ClassA *A = [ClassA new];
        ClassB *B = [ClassB new];
        //让类内的指针指向另一个对象
        A.B = B;
        B.A = A;
        //分别调用含有调用另一个对象
        [A methodA];
        [B methodB];
    }
    return 0;
}

/*输出结果
method A @Class A
method A @Class B
method B @Class B
method B @Class A
*/
</pre>

上面这段代码是以两个`weak`型指针作为指向的对象相互调用，因为代码非常平行对应，虽然看着眼晕，但相信并不难理解。且让我们站在`ClassA`来看`ClassB`：

 * 一方面，我们在`methodA`中调用了`ClassB`的`methodA`方法，对于`ClassA`来说，这是一个正向调用。
 * 另一方面，我们的`methodB`会在`ClassB`调用自己的`methodB`时被调用，对于`ClassA`来说，这就是一个反向调用，或者，我们可以叫它回调。

 再者，代码示例中，我们的方法都是没有参数的。如果有参数呢？最神奇却又确实会发生的事情在于，当一个类被逆向调用的时候，该类可以获取到回调时的参数。而以上描述的情景，正是代理/协议模式的雏形。

 至于更具体的代理/协议的代码实现？我们下章见~

[1]: http://bifidy.net/index.php/307
[2]: https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html
[3]: http://bifidy.net/index.php/272
[4]: https://github.com/raywenderlich/objective-c-style-guide