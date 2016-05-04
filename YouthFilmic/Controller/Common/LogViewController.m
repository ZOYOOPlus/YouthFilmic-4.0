//
//  LogViewController.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/17.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//
#define kCellIdentifier_Input_OnlyText_Cell_Text @"Input_OnlyText_Cell_Text"
#define kCellIdentifier_Input_OnlyText_Cell_Password @"Input_OnlyText_Cell_Password"
#define kCellIdentifier_Input_OnlyText_Cell_PhoneCode_Prefix @"Input_OnlyText_Cell_PhoneCode"

#import "LogViewController.h"
#import "LogViewViewCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "Masonry.h"
#import "NSString+expand.h"
#import "UITableView+Common.h"
#import <YYText/YYText.h>
#import "UIColor+expanded.h"
#import "UITapImageView.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "RegistViewController.h"
#import "FindPassViewController.h"
#import "XMGTopWindowViewController.h"
@interface LogViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) TPKeyboardAvoidingTableView *myTableView;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *password;

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
    [XMGTopWindowViewController sharedInstance].statusBarStyle =UIStatusBarStyleDefault;
     [self setUpTableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logInNoti:) name:@"LoginSucsess" object:nil];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"WYopenid"];
    [[NSUserDefaults standardUserDefaults]synchronize];


}

- (void)logInNoti:(NSNotification*)noti
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [XMGTopWindowViewController sharedInstance].statusBarStyle =UIStatusBarStyleLightContent;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewWillDisappear:animated];
}
- (void)tapNaviLeftButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setUpTableView
{
    _myTableView =  [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_myTableView registerClass:[LogViewViewCell class] forCellReuseIdentifier:kCellIdentifier_Input_OnlyText_Cell_Password];
    [_myTableView registerClass:[LogViewViewCell class] forCellReuseIdentifier:kCellIdentifier_Input_OnlyText_Cell_Text];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.myTableView.tableHeaderView = [self customHeaderView];
    self.myTableView.tableFooterView=[self customFooterView];
    [self.view addSubview:self.myTableView];
    
    
}
- (UIView *)customHeaderView
{
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.20*kScreen_Height)];
    headerV.backgroundColor = [UIColor clearColor];
    
    UIImageView *TrimageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    TrimageView.frame = CGRectMake((kScreen_Width/2- 0.1*kScreen_Height), 0.05*kScreen_Height, 0.2*kScreen_Height, 0.15*kScreen_Height);
    [headerV addSubview:TrimageView];
    
    UIButton *disMissBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [disMissBtn setBackgroundImage:[UIImage imageNamed:@"photo_delete.png"] forState:UIControlStateNormal];
    [disMissBtn addTarget:self action:@selector(dismissClickG) forControlEvents:UIControlEventTouchUpInside];
//    disMissBtn.backgroundColor = [UIColor yellowColor];
    disMissBtn.frame = CGRectMake(10, 20, 30, 30);
    [headerV addSubview:disMissBtn];
    return headerV;
}
- (void)dismissClickG
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (UIView *)customFooterView
{
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-196-0.15*kScreen_Height)];
    UIButton *logInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logInBtn.frame = CGRectMake(10, 20, kScreen_Width-20, 44);
    [logInBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [logInBtn setTintColor:[UIColor whiteColor]];
    logInBtn.backgroundColor = [UIColor colorWithRed:67/255.0 green:155/255.0 blue:247/255.0 alpha:1];
     [logInBtn addTarget:self action:@selector(logInclickB) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:logInBtn];
    // 1. 创建一个属性文本
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"没有账号？立即注册"];
    text.yy_font = [UIFont boldSystemFontOfSize:14];
    text.yy_lineSpacing = 2;
    YYLabel *label = [YYLabel new];
    label.frame = CGRectMake(10, CGRectGetMaxY(logInBtn.frame)+20, 140, 20);
    [text yy_setTextHighlightRange:NSMakeRange(5, 4)
                             color:[UIColor colorWithRed:67/255.0 green:155/255.0 blue:247/255.0 alpha:1]
                   backgroundColor:[UIColor grayColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                             RegistViewController *registViewCon = [[RegistViewController alloc]init];
//                             [self.navigationController pushViewController:registViewCon animated:YES];
                             [self presentViewController:registViewCon animated:YES completion:^{
                                 
                             }];
                             
                         }];
    label.attributedText = text;
    [footView addSubview:label];
