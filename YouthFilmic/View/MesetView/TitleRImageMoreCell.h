//
//  TitleRImageMoreCell.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-9-3.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#define kCellIdentifier_TitleRImageMore @"TitleRImageMoreCell"

#import <UIKit/UIKit.h>
#import "User.h"

@interface TitleRImageMoreCell : UITableViewCell

@property (nonatomic,copy)NSString *iconImage;

@property (nonatomic,strong)UIImage *icIMaegl;
+ (CGFloat)cellHeight;
@end
