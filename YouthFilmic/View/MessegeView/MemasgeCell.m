//
//  MemasgeCell.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/26.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "MemasgeCell.h"
#import "User.h"
@interface MemasgeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;
@property (weak, nonatomic) IBOutlet UILabel *contenLabel;

@end


@implementation MemasgeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
- (void)setObj:(NSManagedObject *)obj
{
    _obj = obj;
    self.contenLabel.text = [obj valueForKey:@"content"];
    UIImage *normal;
    normal = [UIImage imageNamed:@"chatto_bg_normal"];
    normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
    self.backGroundImage.image = normal;
    if ([User sharedInstance].IconImage)
    {
        _iconImage.yy_imageURL = [NSURL URLWithString:[User sharedInstance].IconImage];
    }
    else
    {
        _iconImage.image = [UIImage imageNamed:@"default-gravatar-pic.jpg"];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