//    忘记密码
    NSMutableAttributedString *foreGetText = [[NSMutableAttributedString alloc] initWithString:@"忘记密码？"];
    foreGetText.yy_font = [UIFont boldSystemFontOfSize:14];
    foreGetText.yy_lineSpacing = 2;
    YYLabel *Forelabel = [YYLabel new];
    Forelabel.frame = CGRectMake(kScreen_Width-75, CGRectGetMaxY(logInBtn.frame)+20, 75, 20);
    [foreGetText yy_setTextHighlightRange:NSMakeRange(0, 5)
                             color:[UIColor colorWithRed:67/255.0 green:155/255.0 blue:247/255.0 alpha:1]
                   backgroundColor:[UIColor grayColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
            FindPassViewController *findPass = [[FindPassViewController alloc]init];
                             [self presentViewController:findPass animated:YES completion:^{
                                 
                             }];
                             
                             
                         }];
    Forelabel.attributedText = foreGetText;
    [footView addSubview:Forelabel];
    
    
    UILabel *labLi1 = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width/2-97-15, kScreen_Height-196-0.15*kScreen_Height-42-50, 60, 1)];
    labLi1.backgroundColor = [UIColor darkGrayColor];
    [footView addSubview:labLi1];
    
    UILabel *labLi2 = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width/2+37+15, kScreen_Height-196-0.15*kScreen_Height-42-50, 60, 1)];
    
    UILabel *latBrl = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width/2-38, kScreen_Height-196-0.15*kScreen_Height-50-50, 75, 20)];
    latBrl.text= @"第三方登陆";
    latBrl.font = [UIFont systemFontOfSize:15];
    [footView addSubview:latBrl];
    labLi2.backgroundColor = [UIColor darkGrayColor];
    [footView addSubview:labLi2];
    UITapImageView *weChatLog = [[UITapImageView alloc]init];
    weChatLog.image = [UIImage imageNamed:@"weixin.png"];
    weChatLog.frame = CGRectMake(kScreen_Width/2-22, kScreen_Height-196-0.15*kScreen_Height-66, 44, 33);
    [weChatLog addTapBlock:^(id obj) {
        
        if ([WXApi isWXAppInstalled])
        {
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"App";
            [WXApi sendReq:req];
            
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:actionConfirm];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }];
    [footView addSubview:weChatLog];
    return footView;
    
}
- (void)logInclickB
{
    if (![self.phone isPhoneNo])
    {
        [self showToast:@"手机号码格式错误"];
        return;
    }
    if (self.password.length <1)
    {
        [self showToast:@"密码错误或没有输入密码"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.phone,@"phone",self.password,@"password", nil];
    
    [[NetworkSingleton sharedManager]phoneLogin:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = (NSDictionary*)responseObject;
        if ([dic[@"code"]isEqualToString:@"100002"])
        {
            [self showToast:@"账号或密码错误"];
            return ;
        }
        else if ([dic[@"code"]isEqualToString:@"100001"])
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [NSDate date];
            NSString *saboxDate = [dateFormatter stringFromDate:date];
            [[NSUserDefaults standardUserDefaults]setObject:saboxDate forKey:@"outdate"];
            [[NSUserDefaults standardUserDefaults]synchronize];

            
            NSDictionary * dataDic = dic[@"data"];
            NSString *token = dataDic[@"token"];
            NSNumber *userId = dataDic[@"user_id"];
            NSNumberFormatter *forematter = [[NSNumberFormatter alloc]init];
            NSString *strUserId =[forematter stringFromNumber:userId];
            //            把用户的唯一标识存本地
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"WYopenid"])
            {
                NSString *strU = [[NSUserDefaults standardUserDefaults]objectForKey:@"WYopenid"];
                if ([strUserId isEqualToString:strU])
                {
                [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"ishuan"];
     
                }
                else
                {
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"ishuan"];
 
                }
                
            }
            else
            {
                
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:strUserId forKey:@"WYopenid"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            

            
            
             [[User sharedInstance]setSanBoxToken:token];
            
//            设置cookie
            NSData * cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject: cookiesData forKey:@"kCookie"];
            [defaults synchronize];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginSucsess" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginSucsess" object:nil userInfo:nil];
            
            

            [self dismissViewControllerAnimated:YES completion:^{
                
            }];

        }
        
    } failure:^(AFHTTPRequestOperation *operation) {
        [self showToast:@"网络错误"];
    }];
    
    
}
#pragma mark TablevieDelegate TableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    if (indexPath.row == 0)
    {
    cellIdentifier = kCellIdentifier_Input_OnlyText_Cell_Text;

    }
    else
    {
    cellIdentifier = kCellIdentifier_Input_OnlyText_Cell_Password;

    }
    LogViewViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    
if (indexPath.row == 0)
    {
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [cell setPlaceholder:@"手机号" value:self.phone];
        cell.textValueChangedBlock = ^(NSString *valueStr){
            weakSelf.phone = valueStr;
        
    };
    }
else
    {
        [cell setPlaceholder:@"密码" value:self.password];
        cell.textValueChangedBlock = ^(NSString *valueStr){
            weakSelf.password = valueStr;
        };
    }
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    return cell;
    
    
}
- (void)phoneCodeBtnClicked:(PhoneCodeButton *)sender{
    if (![self.password isPhoneNo]) {
        [self showToast:@"手机号码格式有误"];
        return;
    }
    sender.enabled = NO;
    /* [[Coding_NetAPIManager sharedManager] request_GeneratePhoneCodeWithPhone:_myRegister.phone type:PurposeToRegister block:^(id data, NSError *error) {
     if (data) {
     [NSObject showHudTipStr:@"验证码发送成功"];
     [sender startUpTimer];
     }else{
     [sender invalidateTimer];
     }
     }];*/
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
