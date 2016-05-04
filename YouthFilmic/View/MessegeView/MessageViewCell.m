//
//  MessageViewCell.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/26.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "MessageViewCell.h"
@interface MessageViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end
@implementation MessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setObj:(NSManagedObject *)obj
{
    _obj = obj;
    self.contentLabel.text = [obj valueForKey:@"content"];
    //背景气泡图
    UIImage *normal;
//         normal = [UIImage imageNamed:@"chatto_bg_normal"];
//        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
        normal = [UIImage imageNamed:@"chatfrom_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
    self.backImage.image = normal;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
