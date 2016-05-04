//
//  LogViewViewCell.h
//
//  Created by 高刘备 on 16/4/17.
//  Copyright © 2016年 Coding. All rights reserved.
//
#define kCellIdentifier_Input_OnlyText_Cell_Text @"Input_OnlyText_Cell_Text"
#define kCellIdentifier_Input_OnlyText_Cell_Password @"Input_OnlyText_Cell_Password"

#import <UIKit/UIKit.h>
#import "UITapImageView.h"
#import "PhoneCodeButton.h"

@interface LogViewViewCell : UITableViewCell
@property (strong, nonatomic, readonly) UITextField *textField;
@property (strong, nonatomic, readonly) PhoneCodeButton *verify_codeBtn;

@property (assign, nonatomic) BOOL isForLoginVC;

@property (nonatomic,copy) void(^textValueChangedBlock)(NSString *);
@property (nonatomic,copy) void(^editDidBeginBlock)(NSString *);
@property (nonatomic,copy) void(^editDidEndBlock)(NSString *);
@property (nonatomic,copy) void(^phoneCodeBtnClckedBlock)(PhoneCodeButton *);

- (void)setPlaceholder:(NSString *)phStr value:(NSString *)valueStr;

@end
