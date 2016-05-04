//
//  BaseTabViewController.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/13.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "BaseTabViewController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "LifeViewController.h"
#import "MeViewController.h"
#import "MessegeController.h"
@interface BaseTabViewController ()

@end

@implementation BaseTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBar.translucent = YES;
    [self setupViewControllers];
    
}

- (void)setupViewControllers
{
    NSMutableArray *viewControllers = [NSMutableArray array];
    NSArray *titleAry = @[@"首页",@"发现",@"消息",@"我的"];
    NSArray *classAry = @[@"HomeViewController",@"LifeViewController",@"MessegeController",@"MeViewController"];
    for (int i= 0; i<4; i++)
    {
       BaseNavigationController*nav =[self class:classAry[i] imageName:[NSString stringWithFormat:@"icon_tab%d_normal.png",i+1] selectedImageNae:[NSString stringWithFormat:@"icon_tab%d_press.png",i+1] tit:titleAry[i]];
        [viewControllers addObject:nav];
    }
    [self setViewControllers:viewControllers];
}
- (BaseNavigationController*)class:(NSString*)clas imageName:(NSString*)imge selectedImageNae:(NSString*)seleImage tit:(NSString*)title
{
    UITabBarItem *ret;
    Class viewControl = NSClassFromString(clas);
    UIViewController *realViewController = [[viewControl alloc]init];

    ret=[ realViewController.tabBarItem initWithTitle:title image:[UIImage imageNamed:imge] selectedImage:[UIImage imageNamed:seleImage]];
    BaseNavigationController*nav = [[BaseNavigationController alloc]initWithRootViewController:realViewController];
    return nav;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
