//
//  NSString+expand.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/17.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "NSString+expand.h"

@implementation NSString (expand)

//判断是否是手机号码或者邮箱
- (BOOL)isPhoneNo{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}
- (BOOL)isEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
