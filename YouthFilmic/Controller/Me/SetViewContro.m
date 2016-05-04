//
//  SetViewContro.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/27.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "SetViewContro.h"
#import <YYImageCache.h>
#import "AppDelegate.h"
#import "BaseTabViewController.h"
@interface SetViewContro ()<UITableViewDelegate,UITableViewDataSource,UIApplicationDelegate>
@property (weak, nonatomic) IBOutlet UITableView *setTable;

@end

@implementation SetViewContro

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNaviButtonWithString:@"返回"];
    // Do any additional setup after loading the view from its nib.
}
- (void)tapNaviLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"清理缓存";
//        cell.detailTextLabel.text = [self cacthSize];
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"退出登录";
    }
    return cell;
    
}

- (NSString*)cacthSize
{
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    NSUInteger size = cache.diskCache.totalCount;
    NSLog(@">>>>%ld",size);
    NSUInteger Msize = size;
    NSString *stre = [NSString stringWithFormat:@"%ld",Msize];
    return stre;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
        
        
        // 清空磁盘缓存，带进度回调
        [cache.diskCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
            // progress
        } endBlock:^(BOOL error) {
            // end
            [self showToast:@"清除缓存成功"];
        }];
    }
    else
    {
        //            设置cookie
//        NSData * cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
         [[NetworkSingleton sharedManager]logoutsuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"退出登录%@",responseObject);
             NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
             NSHTTPCookie *cookie;
             NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
             for (cookie in [storage cookies])
             {
                 
                 NSLog(@"什么情况啊");
                 [storage deleteCookie:cookie];
             }
             
             [defaults setObject:nil forKey:@"outdate"];
             [HXTools setStringToUserDefaults:nil forKey:@"token"];
             [defaults synchronize];

             BaseTabViewController *base = [[BaseTabViewController alloc]init];
            [UIApplication sharedApplication].delegate
            .window.rootViewController = base;

        } failure:^(AFHTTPRequestOperation *operation, NSString *code) {
            [self showToast:@"退出登录失败"];
        }];
        
        
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
