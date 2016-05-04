//
//  findLife.h
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/19.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface findLife : NSObject

@property (nonatomic,assign)NSInteger ID;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *excerpt;
@property (nonatomic,copy)NSString *thumb;
@property (nonatomic,assign)NSInteger view_count;
@property (nonatomic,assign)NSInteger like_count;
@property (nonatomic,assign)NSInteger comment_count;
@property (nonatomic,copy)NSString *post_type;
@property (nonatomic,copy)NSString *created_at;
@property (nonatomic,copy)NSString *human_time;
//http://api.app.youthfilmic.com/v1/post/list?&page=1&size=10
@end
