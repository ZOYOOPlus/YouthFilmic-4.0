//
//  ActivitiesCell.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/13.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "ActivitiesCell.h"
@interface ActivitiesCell ()
@property (weak, nonatomic) IBOutlet UIImageView *ActivityImage;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

@end
@implementation ActivitiesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSingleAc:(Activity *)singleAc
{
    _singleAc = singleAc;
//    _ActivityImage.yy_imageURL = [NSURL URLWithString:self.singleAc.thumb];
    NSString *urlStr = [NSString stringWithFormat:@"%@?imageView2/1/w/750/h/400",self.singleAc.thumb];
//    NSLog(@"图片显示Bug%@",urlStr);
 
    [_ActivityImage yy_setImageWithURL:[NSURL URLWithString:urlStr] options:YYWebImageOptionProgressiveBlur| YYWebImageOptionSetImageWithFadeAnimation];
    _describeLabel.text = self.singleAc.title;
     
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
