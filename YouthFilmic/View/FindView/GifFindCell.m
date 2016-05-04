//
//  GifFindCell.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/19.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "GifFindCell.h"
@interface GifFindCell()
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gifImageview;
@property (weak, nonatomic) IBOutlet UILabel *contenLabel;

@end
@implementation GifFindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _gifImageview.userInteractionEnabled = YES;
    // Initialization code
}
- (void)setLife:(findLife *)life
{
    _life = life;
    NSString *urlStr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/200",self.life.thumb];

    _gifImageview.yy_imageURL = [NSURL URLWithString:urlStr];
    self.contenLabel.text = self.life.title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
