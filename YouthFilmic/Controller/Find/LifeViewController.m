//
//  LifeViewController.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/13.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "LifeViewController.h"
#import "LogViewController.h"
#import "NormalCell.h"
#import "GifFindCell.h"
#import "todayCell.h"
#import "findLife.h"
#import "UITableView+Common.h"
#import "RxWebViewController.h"
@interface LifeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong)NSMutableArray *actiAry;
@property (nonatomic,assign)BOOL isLoading;
@property (nonatomic,assign)NSInteger curretPage;
@property (nonatomic,assign)NSInteger activityToalcount;
@property (nonatomic,strong)NSString *shareurl;
@end

@implementation LifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发现";
    _curretPage = 1;
    self.actiAry = [NSMutableArray array];
//    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewArticles];
    }];
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreArticles];
    }];

    [self loadNewArticles];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self loadNewArticles];
    
}

- (void)loadNewArticles
{
    if (_isLoading == YES)
    {
        return;
        
    }
    _curretPage = 1;
    [self loadArticles];

    
}

- (void)loadMoreArticles
{
    if (_isLoading == YES)
    {
        return;
    }
    _curretPage++;

    [self loadArticles];
}

- (void)loadArticles
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

    [[NetworkSingleton sharedManager]getFilmFind:page success:^(AFHTTPRequestOperation *operation, id responseObject, NSString *count) {
        
        self.activityToalcount =[count integerValue];
        if (_curretPage == 1)
        {
            [self.myTableView.mj_header endRefreshing];
            [self.actiAry removeAllObjects];
            [self hideLoading];
        }
        [self.myTableView.mj_footer endRefreshing];
        NSArray *array = responseObject;
        NSArray *actiVityAry =[findLife mj_objectArrayWithKeyValuesArray:array];
        [self.actiAry addObjectsFromArray:actiVityAry];
        
        [self.myTableView reloadData];
        _isLoading = NO;
        [self.view configBlankPage:EaseBlankNodata hasData:(self.actiAry.count>0) hasError:NO reloadButtonBlock:^(id sender) {
            
        }];

        
    } failure:^(AFHTTPRequestOperation *operation, NSString *code) {
        
        
        
        if (_curretPage == 1)
        {
            [self.myTableView.mj_header endRefreshing];
            [self hideLoading];
        }
        [self.myTableView.mj_footer endRefreshing];
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
                                [self loadNewArticles];
                
            }];
            
            
        }
        
        
        
    }];

  

    
}

#pragma mark TableViewDelegate  TableViewDatasoyrce

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 150;
    }
    findLife *life = self.actiAry[indexPath.row];
    if ([life.post_type isEqualToString:@"post"]||[life.post_type isEqualToString:@""])
    {
        return 90;
    }
    else
    {
        return 160;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.actiAry.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    findLife *life1 = self.actiAry[indexPath.row];

    if (indexPath.row == 0)
    {
  
        todayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todayCell"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"todayCell" owner:nil options:nil]lastObject];
        }
        cell.life = life1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
        
    }
    if ([life1.post_type isEqualToString:@"post"]||[life1.post_type isEqualToString:@""])
    {
        NormalCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"NormalCell" owner:nil options:nil]lastObject];
        }
        cell.life = life1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

        
     }
    else
    {
        
        NormalCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"GifFindCell"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"GifFindCell" owner:nil options:nil]lastObject];
        }
        cell.life = life1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
 
        
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//RxWebViewController
    findLife *life1 = self.actiAry[indexPath.row];
    if ([life1.post_type isEqualToString:@"gif"])
    {
        return;
    }
    else
    {
        NSString *strUrl =[NSString stringWithFormat:@"http://talent.youthfilmic.com/main/v1/posts/%ld",life1.ID];
        NSURL *url = [NSURL URLWithString:strUrl];
        RxWebViewController *webView = [[RxWebViewController alloc]initWithUrl:url];
        findLife *life = self.actiAry[indexPath.row];
        webView.strUrl = strUrl;

        [self.navigationController pushViewController:webView animated:YES];
        
    }

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
