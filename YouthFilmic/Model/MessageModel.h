//
//  MessageModel.h
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/26.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,copy)NSString *isme;

@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *dateStr;

@property (nonatomic,strong)NSDate *date;
@property (nonatomic,assign) NSNumber *height;



@end
