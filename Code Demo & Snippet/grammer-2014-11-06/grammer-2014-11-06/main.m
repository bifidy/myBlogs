//
//  main.m
//  grammer-2014-11-06
//
//  Created by BifidyCAPs on 14/11/6.
//  Copyright (c) 2014年 BifidyCAPs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCObject.h"
int var;//变量声明，格式为 “数据类型 标识符;"
int func(int);//函数声明，格式为“数据类型 标识符(数据类型,...);”
int func(int x){//函数实现，格式为“数据类型 标识符(数据类型 形参标识符,...){ ... return ...}”
    var = x; //变量赋值，利用赋值运算符“=”
    printf("%d",var); //变量调用，直接使用变量的标识符
    return x?func(x-1):0;//函数调用，格式为“函数名标识符(传入参数)”
}

//调用和测试在这里，你可以直接Run，如果代码有问题，请与我联系，愿我能尽早解决 :]
int main(int argc, const char * argv[]) {
    func(5);
    @autoreleasepool {
        say([BCObject hello]);
        BCObject *obj = [BCObject new];
        say(obj -> hello);
        say(obj.bye);
        obj.word = obj -> hello;
        say(obj.word);
    return 0;
}
}


