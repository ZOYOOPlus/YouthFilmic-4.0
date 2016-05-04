//
//  HXTools.m
//  HXFundManager
//
//  Created by Sha Tao on 15-1-28.
//  Copyright (c) 2015年 China Asset Management Co., Ltd. All rights reserved.
//

#import "HXTools.h"


typedef NS_ENUM(NSInteger, GradeType) {
    GradeTypeGe = 0,
    GradeTypeWan,
    GradeTypeYi
};//枚举：数字级别：整数部分的分级(个级，万级，亿级)

@implementation HXTools

#pragma mark - JSON -
+ (NSString *)objectToJSONString:(id)obj
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData)
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (jsonString)
        {
            //去除空格和回车
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
    }
    
    return jsonString;
}

+ (id)jsonStringToObject:(NSString *)jsonString
{
    id obj = nil;
    NSError *error;
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData)
    {
        obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    }
    
    return obj;
}

#pragma mark - UserDefault -
+ (void)setObjectToUserDefaults:(id)value forKey:(NSString *)defaultName
{
//    NSString *jsonString = [self objectToJSONString:value];
//    NSString *encryptedString = [HXCrypto encryptorWithAES:jsonString withIV:YES];
//    [[NSUserDefaults standardUserDefaults] setObject:encryptedString forKey:defaultName];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getObjectFromUserDefaultsForKey:(NSString *)defaultName
{
//    NSString *encryptedString = [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
//    if (encryptedString == nil)
//    {
//        return nil;
//    }
//    else
//    {
//        NSString *jsonString = [HXCrypto decryptorWithAES:encryptedString withIV:YES];
//        return [self jsonStringToObject:jsonString];
//    }
    return @"";
}

+ (void)setStringToUserDefaults:(NSString *)value forKey:(NSString *)defaultName
{
//    NSString *encryptedString = [HXCrypto encryptorWithAES:value withIV:YES];
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getStringFromUserDefaultsForKey:(NSString *)defaultName
{
    NSString *encryptedString = [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
    if (encryptedString == nil)
    {
        return nil;
    }
    else
    {
//        return [HXCrypto decryptorWithAES:encryptedString withIV:YES];
        return encryptedString;
    }
}

+ (NSString *)formatValueString:(NSString *)valueString
{
    
    NSString *ret = @"--";
    if (valueString && [valueString isKindOfClass:[NSString class]] && [valueString length] > 0)
    {
        ret = valueString;
    }
    return ret;
}

@end
