//
//  Activity.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/13.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "Activity.h"

@implementation Activity
- (id)init
{
    self = [super init];
    if (self)
    {
        [Activity mj_setupReplacedKeyFromPropertyName:^NSDictionary*{
            
            
            return @{
                     
                     @"actiId":@"id"
                     };
        }];
  
    }
    return self;
    
}

@end
