//
//  HXTools.h
//  HXFundManager
//
//  Created by Sha Tao on 15-1-28.
//  Copyright (c) 2015年 China Asset Management Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXTools : NSObject

//JSON String - Array/Dictionary 互转
+ (NSString *)objectToJSONString:(id)obj;
+ (id)jsonStringToObject:(NSString *)jsonString;

//向 User Default 中存取 Array/Dictionary，加密存储
+ (void)setObjectToUserDefaults:(id)value forKey:(NSString *)defaultName;
+ (id)getObjectFromUserDefaultsForKey:(NSString *)defaultName;

//向 User Default 中存取 NSString，加密存储
+ (void)setStringToUserDefaults:(NSString *)value forKey:(NSString *)defaultName;
+ (NSString *)getStringFromUserDefaultsForKey:(NSString *)defaultName;

//转化数值串，如果为空则返回“--”
+ (NSString *)formatValueString:(NSString *)valueString;

@end
