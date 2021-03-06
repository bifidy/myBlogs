该文章翻译自[objc.io的snippet][1]：[Function Composition][2]

在函数式编程中，我们常常希望将多个精简、独立的函数复合成为一个新的函数。举个例子，假设我们有三个函数，一个用来获得URL的内容，一个用来利用换行符将字符串分解为多个字符串，还有一个用来统计成员个数。我们可以将以上函数合并成一个新函数，用来计算一个URL当中的行数。

<pre lang="swift">func getContents(url: String) -> String {
    return NSString(contentsOfURL: NSURL(string: url), 
                    encoding: NSUTF8StringEncoding, error: nil)
}

func lines(input: String) -> [String] {
    return input.componentsSeparatedByCharactersInSet(
            NSCharacterSet.newlineCharacterSet())
}

let linesInURL = { url in countElements(lines(getContents(url))) }
linesInURL("http://www.objc.io") 
// Returns 731（译者注：经测试，返回值可能有出入，这里不是重点，以下类似）
</pre>

因为函数构造是一件很普遍的事情，所以在函数式编程中，可以为此定义一个本地的运算符：

<pre lang="swift">infix operator >>> { associativity left }
func >>> &lt;a , B, C>(f: B -> C, g: A -> B) -> A -> C {
    return { x in f(g(x)) }
}
</pre>

现在，我们可以去掉所有的圆括号嵌套，将上面的例子写成这样：

<pre lang="swift">let linesInURL2 = countElements >>> lines >>> getContents
linesInURL2("http://www.objc.io/books") 
// Returns 470
</pre>

 [1]: http://www.objc.io/snippets/
 [2]: http://www.objc.io/snippets/2.html