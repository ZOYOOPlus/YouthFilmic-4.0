//
//  UIView+Extension.h
//  121mai
//
//  Created by 高刘备 on 16/2/17.
//  Copyright © 2016年 谷武科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PureLayout/PureLayout.h>
@class GuwuLoadingView, EaseBlankPageView;

typedef NS_ENUM(NSInteger, EaseBlankPageType)
{
    /*
     到时候根据需要再改正
     */
    EaseBlankNodata = 0,
};


@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

#pragma mark LoadingView
@property (strong, nonatomic) GuwuLoadingView *loadingView;
- (void)beginLoading;
- (void)endLoading;

#pragma mark BlankPageView
@property (strong, nonatomic) EaseBlankPageView *blankPageView;
- (void)configBlankPage:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;

@end

@interface GuwuLoadingView : UIView
@property (strong,nonatomic) UIImageView *loopView,*monkeyView;
@property (assign, nonatomic, readonly) BOOL isLoading;
- (void)startAnimating;
- (void)stopAnimating;

@end

//数据加载失败的时候  没有数据的时候的处理逻辑
@interface EaseBlankPageView : UIView
@property (strong, nonatomic) UIImageView *monkeyView;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UIButton *reloadButton;
@property (copy, nonatomic) void(^reloadButtonBlock)(id sender);
- (void)configWithType:(EaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;
@end
