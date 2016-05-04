//
//  LBsetingGrop.h
//  121mai
//
//  Created by 高刘备 on 16/3/5.
//  Copyright © 2016年 谷武科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBsetingGrop : NSObject

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) NSString *headTitle;

@property (nonatomic, strong) NSString *footTitle;

+ (instancetype)groupWithItems:(NSArray *)items;

@end
