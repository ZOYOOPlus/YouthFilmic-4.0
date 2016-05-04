//
//  FrendListCell.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/26.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "FrendListCell.h"
@interface FrendListCell()
@property (weak, nonatomic) IBOutlet UILabel *CoverName;
@end
@implementation FrendListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setMeR:(Mesages *)meR
{
    _meR = meR;
    self.CoverName.text = _meR.name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
