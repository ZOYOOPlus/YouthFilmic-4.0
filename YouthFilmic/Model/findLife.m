//
//  findLife.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/19.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "findLife.h"

@implementation findLife

- (id)init
{
    self = [super init];
    if (self)
    {
        [findLife mj_setupReplacedKeyFromPropertyName:^NSDictionary*{
            
            
            return @{
                     
                     @"ID":@"id"
                     };
        }];
        
    }
    return self;
    
}

@end
