//
//  RegistViewController.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/17.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#define kCellIdentifier_Input_OnlyText_Cell_Text @"Input_OnlyText_Cell_Text"
#define kCellIdentifier_Input_OnlyText_Cell_Password @"Input_OnlyText_Cell_Password"
#define kCellIdentifier_Input_OnlyText_Cell_PhoneCode_Prefix @"Input_OnlyText_Cell_PhoneCode"

#import "RegistViewController.h"
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
#import "XMGTopWindowViewController.h"
@interface RegistViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) TPKeyboardAvoidingTableView *myTableView;
@property (nonatomic,copy)NSString *global_key;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *password;
@property (nonatomic,copy)NSString *code;


@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNaviButtonWithImage:[UIImage imageNamed:@"photo_delete.png"] imageSize:CGSizeMake(25, 25)];
    [self setUpTableView];
    // Do any additional setup after loading the view from its nib.
}

 - (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [XMGTopWindowViewController sharedInstance].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [XMGTopWindowViewController sharedInstance].statusBarStyle = UIStatusBarStyleDefault;
    [super viewDidDisappear:animated];

}

- (void)tapNaviLeftButton:(id)sender
{
    //子类需自行实现此方法
    [self.navigationController popViewControllerAnimated:YES ];

}



- (void)setUpTableView
{
    _myTableView =  [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_myTableView registerClass:[LogViewViewCell class] forCellReuseIdentifier:kCellIdentifier_Input_OnlyText_Cell_Password];
    [_myTableView registerClass:[LogViewViewCell class] forCellReuseIdentifier:kCellIdentifier_Input_OnlyText_Cell_PhoneCode_Prefix];
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
- (void)setupNav
{
    
}

- (UIView *)customHeaderView
{
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.15*kScreen_Height)];
    headerV.backgroundColor = [UIColor clearColor];
    
    UIImageView *TrimageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"default-gravatar-pic.jpg"]];
    TrimageView.frame = CGRectMake((kScreen_Width/2- 33), 20, 67, 60);
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
    [logInBtn setTitle:@"注册" forState:UIControlStateNormal];
    [logInBtn setTintColor:[UIColor whiteColor]];
    logInBtn.backgroundColor = [UIColor colorWithRed:67/255.0 green:155/255.0 blue:247/255.0 alpha:1];
    [logInBtn addTarget:self action:@selector(logInclickB) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:logInBtn];
    // 1. 创建一个属性文本
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"已有账号？立即登录"];
    text.yy_font = [UIFont boldSystemFontOfSize:18];
    text.yy_lineSpacing = 2;
    YYLabel *label = [YYLabel new];
    label.frame = CGRectMake(kScreen_Width/2-90, CGRectGetMaxY(logInBtn.frame)+20, 180, 20);
    [text yy_setTextHighlightRange:NSMakeRange(5, 4)
                             color:[UIColor colorWithRed:67/255.0 green:155/255.0 blue:247/255.0 alpha:1]
                   backgroundColor:[UIColor grayColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                             [self dismissViewControllerAnimated:YES completion:^{
                                 
                             }];
                         }];
    label.attributedText = text;
    [footView addSubview:label];
    
   /* UILabel *labLi1 = [[UILabel alloc]initWithFrame:CGRectMake(kScreen_Width/2-97-15, kScreen_Height-196-0.15*kScreen_Height-42-50, 60, 1)];
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
    [footView addSubview:weChatLog];*/
    return footView;

}
- (void)logInclickB
{
    
     if (self.global_key.length == 0||self.phone.length == 0||self.code.length == 0)
    {
        [self showToast:@"信息输入不完整"];
        return;
    }
    
    if (![self.phone isPhoneNo]) {
        [self showToast:@"手机号码格式有误"];
        return;
    }
    if (self.password.length < 6)
    {
        [self showToast:@"密码长度至少为六位"];
        return;
        
    }
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.global_key,@"nick_name",self.phone,@"phone",self.password,@"password",self.code,@"code", nil];
    [[NetworkSingleton sharedManager]registUse:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSString *responseCode = dic[@"code"];
        if ([responseCode isEqualToString:@"100010"])
        {
            [self showToast:@"手机号已经被注册，请直接登录"];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];

        }
         else if ([responseCode isEqualToString:@"000010"])
        {
            [self showToast:@"手机验证码错误"];
 
        }
         else if ([responseCode isEqualToString:@"100008"])
         {
             [self showToast:@"注册成功"];
             [self dismissViewControllerAnimated:YES completion:^{
                 
             }];
             
         }

        
    } failure:^(AFHTTPRequestOperation *operation, NSString *code) {
        [self showToast:@"网络错误"];
    }];
    
    
    
    
}
#pragma mark TablevieDelegate TableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    if (indexPath.row == 2)
    {
        cellIdentifier = kCellIdentifier_Input_OnlyText_Cell_Password;
    }
    else if (indexPath.row == 3)
    {
        cellIdentifier = kCellIdentifier_Input_OnlyText_Cell_PhoneCode_Prefix;
    }
    else
    {
        cellIdentifier = kCellIdentifier_Input_OnlyText_Cell_Text;
    }
    LogViewViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;

    if (indexPath.row == 0)
    {
        [cell setPlaceholder:@" 用户名（个性后缀）" value:self.global_key];
        cell.textValueChangedBlock = ^(NSString *valueStr){
            weakSelf.global_key = valueStr;
        };
    }else if (indexPath.row == 1)
    {
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [cell setPlaceholder:@" 手机号" value:self.phone];
        cell.textValueChangedBlock = ^(NSString *valueStr){
            weakSelf.phone = valueStr;
        };
    }else if (indexPath.row == 2)
    {
        [cell setPlaceholder:@" 设置密码" value:self.password];
        cell.textValueChangedBlock = ^(NSString *valueStr){
            weakSelf.password = valueStr;
        };
    }else if (indexPath.row == 3)
    {
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [cell setPlaceholder:@" 手机验证码" value:self.code];
        cell.textValueChangedBlock = ^(NSString *valueStr){
            weakSelf.code = valueStr;
        };
        cell.phoneCodeBtnClckedBlock = ^(PhoneCodeButton *btn){
            [weakSelf phoneCodeBtnClicked:btn];
        };
    }
 
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    return cell;


}
- (void)phoneCodeBtnClicked:(PhoneCodeButton *)sender{
    if (![self.phone isPhoneNo]) {
        [self showToast:@"手机号码格式有误"];
         return;
    }
    sender.enabled = NO;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.phone,@"phone",@"1" ,@"type",nil];
    [[NetworkSingleton sharedManager]getPhoneCode:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary*)responseObject;
        NSString *resCode = dic[@"code"];
        if ([resCode isEqualToString:@"000008"])
        {
            [self showToast:@"手机验证码发送次数过多"];
        }
        else if ([resCode isEqualToString:@"000009"])
        {
            [self showToast:@"验证码发送成功"];
            [sender startUpTimer];
 
        }
 

    } failure:^(AFHTTPRequestOperation *operation) {
        [self showToast:@"网络错误"];

        [sender invalidateTimer];
        

    }];
   /* [[Coding_NetAPIManager sharedManager] request_GeneratePhoneCodeWithPhone:_myRegister.phone type:PurposeToRegister block:^(id data, NSError *error) {
        if (data) {
            [NSObject showHudTipStr:@"验证码发送成功"];
            [sender startUpTimer];
        }else{
            [sender invalidateTimer];
        }
    }];*/
}



@end
