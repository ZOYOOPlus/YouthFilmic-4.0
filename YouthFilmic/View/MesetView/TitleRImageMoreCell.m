//
//  TitleRImageMoreCell.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-9-3.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#define kTitleRImageMoreCell_HeightIcon 30.0

#import "TitleRImageMoreCell.h"
#import "UIColor+expanded.h"
@interface TitleRImageMoreCell ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *userIconView;
@end
@implementation TitleRImageMoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        self.backgroundColor = kColorTableBG;
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, ([TitleRImageMoreCell cellHeight] -40)/2, 100, 30)];
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.font = [UIFont systemFontOfSize:16];
            _titleLabel.textColor = [UIColor blackColor];
            [self.contentView addSubview:_titleLabel];
        }
        if (!_userIconView) {
            _userIconView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width- kTitleRImageMoreCell_HeightIcon)- 10- 30, 7, kTitleRImageMoreCell_HeightIcon, kTitleRImageMoreCell_HeightIcon)];
            [self doCircleFrame];
            [self.contentView addSubview:_userIconView];
        }
    }
    return self;
}
- (void)doCircleFrame{
    _userIconView.layer.masksToBounds = YES;
    _userIconView.layer.cornerRadius = _userIconView.frame.size.width/2;
    _userIconView.layer.borderWidth = 0.5;
    _userIconView.layer.borderColor = [UIColor colorWithHexString:@"0xdddddd"].CGColor;
}

- (void)setIconImage:(NSString *)iconImage
{
    _iconImage = iconImage;
}
- (void)layoutSubviews{
    [super layoutSubviews];
//    if (!_iconImage)
//    {
//        return;
//    }
    self.titleLabel.text = @"头像";
    [self.userIconView yy_setImageWithURL:[NSURL URLWithString:[User sharedInstance].IconImage] placeholder:[UIImage imageNamed:@"default-gravatar-pic.jpg"]];
    if (self.icIMaegl)
    {
        self.userIconView.image = _icIMaegl;

    }


}
- (void)setIcIMaegl:(UIImage *)icIMaegl
{
    _icIMaegl = icIMaegl;
    
}
+ (CGFloat)cellHeight{
    return 70.0;
}

@end
