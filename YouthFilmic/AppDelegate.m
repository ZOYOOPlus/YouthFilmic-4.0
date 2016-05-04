//
//  AppDelegate.m
//  YouthFilmic
//
//  Created by 张源海 on 16/4/13.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#define leanAppID @"DEWzDzQGBI7TEBFeQMHzA8qj-gzGzoHsz"
#define leanAppKey @"QEmWtIlCb8dipoE68rbaAsfR"
#import "AppDelegate.h"
#import "BaseTabViewController.h"
#import "UIImage+ZLResizableImage.h"
#import "XMGTopWindowViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import <Pingpp.h>
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
//#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"


//GooglePlus SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
//#import <ShareSDKConnector/ShareSDKConnector.h>
#import "JPUSHService.h"

@interface AppDelegate ()<WXApiDelegate>

@property (nonatomic, strong) UIWindow *topWindow;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    [JPUSHService setupWithOption:launchOptions appKey:@"89930460099b70c8c440d777"
                          channel:@"Publish channel"
                 apsForProduction:@"0"
            advertisingIdentifier:nil];
    
    
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"iosv1101"
     
          activePlatforms:@[
                            
                            //                            @(SSDKPlatformTypeMail),
                            //                            @(SSDKPlatformTypeSMS),
                            //                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            //                            @(SSDKPlatformTypeRenren),
                            //                            @(SSDKPlatformTypeGooglePlus)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
                 //             case SSDKPlatformTypeSinaWeibo:
                 //                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 ////                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2738034454"
                 ////                                           appSecret:@"522876479e08bc1e4d23ad796ad2e96d"
                 ////                                         redirectUri:@"http://www.sharesdk.cn"
                 ////                                            authType:SSDKAuthTypeBoth];
                 //                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx0c324a696d719ade"
                                       appSecret:@"e3c0469ac38811c1fc7837863c3e658e"];
                 break;
             default:
                 break;
         }
     }];
    

    
    self.window.rootViewController = [[BaseTabViewController alloc]init];
    [self customizeintreface];
    [self wechatLogSet];
    
    // 初始化 LeanCloud SDK
    [AVOSCloud setApplicationId:leanAppID clientKey:leanAppKey];
#ifdef DEBUG
    [AVAnalytics setAnalyticsEnabled:NO];
    [AVOSCloud setVerbosePolicy:kAVVerboseShow];
    [AVLogger addLoggerDomain:AVLoggerDomainIM];
    [AVLogger addLoggerDomain:AVLoggerDomainCURL];
    [AVLogger setLoggerLevelMask:AVLoggerLevelAll];
#endif
//    [AVOSCloudIM registerForRemoteNotification];
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
    
    
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    
}

- (void)customizeintreface
{
   UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
//    [navigationBarAppearance setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:50/255.0 green:131/255.0 blue:249/255.0 alpha:1 ]] forBarMetrics:UIBarMetricsDefault];
      [navigationBarAppearance setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:126/255.0 green:212/255.0 blue:245/255.0 alpha:1 ]] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];//返回按钮的箭头颜色
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     };
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    
    self.topWindow = [[UIWindow alloc] init];
    self.topWindow.frame = [UIApplication sharedApplication].statusBarFrame;
    self.topWindow.windowLevel = UIWindowLevelAlert;
    self.topWindow.rootViewController = [[XMGTopWindowViewController alloc] init];
    self.topWindow.backgroundColor = [UIColor clearColor];
    self.topWindow.hidden = NO;
    [XMGTopWindowViewController sharedInstance].statusBarStyle = UIStatusBarStyleLightContent;


    
    
}
-(void) onReq:(BaseReq*)req
{
    NSLog(@"nihhhhhninnnnnn");
}
- (void)onResp:(BaseResp *)resp
{
   if ([resp isKindOfClass:[SendAuthResp class]])
   {
       SendAuthResp *ree = (SendAuthResp*)resp;
       
//       [[NetworkSingleton sharedManager]getuserOpenid:ree.code success:^(AFHTTPRequestOperation *operation, id responseObject) {
//           
//           
//           NSLog(@"获取openid%@",responseObject);
//       } failure:^(AFHTTPRequestOperation *operation) {
//           
//       }];

       
       
       
       
       
       
     [[NetworkSingleton sharedManager]weChatLogin:ree.code success:^(AFHTTPRequestOperation *operation, id responseObject)
       {

           
           NSLog(@"成功");
           NSDictionary *dict = [HXTools jsonStringToObject:operation.responseString];
           NSLog(@"微信登陆成功%@",dict);
           if ([dict[@"code"] isEqualToString:@"100004"])
           {
               NSDictionary *dic = dict[@"data"];
               NSString *tok = dic[@"token"];
               NSNumber *userId = dic[@"user_id"];
               NSNumberFormatter *forematter = [[NSNumberFormatter alloc]init];
               NSString *strUserId =[forematter stringFromNumber:userId];
               
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


               //               把openid存本地
               [[NSUserDefaults standardUserDefaults]setObject:strUserId forKey:@"WYopenid"];
               [[NSUserDefaults standardUserDefaults]synchronize];

               [[User sharedInstance]setSanBoxToken:tok];
               NSData * cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
               NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
               [defaults setObject: cookiesData forKey:@"kCookie"];
               [defaults synchronize];
               
               NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
               [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
               NSDate *date = [NSDate date];
               NSString *saboxDate = [dateFormatter stringFromDate:date];
               [[NSUserDefaults standardUserDefaults]setObject:saboxDate forKey:@"outdate"];
               [[NSUserDefaults standardUserDefaults]synchronize];

//               [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginSucsess" object:nil];
               [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginSucsess" object:nil userInfo:nil];
               
           }
           
           
           
     } failure:^(AFHTTPRequestOperation *operation) {
         
         NSLog(@"失败");
     }];
 
       
   }
}
- (void)wechatLogSet
{
    //  添加第三方登录功能
    
    [WXApi registerApp:@"wx0c324a696d719ade" withDescription:@"Wechat"];
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([url.absoluteString rangeOfString:@"pay"].length > 0)
    {
        BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
        return canHandleURL;
    }
    
    
    
    return  [WXApi handleOpenURL:url delegate:self];
}

//- (BOOL)application:(UIApplication *)app
//            openURL:(NSURL *)url
//            options:(NSDictionary *)options {
//    BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
//    return canHandleURL;
//}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];

}
-(BOOL)application:(UIApplication*)app openURL:(NSURL*)url options:(NSDictionary<NSString *,id> *)options
{
    if ([url.absoluteString rangeOfString:@"pay"].length > 0)
    {
        BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
        return canHandleURL;
    }

    

    return  [WXApi handleOpenURL:url delegate:self];
}





#pragma mark - Core Data stack

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.chinaamc.DataDisplay" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataDisplay" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataDisplay.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



@end
