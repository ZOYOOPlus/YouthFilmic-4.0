//
//  HomeViewController.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/13.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "HomeViewController.h"
#import "ActivitiesCell.h"
#import "Activity.h"
#import "RxWebViewController.h"
#import "LogViewController.h"
#import "MeViewController.h"
#import "ddWebViewController.h"
//#import "NetworkSingleton.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ActiviTableView;
@property (nonatomic,strong)NSMutableArray *actiAry;
@property (nonatomic,assign)BOOL isLoading;
@property (nonatomic,assign)NSInteger curretPage;
@property (nonatomic,assign)NSInteger activityToalcount;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _curretPage = 1;
    [self initMethoud];
    self.navigationItem.title = @"青年电影志";
    self.ActiviTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewActivities];
    }];
    self.ActiviTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreActivities];
    }];
    [self loadNewActivities];
    
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self loadNewActivities];
}

- (void)initMethoud
{
    self.actiAry = [NSMutableArray array];
}

- (void)loadNewActivities
{
    if (_isLoading == YES)
    {
        return;
        
    }
    _curretPage = 1;
    [self loadActivities];

}

- (void)loadMoreActivities
{
    if (_isLoading == YES)
    {
        return;
    }
    _curretPage++;
    [self loadActivities];
  
}

- (void)loadActivities
{
    _isLoading = YES;
    
    NSString *page = [NSString stringWithFormat:@"%lu",(unsigned long)_curretPage];
    if (_curretPage == 1)
    {
        if (self.actiAry.count == 0)
        {
            [self showLoading];

        }
    }
 
    [[NetworkSingleton sharedManager]getActivities:page success:^(AFHTTPRequestOperation *operation, id responseObject, NSUInteger count)
    {
        self.activityToalcount =count;
        if (_curretPage == 1)
        {
            [self.ActiviTableView.mj_header endRefreshing];
            [self.actiAry removeAllObjects];
            [self hideLoading];
        }
        [self.ActiviTableView.mj_footer endRefreshing];
        NSArray *array = responseObject;
        NSArray *actiVityAry =[Activity mj_objectArrayWithKeyValuesArray:array];
        [self.actiAry addObjectsFromArray:actiVityAry];
 
        [self.ActiviTableView reloadData];
        _isLoading = NO;
        [self.view configBlankPage:EaseBlankNodata hasData:(self.actiAry.count>0) hasError:NO reloadButtonBlock:^(id sender) {
            
        }];
//
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *code) {
        if (_curretPage == 1)
        {
            [self.ActiviTableView.mj_header endRefreshing];
            [self hideLoading];
        }
        [self.ActiviTableView.mj_footer endRefreshing];
        //         上拉加载失败
        if (_curretPage > 1)
        {
            _curretPage--;
        }
        [self showToast:@"貌似网络不太好呢"];
        _isLoading = NO;
        if (self.actiAry.count <= 0)
        {
            
            [self.view configBlankPage:EaseBlankNodata hasData:NO hasError:YES reloadButtonBlock:^(id sender) {
                [self loadNewActivities];
 
            }];
            

        }


        
    }];
}

#pragma mark tableViewDelegate tableViewDatasource;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.ActiviTableView.mj_footer.hidden = (self.actiAry.count == self.activityToalcount);
    return self.actiAry.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivitiesCell *cell = [self.ActiviTableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ActivitiesCell" owner:nil options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Activity *tivi = self.actiAry[indexPath.row];
    cell.singleAc = tivi;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   Activity *tivi = self.actiAry[indexPath.row];
    NSString *url = [NSString stringWithFormat:@"http://talent.youthfilmic.com/main/v1/activity/%ld/show",tivi.actiId];
    NSLog(@"%@",[NSString stringWithFormat:@"%ld",tivi.actiId]);

    RxWebViewController *wev = [[RxWebViewController alloc]initWithUrl:[NSURL URLWithString:url]];
    
    //
    wev.strUrl = url;
    [self.navigationController pushViewController:wev animated:YES];
     
}


@end
