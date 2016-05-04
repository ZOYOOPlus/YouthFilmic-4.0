//
//  UITapImageView.h
//  Coding_iOS
//
//  Created by 高刘备 on 16/3/1.
//  Copyright © 2016年 谷武科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITapImageView : UIImageView
- (void)addTapBlock:(void(^)(id obj))tapAction;

-(void)setImageWithUrl:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void(^)(id obj))tapAction;
@end
