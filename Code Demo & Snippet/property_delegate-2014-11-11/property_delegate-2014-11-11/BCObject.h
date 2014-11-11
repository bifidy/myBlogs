//
//  BCObject.h
//  property_delegate-2014-11-11
//
//  Created by BifidyCAPs on 14/11/11.
//  Copyright (c) 2014年 BifidyCAPs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCObject : NSObject


//getter
-(id)method;

//setter
-(void)setMethod:(id)sender;

//class getter
+(BCObject *)classMethod;

//class setter
+(void)setClassMethod:(id)sender;

@end
