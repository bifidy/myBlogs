// Snippet for bifidy's blog
// 2014-10-23-data is invariable

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

//借位加法
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