//
//  MessegeController.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/26.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "MessegeController.h"
#import "FrendListCell.h"
#import "ChatViewController.h"
#import "LogViewController.h"
#import "Mesages.h"


@interface MessegeController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *MytableView;
@property (nonatomic,strong)NSMutableArray *coverAry;
@end

@implementation MessegeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.coverAry = [NSMutableArray array];
    self.title = @"会话";
    [[NetworkSingleton sharedManager]getHelpConvorsation:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *dic = (NSDictionary*)responseObject;
        NSNumber *num = dic[@"code"];
        if ([num isEqual:@100021])
        {
            NSDictionary *dataDic = dic[@"data"];
            NSArray *converAry = dataDic[@"conversations"];
            self.coverAry = [Mesages mj_objectArrayWithKeyValuesArray:converAry];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *code) {
        
    }];

    self.MytableView.tableHeaderView = [self customHeaderView];
//    self.MytableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FrendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FrendListCell" owner:nil options:nil]lastObject];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
    
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
    
    ChatViewController *chatView = [[ChatViewController alloc]init];
    [self.navigationController pushViewController:chatView animated:YES];

       

}


- (UIView *)customHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
    return headerView;
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
