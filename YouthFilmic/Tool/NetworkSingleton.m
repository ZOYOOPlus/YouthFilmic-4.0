//
//  NetworkSingleton.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/13.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//@“http://api.youthfilmic.com/v1/auth/loginByWeixin”

#import "NetworkSingleton.h"
#import "HXTools.h"
#import "User.h"
#define QNHOST  @"http://api.app.youthfilmic.com/v1/"
//#define chargeURL @""
@implementation NetworkSingleton
+(NetworkSingleton *)sharedManager{
    static NetworkSingleton *sharedNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkSingleton = [[self alloc] init];
    });
    return sharedNetworkSingleton;
}
-(AFHTTPRequestOperationManager *)baseHtppRequest{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    return manager;
}
-(AFHTTPRequestOperationManager *)restHtppRequest{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    return manager;
}

#pragma mark 得到活动相关数据
-(void)getActivities:(NSString*)page success:(void(^)(AFHTTPRequestOperation*operation,id responseObject,NSUInteger count))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@activity/list?&page=%@&size=10",QNHOST,page];
    NSLog(@"%@",url);
    AFHTTPRequestOperationManager *mgr = [self baseHtppRequest];
    AFHTTPRequestOperation *opretion = [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSDictionary *outDic = dic[@"data"];
        NSNumber *coun = outDic[@"total"];
        NSUInteger uount = [coun integerValue];
        NSArray *actiAry = outDic[@"data"];
        success(opretion,actiAry,uount);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(opretion,@"");

    }];
    

}

-(void)getFilmFind:(NSString*)page success:(void(^)(AFHTTPRequestOperation*operation,id responseObject,NSString *count))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure
{
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:page,@"page",@"10",@"size" ,nil];
      NSString *url = [NSString stringWithFormat:@"%@post/list",QNHOST];
      AFHTTPRequestOperationManager *mgr = [self baseHtppRequest];
    AFHTTPRequestOperation*operation1 = [mgr GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSDictionary *dataDic = dic[@"data"];
            NSArray *articleAry = dataDic[@"data"];
            NSNumber *cou = dic[@"total"];
            NSNumberFormatter *forMatter = [[NSNumberFormatter alloc]init];
            NSString *yuY = [forMatter stringFromNumber:cou];
        success(operation1,articleAry,yuY);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,@"");
            
            NSLog(@"获取发现数据出现错误%@",error);

        }];
    

}
- (void)weChatLogin:(NSString*)wechatCode success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation))failure
{
    
    NSString *strtt = [NSString stringWithFormat:@"%@auth/loginByWeixin",QNHOST];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:wechatCode,@"code" ,nil];
    
    
    AFHTTPRequestOperationManager *mgr = [self restHtppRequest];
    
     [mgr POST:strtt parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        NSLog(@"为了存放userid%@",responseObject);
        
        
        
        success(operation,responseObject);
        
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         NSLog(@"登陆出现错误%@",error);
         failure(operation);
 
    }];

    
}
#pragma mark 获取短信验证码
- (void)getPhoneCode:(NSDictionary *)parameters success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation))failure
{
//    NSString *url = [NSString stringWithFormat:@"%@service/sendMobileMessageCode",QNHOST];
//    NSLog(@"参数%@找发送验证码的接口错误%@",parameters,url);
    
//    parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"15010216787",@"phone",@"1",@"type", nil];
    AFHTTPRequestOperationManager *mgr = [self baseHtppRequest];
    AFHTTPRequestOperation*operation1 = [mgr POST:@"http://api.app.youthfilmic.com/service/sendMobileMessageCode" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        success(operation1,responseObject);
    }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          ;
          NSLog(@"获取验证码出现错误%@",[error userInfo]);
          failure(operation);
    }];
    
    
}
#pragma mark 注册
- (void)registUse:(NSDictionary*)parameters success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure
{
    NSString *url = [NSString stringWithFormat:@"%@auth/registerByPhone",QNHOST];
    AFHTTPRequestOperationManager *mgr = [self baseHtppRequest];

    AFHTTPRequestOperation*operation1 = [mgr POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         success(operation1,responseObject);
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          failure(operation1,@"");
          
          NSLog(@"注册错误%@",error);

      }];

}
#pragma mark 手机号码登录
- (void)phoneLogin:(NSDictionary *)parameters success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation))failure
{
   
    NSString *url = [NSString stringWithFormat:@"%@auth/loginByPhone",QNHOST];
    AFHTTPRequestOperationManager *mgr = [self baseHtppRequest];
    AFHTTPRequestOperation*operation1 = [mgr POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                
                NSLog(@"手机号登陆userid");
                
            success(operation1,responseObject);
                
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"登录错误%@",error);
        
         failure(operation1);
        
    }];

    
}
#pragma mark 获取用户相关信息

