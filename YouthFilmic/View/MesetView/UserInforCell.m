//
//  UserInforCell.m
//  121mai
//
//  Created by 高刘备 on 16/3/5.
//  Copyright © 2016年 谷武科技. All rights reserved.
//

#import "UserInforCell.h"
#import "LBArrowItem.h"
@interface UserInforCell ()
@property (weak, nonatomic) IBOutlet UIImageView *MeimageView;

@property (weak, nonatomic) IBOutlet UILabel *shopLabel;

@end

@implementation UserInforCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setItem:(LBArrowItem *)item
{
    _item= item;
    _MeimageView.image = _item.image;
    _shopLabel.text = _item.title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
