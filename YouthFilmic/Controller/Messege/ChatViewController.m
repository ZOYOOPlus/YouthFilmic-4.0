//
//  ChatViewController.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/26.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "ChatViewController.h"
#import "UUInputFunctionView.h"
#import "MJRefresh.h"
#import "UUMessageCell.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "MessageModel.h"
#import "LBShopDataManager.h"
#import "NSString+Common.h"
#import "MessageViewCell.h"
#import "MemasgeCell.h"
@interface ChatViewController ()<AVIMClientDelegate,UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConst;

@property (nonatomic,copy)NSString *converSationName;
@property (nonatomic,copy)NSString *converSationID;

@property (nonatomic,strong)AVIMConversation *converSation;

@end

@implementation ChatViewController
{
    UUInputFunctionView *IFView;
    BOOL isError;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"ishuan"]isEqualToString:@"1"])
    {
        [[LBShopDataManager sharedInstance]removeAllShops];
    }
    
    [self setLeftNaviButtonWithString:@"返回"];
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setleanCloudIm];
    [self loadBaseViewsAndData];
   NSArray*messegeAry = [[LBShopDataManager sharedInstance]collectShops];
    
    if (messegeAry.count <= 0)
    {
        NSDate *date = [NSDate date];
        
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        
        MessageModel *model = [[MessageModel alloc]init];
        model.date = date;
        model.dateStr = currentDateStr;
        model.content= @"欢迎来到青年电影志，有什么问题可以向我们反馈";
       CGSize size = [model.content getSizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kScreen_Width-160, MAXFLOAT)];
        model.height = [NSNumber numberWithFloat:size.height+10];
        model.isme = @"0";
        
        [[LBShopDataManager sharedInstance] addCollectMessage:model];
        [self.chatTableView reloadData];
        
         
    }

    // Do any additional setup after loading the view.
}
- (void)tapNaviLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
}

- (void)loadBaseViewsAndData
{
    
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
    IFView.delegate = self;

    [self.view addSubview:IFView];
    
     
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];

    
    
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
      NSArray*messegeAry = [[LBShopDataManager sharedInstance]collectShops];
    if (messegeAry.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:messegeAry.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



-(void)keyboardChange:(NSNotification *)notification
{
    
     NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        self.bottomConst.constant = keyboardEndFrame.size.height+40;
    }else{
        self.bottomConst.constant = 40;
    }
    
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = IFView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height-64;
    IFView.frame = newFrame;
    
    [UIView commitAnimations];
    
}


#pragma mark - InputFunctionViewDelegate
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    if (message.length == 0)
    {
        [self showToast:@"请输入您想要给我们说的话"];
        return;
    }
    if (isError)
    {
        return;
    }

    [self.converSation sendMessage:[AVIMTextMessage messageWithText:message attributes:nil] callback:^(BOOL succeeded, NSError *error)
    {
        NSLog(@"发送成功了嘛");
        
        
        if (succeeded) {
            NSDate *date = [NSDate date];
            
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
            //用[NSDate date]可以获取系统当前时间
            NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];

            MessageModel *model = [[MessageModel alloc]init];
            model.isme = @"1";
            model.content = message;
            model.date = date;
            model.dateStr = currentDateStr;
            CGSize size = [model.content getSizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kScreen_Width-160, MAXFLOAT)];
            model.height = [NSNumber numberWithFloat:size.height];
            [[LBShopDataManager sharedInstance]addCollectMessage:model];
            [self.chatTableView reloadData];
            [self tableViewScrollToBottom];
            
            
         }
    }];
    
    
    
  
//    NSDictionary *dic = @{@"strContent": message,
//                          @"type": @(UUMessageTypeText)};
    funcView.TextViewInput.text = @"";
    [funcView changeSendBtnWithPhoto:NO];
//    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture)};
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice)};
    [self dealTheFunctionData:dic];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
//    [self.chatModel addSpecifiedItem:dic];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return [[LBShopDataManager sharedInstance]collectShops].count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [[LBShopDataManager sharedInstance]collectShops];
    NSManagedObject *ovbj = [array objectAtIndex:indexPath.row];
    NSString *isme = [ovbj valueForKey:@"isme"];
    if ([isme isEqualToString:@"0"])
    {
        MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageViewCell" owner:nil options:nil]lastObject];
        }
 
        cell.obj =ovbj;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }
    else
    {
        MemasgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MemasgeCell" owner:nil options:nil]lastObject];
        }

        cell.obj =ovbj;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }
    
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSArray *array = [[LBShopDataManager sharedInstance]collectShops];
    NSManagedObject *obj = [array objectAtIndex:indexPath.row];
    NSNumber *number = [obj valueForKey:@"height"];
    

    return [number floatValue]+25;
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - cellDelegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    // headIamgeIcon is clicked
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cell.messageFrame.message.strName message:@"headImage clicked" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
    [alert show];
}



#pragma mark 设置leancloudIm
- (void)setleanCloudIm
{
    NSString *userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"WYopenid"];
    self.leanClient = [[AVIMClient alloc]initWithClientId:userId];
    self.leanClient.delegate = self;
    [self createConversationsWithName:@"系统会话1" clientIds:@[@"571df1cedf0eea00644d6f64"]];
    
    
}

- (void)createConversationsWithName:(NSString*)name clientIds:(NSArray*)clientIds {
    if (self.leanClient.status == AVIMClientStatusNone)
    {
        [self.leanClient openWithCallback:^(BOOL succeeded, NSError *error) {
            if (error)
            {
                NSLog(@"开启系统对话失败%@",error);
                [self showToast:@"抱歉！网络错误，您暂时不能与我们对话，请稍后重试"];
                isError = YES;
                
            }
            
            else
            {
                [self.leanClient createConversationWithName:name clientIds:clientIds callback:^(AVIMConversation *conversation, NSError *error) {
                    isError = NO;
                    self.converSation = conversation;
                    
                    
                }];
                
                
            }
        }];
    }
    
    else
    {
        [self.leanClient closeWithCallback:^(BOOL succeeded, NSError *error) {
            
            [self.leanClient openWithCallback:^(BOOL succeeded, NSError *error) {
                if (error)
                {
                    isError = YES;
                    NSLog(@"开启系统对话失败%@",error);
                [self showToast:@"抱歉！网络错误，您暂时不能与我们对话，请稍后重试"];
                    

                    
                }
                
                else
                {
                    [self.leanClient createConversationWithName:name clientIds:clientIds callback:^(AVIMConversation *conversation, NSError *error) {
                        isError = NO;
                        self.converSation = conversation;
                        
                        
                    }];
                }
            }];
            
            
        }];
        
        
    }
    
}

// 接收消息的回调函数
-(void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message{
    
    
 
}

- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    
    
    if (!message.text)
    {
        return;
    }
    
    
    NSLog(@"发送的时间错%lld",message.sendTimestamp);
 
    NSDate *date = [NSDate date];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    MessageModel *model = [[MessageModel alloc]init];
    model.isme = @"0";
    model.content = message.text;
    model.date = date;
    model.dateStr = currentDateStr;
    CGSize size = [model.content getSizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kScreen_Width-160, MAXFLOAT)];
    model.height = [NSNumber numberWithFloat:size.height+10];
    [[LBShopDataManager sharedInstance]addCollectMessage:model];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}


@end