- (void)getUserInfor:(NSString *)token success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation))failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@user/getUserInfo?token=%@",QNHOST,[User sharedInstance].UserToken];
//    updateProfile
    AFHTTPRequestOperationManager *mgr = [self baseHtppRequest];
    AFHTTPRequestOperation*operation1 = [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"获取用户相关信息%@",responseObject);
     success(operation1,responseObject);
      }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
      {
        NSLog(@"获取用户信息失败%@",error);
                                             
        failure(operation1);
                                             
       }];
    

    
}
#pragma mark 重置密码

- (void)updatePasswoed :(NSDictionary*)parameters success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure
{
    
    NSString *url = [NSString stringWithFormat:@"%@auth/rememberByPhone",QNHOST];
    
    AFHTTPRequestOperationManager *mgr = [self baseHtppRequest];
    AFHTTPRequestOperation*operation1 = [mgr POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             
                                             success(operation1,responseObject);
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             NSLog(@"获取用户信息失败%@",error);
                                             
                                             failure(operation1,@"");
                                             
                                         }];
    

    
}

#pragma mark 获取charge
- (void)getCharge:(NSString*)orderID success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure
{
    NSString *url = [NSString stringWithFormat:@"http://talent.youthfilmic.com/main/v1/payment/%@/get_info?type=wx_app",orderID];
    AFHTTPRequestOperationManager *mgr = [self restHtppRequest];
    AFHTTPRequestOperation*operation1 = [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        success(operation1,operation.responseString);
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"获取charge失败%@",error);
        
    }];
 
    
    
}

#pragma mark 获取七牛上传需要的token key 和公司服务域名

- (void)getQiniuTokenAndKeysuccess:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure
{
   NSString *url = [NSString stringWithFormat:@"http://api.app.youthfilmic.com/service/getUploadToken?token=%@&type=normal_image",[User sharedInstance].UserToken];
    AFHTTPRequestOperationManager *mgr = [self baseHtppRequest];
    AFHTTPRequestOperation*operation1 = [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"骑牛%@",url);
//        NSLog(@"%@",operation.responseString);
        success(operation1,responseObject);
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"获取七牛失败%@",error);
        
    }];

    
    
    
    
}

#pragma mark 更新用户资料
- (void)updateUserInfor:(NSDictionary*)parameters success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure
{
    NSString *url = [NSString stringWithFormat:@"%@user/updateUserInfo",QNHOST];
    //    updateProfile
    AFHTTPRequestOperationManager *mgr = [self baseHtppRequest];
    
    
    AFHTTPRequestOperation*operation1 = [mgr POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
        {

       success(operation1,responseObject);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
          NSLog(@"更改用户信息失败%@",error);
                                             
        failure(operation1,@"");
                                             
        }];
    
  
}
#pragma mark 退出登录
- (void)logoutsuccess:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure
{
    NSString *token = [User sharedInstance].UserToken;
    NSString *url = [NSString stringWithFormat:@"http://api.app.youthfilmic.com//v1/auth/logout?token=%@",token];
    
    AFHTTPRequestOperationManager *mgr = [self baseHtppRequest];
    AFHTTPRequestOperation*operation1 = [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        //        NSLog(@"%@",operation.responseString);
        success(operation1,responseObject);
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"退出登录失败%@",error);
        
    }];

    
//    http://api.app.youthfilmic.com//v1/im/listConversation?token=493a37b473eeb372cbb1e78bdbafe874c41a760d
    
}
- (void)getHelpConvorsation:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure
{
    NSString *token = [User sharedInstance].UserToken;
    NSString *url = [NSString stringWithFormat:@"http://api.app.youthfilmic.com//v1/im/listConversation?token=%@",token];
    NSLog(@"获取群组%@",url);
    AFHTTPRequestOperationManager *mgr = [self baseHtppRequest];
    AFHTTPRequestOperation*operation1 = [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        //        NSLog(@"%@",operation.responseString);
//        NSDictionary *dic = [HXTools jsonStringToObject:operation.responseString];
        success(operation1,responseObject);
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"获取群组信息失败%@",error);
        
    }];

    
    
    
}
#pragma mark pravateMethoud
- (NSString *)getStringFromParameters:(NSDictionary *)parameters
{
    NSString *paramString = nil;
    NSMutableArray *paramArray = [NSMutableArray array];
    if (parameters)
    {
        NSArray *allKeys = [parameters allKeys];
        for (NSUInteger i = 0; i < [allKeys count]; i++)
        {
            id key = [allKeys objectAtIndex:i];
            id value = (NSString *)[parameters objectForKey:key];
            NSString *itemString = [NSString stringWithFormat:@"%@=%@", key, value];
            [paramArray addObject:itemString];
        }
        
        if ([paramArray count] > 0)
        {
            paramString = [paramArray componentsJoinedByString:@"&"];
        }
    }
    
    return paramString;
    
    
}


@end
