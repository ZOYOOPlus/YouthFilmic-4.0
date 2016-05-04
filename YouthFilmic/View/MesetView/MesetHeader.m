//
//  MesetHeader.m
//  121mai
//
//  Created by 高刘备 on 16/3/7.
//  Copyright © 2016年 谷武科技. All rights reserved.
//

#import "MesetHeader.h"
#import "UITapImageView.h"
#import "meSetBtn.h"
#import "User.h"
#define btnWidth 30
#define labWidth 60
#define pading (self.frame.size.width-4*btnWidth)/4
#define Lpading (self.frame.size.width-4*labWidth)/4
@implementation MesetHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/

- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor whiteColor];
    [self mAddsubViews];
}

- (void)mAddsubViews
{
    UITapGestureRecognizer *ger = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
//    [self addGestureRecognizer:ger];
    UIView *tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 70)];
    [tapView addGestureRecognizer:ger];
    [self addSubview:tapView];
    UITapImageView *iconImageView = [[UITapImageView alloc]initWithFrame:CGRectMake(pading/2, 10, 50, 50)];
    iconImageView.layer.cornerRadius = 25;
    [iconImageView.layer setMasksToBounds:YES];
   /* if ([User shareUser].icon)
    {
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[User shareUser].icon] placeholderImage:[UIImage imageNamed:@"user_default_avatar.png"]];
    }
    else
    {
        iconImageView.image = [UIImage imageNamed:@"user_default_avatar.png"];
    }*/
}
 @end
