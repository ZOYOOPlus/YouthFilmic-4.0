//
//  User.h
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/16.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

HXSingleton_interface(User)

@property (nonatomic,copy)NSString *UserToken;

@property (nonatomic,copy)NSString *IconImage;

@property (nonatomic,copy)NSString *nick_name;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,assign)NSNumber *is_talentor;

@property (nonatomic,copy)NSString *isHuanRen;

@property (nonatomic,copy)NSString *zhiye;
- (void)setSanBoxToken:(NSString *)token;

- (BOOL)tokenIsoutDate;

@end
