//
//  todayCell.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/19.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "todayCell.h"
@interface todayCell()
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;

@end
@implementation todayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setLife:(findLife *)life
{
    _life = life;
    NSString *urlStr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/200",self.life.thumb];

    [_articleImage yy_setImageWithURL:[NSURL URLWithString:urlStr] options:YYWebImageOptionProgressiveBlur| YYWebImageOptionSetImageWithFadeAnimation];
    _todayLabel.text = self.life.title;

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
