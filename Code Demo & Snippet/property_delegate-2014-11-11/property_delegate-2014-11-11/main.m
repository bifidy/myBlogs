//
//  main.m
//  property_delegate-2014-11-11
//
//  Created by BifidyCAPs on 14/11/11.
//  Copyright (c) 2014年 BifidyCAPs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCObject.h"
#import "Class.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //--点语法--的代码调用示例
        //实例方法的点语法
        BCObject *obj = [BCObject new];
        NSLog(@"%@",[obj.method class]);
        obj.method = @"Hello world.";
        //类方法的点语法
        id obj2 = BCObject.classMethod;
        NSLog(@"%@",[obj2 class]);
        BCObject.classMethod = @"Hello world, too.";
        
        //--对象相互调用--的代码示例
        //分别新建两个类的对象
        ClassA *A = [ClassA new];
        ClassB *B = [ClassB new];
        //让类内的指针指向另一个对象
        A.B = B;
        B.A = A;
        //分别调用含有调用另一个对象
        [A methodA];
        [B methodB];
    }
    return 0;
}

