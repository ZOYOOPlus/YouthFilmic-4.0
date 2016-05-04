//
//  MeViewController.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/13.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "MeViewController.h"
#import "UserInforCell.h"
#import "LBSettingItem.h"
#import "LBsetingGrop.h"
#import "LBArrowItem.h"
#import "LogViewController.h"
#import "RxWebViewController.h"
#import "User.h"
#import "HXTools.h"
#import "UITapImageView.h"
#import "XiugaiViewController.h"
#import "SetViewContro.h"
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_meTableView;
}

@property (nonatomic,strong)NSMutableArray *groups;

@property (nonatomic,strong)UIImageView *iconImageView;

@property (nonatomic,strong)UILabel *nickNameLabel;
@property (nonatomic,strong)NSArray *htmlStrAry1;
@property (nonatomic,strong)NSArray *mlStrAry;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuceds:) name:@"LoginSucsess" object:nil];
    

//    退出登录  清楚coolkie token过期时间修改
    
    self.htmlStrAry1 = [NSArray arrayWithObjects:@"http://talent.youthfilmic.com/main/v1/user/stars",@"http://talent.youthfilmic.com/main/v1/user/following",@"http://talent.youthfilmic.com/main/v1/participation/index",@"http://talent.youthfilmic.com/main/v1/user/comments", nil];
    self.mlStrAry = [NSArray arrayWithObjects:@"http://talent.youthfilmic.com/main/v1/talentor/certification", @"http://talent.youthfilmic.com/main/v1/talentor/certification",@"http://talent.youthfilmic.com/main/v1/activity/create",nil];

    
     self.groups = [NSMutableArray array];
    [self setUpGroup0];
    
    [self setUpGroup1];
    
    [self setUpGroup2];
    
    self.title = @"我";
    [self setRightNaviButtonWithImage:[UIImage imageNamed:@"19-gear.png"] imageSize:CGSizeMake(25, 25)];
    [self addShopSubviews];
    
        [self setUserInfor];
    
}
- (void)setUserInfor
{
    if ([[User sharedInstance]tokenIsoutDate])
    {
        LogViewController *logView = [[LogViewController alloc]init];
        [self presentViewController:logView animated:YES completion:^{
            
        }];
        
        return;
        
    }

    
    [[NetworkSingleton sharedManager]getUserInfor:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSNumberFormatter *forMatter = [[NSNumberFormatter alloc]init];
        NSNumber *num = dic[@"code"];
         if ([num isEqual:@000004])
        {
            [self showToast:@"由于长时间未操作，请重新登录"];
            LogViewController *logView = [[LogViewController alloc]init];
            [self presentViewController:logView animated:YES completion:^{
                
            }];
            
            return;

        }
 
        if ([num isEqual:@100007])
        {
            NSDictionary *dataDic = dic[@"data"];
            NSDictionary *userDic = dataDic[@"user"];
            
            NSString *nick_name = userDic[@"nick_name"];
            NSString *pic = userDic[@"pic"];
            ;
            NSNumber *sexNum = ![userDic[@"sex"] isKindOfClass:[NSNull class]]?userDic[@"sex"]:@1;
            if (sexNum)
            {
                NSString *sex = [sexNum isEqual:@1] ?@"男":@"女";
                [User sharedInstance].sex = sex;
                
            }
            else
            {
                [User sharedInstance].sex = @"0";
                
            }
            
            [User sharedInstance].nick_name = nick_name;
            [User sharedInstance].IconImage = pic;
            [User sharedInstance].is_talentor = userDic[@"is_talentor"];
            
            self.iconImageView.yy_imageURL = [NSURL URLWithString:pic];
            self.nickNameLabel.text = nick_name;
            

        }

        
    } failure:^(AFHTTPRequestOperation *operation) {
        
    }];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [_meTableView reloadData];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUserInfor];
}

- (void)viewWillDisappear:(BOOL)animated
{
}

//- (void)loginSuceds:(NSNotification*)noti
//{
////    登陆成功
//    NSLog(@"这个怎么回事没进入吗");
//    [self setUserInfor];
//    
//}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)setUpGroup0
{
    LBArrowItem *interested= [LBArrowItem itemWithImage:[UIImage imageNamed:@"heart.png"] title:@"我感兴趣的活动"];
    interested.destVc = [RxWebViewController class];
    
    
    LBArrowItem *attention = [LBArrowItem itemWithImage:[UIImage imageNamed:@"person.png"] title:@"我关注的达人"];
    attention.destVc = [RxWebViewController class];
    
    LBArrowItem *order = [LBArrowItem itemWithImage:[UIImage imageNamed:@"file-text.png"] title:@"我的订单"];
    order.destVc = [RxWebViewController class];
    
    LBArrowItem *comment = [LBArrowItem itemWithImage:[UIImage imageNamed:@"comment.png"] title:@"我的评论"];
    comment.destVc = [RxWebViewController class];
    
    
    LBsetingGrop *group = [LBsetingGrop groupWithItems:@[interested,attention,order,comment]];
    [self.groups addObject:group];
}

