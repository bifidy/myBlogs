类型封装
该文章翻译自[objc.io的snippet][1]：[Wrapper Types][2]

有些时候你会希望将两种类型彼此区分开来。比如，如果你记录了用户账户（`account`）对应的信誉度（`credit`），你可以用一个函数来请求服务器返回该账户的信誉度：
（译者注：此处将`credit`翻译为“信誉度”，是猜测为之。）

<pre lang="swift">
func credits(account: Account) -> Int
</pre>

然而，当代码写的再深入些，你可能会看见一个 `Int` 类型，而你不知道它记录着信誉度的数值。所以，添加一个类型别名会很有帮助。你可以返回一个 `Credits`的值：

<pre lang="swift">
typealias Credits = Int
func credits(account: Account) -> Credits 
</pre>


做了以上工作之后，你就可以传递 `Credits` 类型的值了。这样做也很有助于阅读代码：你能够在看到 `Credits` 这个类型的瞬间明白它是什么。我们可以将这个工作再做的深入些：我们假设 `Credits` 类型来自于后台，而我们的客户端并没有代码会修改这个值。为了防止我们不小心将 `Credits` 类型的值当做一个 `Int` 去对待，我们可以将它封装为一个结构体。

<pre lang="swift">
struct Credits { let amount: Int }
</pre>

这样做的好处是，当你想做点什么，比如 `Credits(amount:0) + 1`，又或是在 `Credits`中添加两个值，编译器会给你一个警告。在一个新类型里封装一个简单的整数可以防止很多的失误。在你处理一些货币、物理单位或者其它的类似数据时，这种方法会很有用。你也可以封装其它的类型：这很多情况下，你可以封装一个字符串类型，然后将它应用在很多地方（译者注：比如一个不会被错误识别类型的常量字符串）。

[1]: http://www.objc.io/snippets/
[2]: http://www.objc.io/snippets/8.html
