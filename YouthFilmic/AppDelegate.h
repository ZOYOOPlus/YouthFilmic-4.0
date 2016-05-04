//
//  AppDelegate.h
//  YouthFilmic
//
//  Created by 张源海 on 16/4/13.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

static NSString *appKey = @"89930460099b70c8c440d777";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

// init Push
// init Push(<= 1.8.8版本的SDK的注册方法）
+ (void)setupWithOption:(NSDictionary *)launchingOption;

// init Push(2.1.0版本的SDK新增的注册方法)
+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction;

// init Push(2.1.5版本的SDK新增的注册方法，带IDFA  )
+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction
  advertisingIdentifier:(NSString *)advertisingId;


// 注册APNS类型
+ (void)registerForRemoteNotificationTypes:(NSUInteger)types
                                categories:(NSSet *)categories;

// upload device token
+ (void)registerDeviceToken:(NSData *)deviceToken;

// handle notification recieved
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;







@end

