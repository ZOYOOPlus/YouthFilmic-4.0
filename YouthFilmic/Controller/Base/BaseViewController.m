//
//  BaseViewController.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/13.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTabViewController.h"
@interface BaseViewController ()
{
    UIBarButtonItem *_naviLeftBtn;
    UIBarButtonItem *_naviRightBtn;
    MBProgressHUD *_HUD;
    BOOL _showLoading;
    NSDate *_entryTime;
    

}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_onViewWillAppearHandler)
    {
        _onViewWillAppearHandler();
    }
}


- (void)setLeftNaviButtonWithString:(NSString *)buttonTitle
{
    
    if (!_naviLeftBtn)
    {
        _naviLeftBtn = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStyleDone target:self action:@selector(tapNaviLeftButton:)];
        [self.navigationItem setLeftBarButtonItem:_naviLeftBtn];
    }
    else
    {
        _naviLeftBtn.title = buttonTitle;
    }
    
    
}
- (void)setRightNaviButtonWithString:(NSString *)buttonTitle
{
    if (!_naviRightBtn)
    {
        _naviRightBtn = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStyleDone target:self action:@selector(tapNaviRightButton:)];
        [self.navigationItem setRightBarButtonItem:_naviRightBtn];
    }
    else
    {
        _naviRightBtn.title = buttonTitle;
    }
    
    
}

- (void)setLeftNaviButtonWithImage:(UIImage *)buttonImage imageSize:(CGSize)imageSize
{
    [self.navigationItem hidesBackButton];
    UIButton *button = [[UIButton alloc] init];
    [button setFrame:CGRectMake(0, (44 - imageSize.height) / 2, imageSize.width, imageSize.height)];
    
    [button addTarget:self action:@selector(tapNaviLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    
}

- (void)setRightNaviButtonWithImage:(UIImage *)buttonImage imageSize:(CGSize)imageSize
{
    [self.navigationItem hidesBackButton];
    UIButton *button = [[UIButton alloc] init];
    [button setFrame:CGRectMake(0, (44 - imageSize.height) / 2, imageSize.width, imageSize.height)];
    
    [button addTarget:self action:@selector(tapNaviRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
}
+ (UIViewController *)presentingVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[BaseTabViewController class]]) {
        result = [(BaseTabViewController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

- (void)setBackNaviButton
{
    [self.navigationItem hidesBackButton];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    [button addTarget:self action:@selector(tapNaviBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"nav_back_btn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
}

- (void)hideLeftNaviButton
{
    [self.navigationItem hidesBackButton];
}


- (void)tapNaviBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tapNaviLeftButton:(id)sender
{
    //子类需自行实现此方法
}

- (void)tapNaviRightButton:(id)sender
{
    //子类需自行实现此方法
}

- (void)showLoading
{
    if (!_showLoading)
    {
        [_HUD show:YES];
        _showLoading = YES;
    }
    
}


- (void)hideLoading
{
    _showLoading = NO;
    [_HUD hide:YES];
    
    
}


#pragma mark - Toast
- (void)showToast:(NSString *)message
{
    [self.view makeToast:message duration:2.0f position:[NSValue valueWithCGPoint:self.view.center]];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



@end
