//
//  LBSettingItem.m
//  121mai
//
//  Created by 高刘备 on 16/3/5.
//  Copyright © 2016年 谷武科技. All rights reserved.
//

#import "LBSettingItem.h"

@implementation LBSettingItem

+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title
{
    LBSettingItem *item = [[self alloc] init];
    
    item.image = image;
    item.title = title;
    
    return item;
}

@end
