//
//  Mesages.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/28.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "Mesages.h"

@implementation Mesages
- (id)init
{
    self = [super init];
    if (self)
    {
        [Mesages mj_setupReplacedKeyFromPropertyName:^NSDictionary*{
            
            
            return @{
                     
                     @"ID":@"id"
                     };
        }];
        
    }
    return self;
    
}

@end
