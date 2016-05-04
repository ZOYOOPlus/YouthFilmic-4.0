//
//  NetworkSingleton.h
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/13.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
//请求超时
#define TIMEOUT 30

typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlock)(NSString *error);


@interface NetworkSingleton : NSObject

+(NetworkSingleton *)sharedManager;
-(AFHTTPRequestOperationManager *)baseHtppRequest;
#pragma mark 首页获取列表数据
-(void)getActivities:(NSString*)page success:(void(^)(AFHTTPRequestOperation*operation,id responseObject,NSUInteger count))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure;
#pragma mark 发现获取列表数据

-(void)getFilmFind:(NSString*)page success:(void(^)(AFHTTPRequestOperation*operation,id responseObject,NSString *count))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure;

#pragma mark 注册
- (void)registUse:(NSDictionary*)parameters success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure;
#pragma mark 微信登陆
- (void)weChatLogin:(NSString*)wechatCode success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation))failure;
#pragma 获取验证码
- (void)getPhoneCode:(NSDictionary *)parameters success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation))failure;
#pragma mark 手机号码登录
- (void)phoneLogin:(NSDictionary *)parameters success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation))failure;
#pragma mark 获取用户相关信息

- (void)getUserInfor:(NSString *)token success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation))failure;

#pragma mark 重置密码

- (void)updatePasswoed :(NSDictionary*)parameters success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure;

#pragma mark 获取charge

- (void)getCharge:(NSString*)orderID success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure;

- (void)getConverSationsuccess:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure;

#pragma mark 获取七牛上传需要的token key 和公司服务域名

- (void)getQiniuTokenAndKeysuccess:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure;

#pragma mark 更新用户资料
- (void)updateUserInfor:(NSDictionary*)parameters success:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure;

#pragma mark 退出登录
- (void)logoutsuccess:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure;

#pragma mark 获取群组信息
- (void)getHelpConvorsation:(void(^)(AFHTTPRequestOperation*operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation*operation,NSString *code))failure;
@end
