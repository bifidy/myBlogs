//
//  BCObject.h
//  grammer-2014-11-06
//
//  Created by BifidyCAPs on 14/11/6.
//  Copyright (c) 2014年 BifidyCAPs. All rights reserved.
//
@import Foundation;
@interface BCObject : NSObject{
    @public
    NSString *hello;
    @private
    NSString *bye;
}
@property NSString *word;
@end

@implementation BCObject
-(instancetype)init{
    self = [super init];
    if(self){
        hello = @"hello";
        bye = @"bye";
    }
    return self;
}
+(NSString *)hello{
    return @"hello world";
}

-(NSString *)bye{
    return bye;
}
@end

void say(NSString *str){
    NSLog(@"%@",str);
}
