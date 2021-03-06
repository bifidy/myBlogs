捆绑数组
该文章翻译自[objc.io的snippet][1]：[Flattening and mapping arrays][2]

在函数式编程中，数组的映射(`map`)是一个比较常见的操作。在一些特别的情况下，当映射结果是以数组为元素的数组时，他们需要被扁平化(`flatten`)。在许多函数式语言中，会为扁平化并映射定义一个操作符。这个操作符往往被称做`bind`（捆绑）。它会映射一个函数，并将该函数返回的数组扁平化为一个数组:

<pre lang = "swift">
infix operator >>= {}
func >>= < A, B > (xs: [A], f: A -> [B]) -> [B] {
    return xs.map(f).reduce([], combine: +)
}
</pre>

在结合多个列表时，使用这个操作会显得很酷。举个例子，我们假设我们有一个（扑克牌的）序数的列表，和一个花色的列表：

<pre lang = "swift">
let ranks = ["A", "K", "Q", "J", "10",
             "9", "8", "7", "6", "5", 
             "4", "3", "2"]
let suits = ["♠", "♥", "♦", "♣"]
</pre>

现在，通过列举所有的序数，并为每个序数结合所有可能的花色，我们可以生成一个包括了所有扑克牌的数组。

<pre lang="swift">
let allCards =  ranks >>= { rank in
    suits >>= { suit in [(rank, suit)] }
} 

// Prints: [(A, ♠), (A, ♥), (A, ♦), 
//          (A, ♣), (K, ♠), ...
</pre>

---

译者注：为方便理解，贴上该代码中未使用操作符的代码还原
<pre lang="swift">
let allCard = ranks.map(
    {rank in
        suits.map({suit in [(suit,rank)]}).reduce([], combine:+)
    }
).reduce([], combine: +)
</pre>
再简单的做两个名词解释：

 * 映射：将一个数组的每个元素按照一定方式转化成另外一个元素，然后按照原来的顺序排列组合为一个新的数组。新旧数组的对应元素存在统一的映射关系。    
 在swift中，数组可以使用其`map()`函数实现该操作，参数为一个映射函数或闭包。   
 * 扁平化：将多个数组的元素按照既定顺序合并在一个数组内，该顺序可以在扁平化时加以控制。  
  在swift中，数组可以使用`reduce( )`函数实现该操作，具体实现可参见上文代码或官方文档。（译者也是第一次看见，就不瞎说了）
  
[1]: http://www.objc.io/snippets/
[2]: http://www.objc.io/snippets/4.html
