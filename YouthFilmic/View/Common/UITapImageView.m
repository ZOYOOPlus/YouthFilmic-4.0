//
//  UITapImageView.m
//  Created by 高刘备 on 16/3/1.
//  Copyright © 2016年 谷武科技. All rights reserved.

//

#import "UITapImageView.h"
@interface  UITapImageView ()

@property (nonatomic, copy) void(^tapAction)(id);

@end

@implementation UITapImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)tap{
    if (self.tapAction) {
        self.tapAction(self);
    }
}
- (void)addTapBlock:(void(^)(id obj))tapAction{
    self.tapAction = tapAction;
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}

-(void)setImageWithUrl:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void(^)(id obj))tapAction{
    self.image = placeholderImage;
    self.yy_imageURL = imgUrl;
    [self addTapBlock:tapAction];
}

@end
