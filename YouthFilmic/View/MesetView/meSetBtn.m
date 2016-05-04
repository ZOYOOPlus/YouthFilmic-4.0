//
//  meSetBtn.m
//  121mai
//
//  Created by 高刘备 on 16/3/7.
//  Copyright © 2016年 谷武科技. All rights reserved.
//

#import "meSetBtn.h"

@implementation meSetBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect
{
    self.imageView.frame = CGRectMake(5, 0, self.frame.size.width-10, self.frame.size.height-25);
    self.titleLabel.frame = CGRectMake(5, self.frame.size.height-10, self.frame.size.width-10, 15);
    
    
 }


@end
