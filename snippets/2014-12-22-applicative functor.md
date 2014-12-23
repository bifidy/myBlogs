该文章翻译自[objc.io的snippet][1]：[Applicative Functors][2]
（译者注：Applicative Functors 是函数式编程的一个概念，笔者无能，未查到合适的翻译。相关知识可以通过文末的链接做一些了解。）

在[上周的小贴士][snippet6]中，我们使用了下面的 `login` 函数：

<pre lang = "swift">
func login(email: String, pw: String, success: Bool -> ())
</pre>

很多情况下，传入 `login` 函数的字符串会是一个可选值。于是，你需要写一些类似下面例子的代码：

<pre lang="swift">
if let email = getEmail() {
    if let pw = getPw() {
        login(email, pw) { println("success: \($0)") }
    } else {
        // error...
    }
} else {
    // error...
}
</pre>

在这里介绍另一个解决办法：我们可以利用一个事实，Swift 中的可选值实际是一个 applicative functor 的实例。是的，那听起来令人困惑且疯狂，但不用担心，我们会写一个简单的例子。我们可以按照 applicative functor 的方式定义一个运算符来简化可选值的操作：

<pre lang="swift">

infix operator <*> { associativity left precedence 150 }
func <*><A, B>(lhs: (A -> B)?, rhs: A?) -> B? {
    if let lhs1 = lhs {
        if let rhs1 = rhs {
            return lhs1(rhs1)
        }
    }
    return nil
}

</pre>

简单来说，如果左侧的参数 `lhs` 中的参数均不为 nil 时，这个操作符会应用右侧参数 `rhs` 中的运算过程。同时使用这个操作数和[上周的柯里化函数][snippet6]，我们就可以写出如下的代码：

<pre lang="swift">
if let f = curry(login) <*> getEmail() <*> getPw() {
    f { println("success \($0)") }
} else {
    // error...
}
</pre>

这样写起来更好些，你觉得呢？诚然，这种方法看起来有点陌生，不过就锻炼发散与创造性的思维而言，这却是一个难得的机会。

>译者：关于理解 applicative functor，或许能帮到你的一些文献（惭愧，译者其实看不懂= =）：
[heskell.org:Applicative functor](https://www.haskell.org/haskellwiki/Applicative_functor)  
[Functor, Applicative, 以及 Monad 的图片阐释](http://jiyinyiyong.github.io/monads-in-pictures/)

[1]: http://www.objc.io/snippets/
[2]: http://www.objc.io/snippets/7.html
[snippet6]:http://bifidy.net/index.php/343