- (void)setUpGroup1
{
    LBArrowItem *vipPeople = [LBArrowItem itemWithImage:[UIImage imageNamed:@"security.png"] title:@"达人认证"];
    vipPeople.destVc = [RxWebViewController class];
    
    
    LBArrowItem *myView = [LBArrowItem itemWithImage:[UIImage imageNamed:@"home.png"] title:@"我的主页"];
    myView.destVc = [RxWebViewController class];
    
    LBArrowItem *publish  = [LBArrowItem itemWithImage:[UIImage imageNamed:@"pencil-square.png"] title:@"发布活动"];
    publish.destVc = [RxWebViewController class];
    
    
    LBsetingGrop *group = [LBsetingGrop groupWithItems:@[vipPeople,myView,publish]];
    [self.groups addObject:group];
    
    
}

- (void)setUpGroup2
{
    
    LBArrowItem *question  = [LBArrowItem itemWithImage:[UIImage imageNamed:@"wandershop_mypage_settting_nav.png"] title:@"设置"];
    question.destVc  = [RxWebViewController class];
    
    
//    LBArrowItem *suggestion = [LBArrowItem itemWithImage:[UIImage imageNamed:@"life-bouy.png"] title:@"关于我们"];
//    suggestion.destVc = [RxWebViewController class];
    
    
    LBsetingGrop *group = [LBsetingGrop groupWithItems:@[question]];
    [self.groups addObject:group];
    
    
}
- (void)addShopSubviews
{
    _meTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-84) style:UITableViewStyleGrouped];
    _meTableView.delegate = self;
    _meTableView.dataSource = self;
    _meTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _meTableView.rowHeight = 44;
    _meTableView.tableHeaderView = [self customHeaserView];
    //    _meTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    _meTableView.showsVerticalScrollIndicator = NO;
    [_meTableView registerNib:[UINib nibWithNibName:@"UserInforCell" bundle:nil] forCellReuseIdentifier:@"useCell"];
    [self.view addSubview:_meTableView];
    
    
}

// 点击设置按钮了
- (void)tapNaviRightButton:(id)sender
{
    
}

- (UIView *)customHeaserView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 90)];
    headerView.backgroundColor = [UIColor colorWithRed:50/255.0 green:131/255.0 blue:249/255.0 alpha:1];
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    self.iconImageView.layer.cornerRadius = 20;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.image = [UIImage imageNamed:@"default-gravatar-pic.jpg"];
    self.nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 30, 200, 20)];
    self.nickNameLabel.text = @"未登陆";
    self.nickNameLabel.textAlignment = NSTextAlignmentLeft;
    self.nickNameLabel.font =[UIFont systemFontOfSize:16];
    [headerView addSubview:self.nickNameLabel];
    [headerView addSubview:self.iconImageView];
    UITapImageView *tapImage = [[UITapImageView alloc]initWithFrame:CGRectMake(kScreen_Width-45, 20, 25, 25)];
    tapImage.image = [UIImage imageNamed:@"edit.png"];
    [tapImage addTapBlock:^(id obj) {
        
        if ([[User sharedInstance]tokenIsoutDate])
        {
            LogViewController *logView = [[LogViewController alloc]init];
            [self presentViewController:logView animated:YES completion:^{
                
            }];
            
            return;
            
        }

        XiugaiViewController *xiu = [[XiugaiViewController alloc]init];
        [self.navigationController pushViewController:xiu animated:YES];
     }];
    [headerView addSubview:tapImage];
    
    
    return headerView;
    
}
#pragma mark TableViewDelegate  dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LBsetingGrop *group = self.groups[section];
    
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBsetingGrop *group = self.groups[indexPath.section];
    LBArrowItem *aItem = group.items[indexPath.row];
    static NSString *ID = @"useCell";
    UserInforCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"UserInforCell" owner:nil options:nil]lastObject];
    }
    cell.item = aItem;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, 0, 2);
    return view;
}

- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section

{
    
    return 1.0 ;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if ([[User sharedInstance]tokenIsoutDate])
    {
                    LogViewController *logView = [[LogViewController alloc]init];
                    [self presentViewController:logView animated:YES completion:^{
        
                    }];
        
        return;

    }
    
    
    
    if (indexPath.section == 0)
    {
        NSString *html = self.htmlStrAry1[indexPath.row];
        NSURL *url = [NSURL URLWithString:html];
        RxWebViewController *rxWeb = [[RxWebViewController alloc]initWithUrl:url];
        [self.navigationController pushViewController:rxWeb animated:YES];
    }
    else if (indexPath.section == 1)
    {
        NSString *html = self.mlStrAry[indexPath.row];
        NSURL *url = [NSURL URLWithString:html];
        if (indexPath.row == 1)
        {
            if ([[User sharedInstance].is_talentor isEqual:@0])
            {
                [self showToast:@"你还未申请成为达人，暂无个人主页，马上申请吧"];
                return;
            }
            
            
            
        }
        RxWebViewController *rxWeb = [[RxWebViewController alloc]initWithUrl:url];
        [self.navigationController pushViewController:rxWeb animated:YES];

    }
    else
    {
        NSLog(@"进入设置界面");
        SetViewContro * set = [[SetViewContro alloc]init];
        [self.navigationController pushViewController:set animated:YES];

    }
    
    
}
@end
