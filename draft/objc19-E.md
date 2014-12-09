Welcome to objc.io issue 19: all about debugging.

We’re all making mistakes, all the time. As such, debugging is a core part of what we do every day, and we’ve all developed debugging habits — our own way of approaching the all-too-common situation where something is not working as it should.

But there’s always more to learn about debugging. Do you use LLDB to its full potential? Have you disassembled framework code to glance under the covers? Have you ever used the DTrace framework? Do you know about Apple’s new activity tracing APIs? We’re going to take a look at these topics and more in this issue.

Peter starts off with a debugging case study: he walks us through the workflow and the tools he used to track down a regression bug in UIKit, from first report to filed radar. Next, Ari shows us the power of LLDB, and how you can leverage it to make debugging less cumbersome. Chris writes about his debugging checklist, a list of the many things to consider when diagnosing bugs. Last but not least, Daniel and Florian talk about two powerful but relatively unknown debugging technologies: DTrace and Activity Tracing.

We’d love for you to never need all of this — but since that’s not going to happen, we at least hope you’ll enjoy these articles! :-)

Best from a wintry Berlin,

Chris, Daniel, and Florian.

欢迎来到objc.io的第19期：本期的内容是调试。

我们在任何情况下都会犯错误。以此想来，我们每个工作日的核心部分都该是调试。而且，总会有代码不按照预定方式去工作的情况发生，这些情况又往往太过相似，我们以自己的方式去寻找这些代码的过程，已经演变成了我们调试的习惯。

不过关于调试， 总是有更多东西可学。你是否已经发挥出LLDB所有的潜力了？你是否已经吃透了框架代码并且窥见了底层？你可曾用过DTrace框架？苹果新发布的动态追踪API你又了解多少?在本期内容中，我们详尽探讨以上的命题，只多不少。

Peter会以一个调试用例的研究作为开始：他在第一篇文章中为我们带来的是，他在捕捉到某个UIKit循环引用错误时的工作流程与工具。接下来，Ari会向我们展示LLDB的力量，你可以利用它，使调试不那么麻烦。Chris写的内容基于他的调试核对清单。这份清单列出了许多值得被关注的内容，你可以利用它们来诊断bug。结尾处，Daniel和Florian会讲解两个强大但是名不见经传的调试工具，DTrace和Activity Tracing 。

我们希望你永远用不到这些内容。但人生不如意十之八九，仅愿你可以享受这些文章！:-)

来自柏林深冬的美好祝福，

Chris，Daniel，与 Florian。