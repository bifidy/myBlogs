函数式的快速排序
该文章翻译自[objc.io的snippet][1]：[Functional Quicksort][2]

以下版本的快速排序并不会真正意义上的提速。大部分真正意义上的快速排序，需要使用常数存储器（constant memory）来实现。不过，在快速排序的写法中，这个片段是一种最简单明了的一种：

<pre lang = "swift">
func qsort(input: [Int]) -> [Int] {
    if let (pivot, rest) = input.decompose {
        let lesser = rest.filter { $0 < pivot }
        let greater = rest.filter { $0 >= pivot }
        return qsort(lesser) + [pivot] + qsort(greater)
    } else {
        return []
    }
}
</pre>

以上代码基于之前的[decompose片段][3]([Decompose Arrays][4])：当数组不为空时，该函数将第一个元素当做中点，然后把数组分解为两个新数组：一个包括比中点元素小的元素，另一个包括更大（或相等）的元素。接下来，函数会先排序较小元素的数组，之后拼接中点元素，再拼接经过排序的较大元素数组。
> 译者注：该函数是递归函数，原作者只说明了函数过程。请注意递归过程中，仅当`input`为单元素数组时，会在停止递归调用的同时返回确定值。


 [1]: http://www.objc.io/snippets/
 [2]: http://www.objc.io/snippets/3.html
 [3]: http://bifidy.net/index.php/249
 [4]: http://www.objc.io/snippets/1.html