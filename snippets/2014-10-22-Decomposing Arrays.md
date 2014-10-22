分解数组

该文章翻译自[objc.io的snippet][1]：[Decomposing Arrays][2]


以下的代码片段能够将一个数组分解为一个单独元素，与一个由剩余元素组成的数组。如果输入数组为空，则返回`nil`。

<pre lang = "swift">
extension Array {
    var decompose : (head: T, tail: [T])? {
        return (count > 0) ? (self[0], Array(self[1.. < count])) : nil 
    }
}
</pre>

这种编写方式在搭配使用`if let` 表达式或者模式匹配（pattern matching）时，显得非常有用。举个例子，以下是一个求和的递归方法：

<pre lang = "swift">
func sum(xs: [Int]) -> Int {
    if let (head, tail) = xs.decompose {
        return head + sum(tail) 
    } else {
        return 0 
    }
}
</pre>

你可以很轻松的为其他类型定义属于你自己的分解函数，比如字典或字符串。

 [1]: http://www.objc.io/snippets/
 [2]: http://www.objc.io/snippets/1.html