//  Class.h
//  property_delegate-2014-11-11


@import Foundation;
//ClassB的前向引用申明，下章我们再说它 :]
@class ClassB;

//ClassA的声明部分
@interface ClassA : NSObject

/**
 *  weak型指针属性，指向一个ClassB类的对象
 */
@property (nonatomic,weak) ClassB *B;

-(void)methodA;

-(void)methodB;

@end

//ClassB的声明部分
@interface ClassB : NSObject

/**
 *  weak型指针属性，指向一个ClassA类的对象
 */
@property (nonatomic,weak) ClassA *A;

-(void)methodA;

-(void)methodB;

@end

//ClassA的实现部分
@implementation ClassA

-(void)methodA{
    NSLog(@"method A @Class A");
    [self.B methodA];
}

-(void)methodB{
    NSLog(@"method B @Class A");
}

@end

//ClassB的实现部分
@implementation ClassB

-(void)methodA{
    NSLog(@"method A @Class B");
}

-(void)methodB{
    NSLog(@"method B @Class B");
    [self.A methodB];
}

@end