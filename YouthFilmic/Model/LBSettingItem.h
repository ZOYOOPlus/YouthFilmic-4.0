//
//  LBSettingItem.h
//  121mai
//
//  Created by 高刘备 on 16/3/5.
//  Copyright © 2016年 谷武科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LBSettingItem : NSObject


@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *subTitle;

// 用来保存每一行cell的功能
@property (nonatomic, strong) void(^itemOpertion)(NSIndexPath *indexPath);


+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title;

@end
