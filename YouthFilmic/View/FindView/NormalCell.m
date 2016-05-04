//
//  NormalCell.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/19.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "NormalCell.h"
@interface NormalCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation NormalCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}


- (void)setLife:(findLife *)life
{
    _life = life;
    NSString *urlStr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/200",self.life.thumb];

    [_articleImage yy_setImageWithURL:[NSURL URLWithString:urlStr] options:YYWebImageOptionProgressiveBlur| YYWebImageOptionSetImageWithFadeAnimation];
    self.contentLabel.text = self.life.title;
    self.likeCount.text = [NSString stringWithFormat:@"%ld",self.life.like_count];
    self.commentLabel.text = [NSString stringWithFormat:@"%ld",self.life.comment_count];
    self.timeLabel.text = self.life.human_time;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
