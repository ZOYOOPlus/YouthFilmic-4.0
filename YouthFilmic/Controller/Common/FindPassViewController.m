//
//  FindPassViewController.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/17.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//
#define kCellIdentifier_Input_OnlyText_Cell_Text @"Input_OnlyText_Cell_Text"
#define kCellIdentifier_Input_OnlyText_Cell_Password @"Input_OnlyText_Cell_Password"
#define kCellIdentifier_Input_OnlyText_Cell_PhoneCode_Prefix @"Input_OnlyText_Cell_PhoneCode"

#import "FindPassViewController.h"
#import "NSString+expand.h"
#import "UITableView+Common.h"
#import <YYText/YYText.h>
#import "UIColor+expanded.h"
#import "UITapImageView.h"
#import "LogViewViewCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "Masonry.h"
@interface FindPassViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *password;
@property (nonatomic,copy)NSString *code;
@property (strong, nonatomic) TPKeyboardAvoidingTableView *myTableView;

@end

@implementation FindPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"找回密码";
    [self setUpTableView];

    // Do any additional setup after loading the view from its nib.
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

    UIView *heView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 70)];
    self.myTableView.tableHeaderView = heView;
    self.myTableView.tableFooterView=[self customFooterView];
    [self.view addSubview:self.myTableView];
    
    
    
    
}
- (UIView *)customFooterView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 100)];
    UIButton *resetPass = [UIButton buttonWithType:UIButtonTypeCustom];
    resetPass.frame = CGRectMake(10, 25, kScreen_Width-20, 44);
    [resetPass setTitle:@"重置密码" forState:UIControlStateNormal];
    [resetPass setTintColor:[UIColor whiteColor]];
    resetPass.backgroundColor = [UIColor colorWithRed:67/255.0 green:155/255.0 blue:247/255.0 alpha:1];
    [resetPass addTarget:self action:@selector(resetPassWordClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:resetPass];
    return footView;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TablevieDelegate TableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    if (indexPath.row == 1)
    {
        cellIdentifier = kCellIdentifier_Input_OnlyText_Cell_Password;
    }
    else if (indexPath.row == 2)
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
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [cell setPlaceholder:@" 手机号" value:self.phone];
        cell.textValueChangedBlock = ^(NSString *valueStr){
            weakSelf.phone = valueStr;
        };
    }else if (indexPath.row == 1)
    {
        [cell setPlaceholder:@" 新密码" value:self.password];
        cell.textValueChangedBlock = ^(NSString *valueStr){
            weakSelf.password = valueStr;
        };
    }else if (indexPath.row == 2)
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
}
- (void)resetPassWordClick
{
    if (![self.phone isPhoneNo]) {
        [self showToast:@"手机号码格式有误"];
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.phone,@"phone",self.password,@"password",self.code,@"code", nil];
    [[NetworkSingleton sharedManager]updatePasswoed:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        NSLog(@"%@",responseObject);
        NSDictionary *dic = (NSDictionary*)responseObject;
        NSString *resCode = dic[@"code"];
        if ([resCode isEqualToString:@"000010"])
        {
            [self showToast:@"手机验证码错误"];
            return ;
        }
        if ([resCode isEqualToString:@"100009"])
        {
            [self showToast:@"更改密码成功,请登录"];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *code)
    {
        [self showToast:@"网络错误"];
    }];
    
    
    
    
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
