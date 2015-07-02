可选值映射

该文章翻译自[objc.io的snippet][1]：[Map for Optionals][2]



我们已经在[之前的小贴士][map]中聊过 `map` 函数了。如果你还不是很熟悉，映射表示利用一个转化函数，应用在数组的每一个元素上，生成一个新的数组。比如：

<pre lang="swift">
let urls: [NSURL] = [ /* a bunch of image URLs */ ]
let images: [NSImage?] = urls.map { NSImage(contentsOfURL: $0) }
</pre>

不过，映射并不是只能被应用在数组上。在更具体的环境下，映射可以简单的从某个容器类型中提取其值，在应用了这个转换后，再把它封装起来。比如，我们可以为可选值做一个映射的定义（这个功能标准库中已经提供，不过你自己也可以简单的完成）：

<pre lang="swift">
func map < A, B >(x: A?, f: A -> B) -> B? {
    if let x1 = x {
        return f(x1)
    }
    return nil
}
</pre>

我们希望将一个 `URL` 可选值转化为一个 `NSImage` 可选值，情况与上述的数组类似。一种选择是利用 Swift 的可选值捆绑（`binding`）：

<pre lang="swift">
let url: NSURL? = NSURL(string: "image.jpg")
var image: NSImage?
if let url1 = url {
    image = NSImage(contentsOfURL:url1)
}
</pre>

通过映射，我们可以更简单的解决它：

<pre lang="swift">
let url: NSURL? = NSURL(string: "image.jpg")
let image = map(url) { NSImage(contentsOfURL: $0) }
</pre>

映射可以定义在很多类型上，包括字典，元组，函数和你自己定义的类型。

>译者注：本篇的讲解略少，代码略多。重点在于 `map` 函数同时实现了可选值取值与转化。用类似于映射的思路简化了可选值的取值方式。

[1]: http://www.objc.io/snippets/
[2]: http://www.objc.io/snippets/9.html
[map]:http://bifidy.net/index.php/280