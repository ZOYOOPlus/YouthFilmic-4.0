//
//  MesetHeader.h
//  121mai
//
//  Created by 高刘备 on 16/3/7.
//  Copyright © 2016年 谷武科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MesetHeader : UIView
@property (copy,nonatomic) void(^userIconClick)();

@property (copy,nonatomic)  void(^goodStateClick)(NSString* state);

@end
