//
//  BaseViewController.h
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/13.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic, copy) void(^ onViewWillAppearHandler)();
+ (UIViewController *)presentingVC;
- (void)setLeftNaviButtonWithString:(NSString *)buttonTitle;
- (void)setRightNaviButtonWithString:(NSString *)buttonTitle;
- (void)setLeftNaviButtonWithImage:(UIImage *)buttonImage imageSize:(CGSize)imageSize;
- (void)setRightNaviButtonWithImage:(UIImage *)buttonImage imageSize:(CGSize)imageSize;
- (void)setBackNaviButton;
- (void)hideLeftNaviButton;

- (void)showLoading;
- (void)hideLoading;

- (void)showToast:(NSString *)message;
@end
