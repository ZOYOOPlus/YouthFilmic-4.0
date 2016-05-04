//
//  LBsetingGrop.m
//  121mai
//
//  Created by 高刘备 on 16/3/5.
//  Copyright © 2016年 谷武科技. All rights reserved.
//

#import "LBsetingGrop.h"

@implementation LBsetingGrop
+ (instancetype)groupWithItems:(NSArray *)items
{
    LBsetingGrop *group = [[self alloc] init];
    
    group.items = items;
    
    return group;
}

@end
