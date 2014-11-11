//
//  BCObject.m
//  property_delegate-2014-11-11
//
//  Created by BifidyCAPs on 14/11/11.
//  Copyright (c) 2014年 BifidyCAPs. All rights reserved.
//

#import "BCObject.h"

@implementation BCObject

+(BCObject *)classMethod{
    return [BCObject new];
}

+(void)setClassMethod:(id)sender{
    BCObject.classMethod.method = sender;
}

-(id)method{
    return self;
}

-(void)setMethod:(id)sender{
    if ([sender isKindOfClass:[NSString class]]) {
        NSLog(@"%@",sender);
    }else{
        return;
    }
}

@end
