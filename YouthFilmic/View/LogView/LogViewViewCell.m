//
//  LogViewViewCell.m

//
//  Created by 高刘备 on 16/4/17.
//  Copyright © 2016年 Coding. All rights reserved.
//
#define kCellIdentifier_Input_OnlyText_Cell_PhoneCode_Prefix @"Input_OnlyText_Cell_PhoneCode"
#import "LogViewViewCell.h"
#import "Masonry.h"
#import "UIColor+expanded.h"
@interface LogViewViewCell()
@property (strong, nonatomic) UIButton *clearBtn, *passwordBtn;
@property (strong, nonatomic) UIView *lineView;
@end
@implementation LogViewViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_textField)
        {
            _textField = [UITextField new];
            [_textField setFont:[UIFont systemFontOfSize:17]];
            [_textField addTarget:self action:@selector(editDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
            [_textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
            [_textField addTarget:self action:@selector(editDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
            [self.contentView addSubview:_textField];
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(20);
                make.left.equalTo(self.contentView).offset(10);
                make.right.equalTo(self.contentView).offset(-10);
                make.centerY.equalTo(self.contentView);
            }];
        }
        if ([reuseIdentifier isEqualToString:kCellIdentifier_Input_OnlyText_Cell_Text])
        {
            
        }
        else if ([reuseIdentifier isEqualToString:kCellIdentifier_Input_OnlyText_Cell_Password])
        {
            _textField.secureTextEntry = YES;
            
            _passwordBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 44- 10, 0, 44, 44)];
            [_passwordBtn setImage:[UIImage imageNamed:@"password_unlook"] forState:UIControlStateNormal];
            [_passwordBtn addTarget:self action:@selector(passwordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_passwordBtn];
 
        }
        else if ([reuseIdentifier hasPrefix:kCellIdentifier_Input_OnlyText_Cell_PhoneCode_Prefix]){
            if (!_verify_codeBtn) {
                _verify_codeBtn = [[PhoneCodeButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80 - 10, (44-25)/2, 80, 25)];
                [_verify_codeBtn addTarget:self action:@selector(phoneCodeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:_verify_codeBtn];
            }
        }


        
    }
    return self;
}
- (void)prepareForReuse{
    self.isForLoginVC = NO;
    if (![self.reuseIdentifier isEqualToString:kCellIdentifier_Input_OnlyText_Cell_Password]) {
        self.textField.secureTextEntry = NO;
    }
    self.textField.userInteractionEnabled = YES;
    self.textField.keyboardType = UIKeyboardTypeDefault;
    
    self.editDidBeginBlock = nil;
    self.textValueChangedBlock = nil;
    self.editDidEndBlock = nil;
    self.phoneCodeBtnClckedBlock = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_clearBtn) {
        _clearBtn = [UIButton new];
        _clearBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_clearBtn setImage:[UIImage imageNamed:@"text_clear_btn"] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_clearBtn];
        [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.contentView);
        }];
    }

    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"0xffffff" andAlpha:0.5];
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView);
        }];
    }
    self.backgroundColor = [UIColor whiteColor];
    self.textField.clearButtonMode =  UITextFieldViewModeNever;
    self.textField.textColor = [UIColor blackColor];
    self.lineView.hidden = NO;
    self.clearBtn.hidden = YES;
    [self.textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
//    self.textField.tintColor = [UIColor lightGrayColor];
    
    UIView *rightElement;
    if ([self.reuseIdentifier isEqualToString:kCellIdentifier_Input_OnlyText_Cell_Text]) {
        rightElement = nil;
    }else if ([self.reuseIdentifier isEqualToString:kCellIdentifier_Input_OnlyText_Cell_Password]){
        rightElement = _passwordBtn;
    }else if ([self.reuseIdentifier hasPrefix:kCellIdentifier_Input_OnlyText_Cell_PhoneCode_Prefix]){
        rightElement = _verify_codeBtn;
    }



    [_clearBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat offset = rightElement? (CGRectGetMinX(rightElement.frame) - [UIScreen mainScreen].bounds.size.width - 10): -10;
        make.right.equalTo(self.contentView).offset(offset);
    }];
    
    [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat offset = rightElement? (CGRectGetMinX(rightElement.frame) - [UIScreen mainScreen].bounds.size.width - 10): -10;
        offset -= self.isForLoginVC? 30: 0;
        make.right.equalTo(self.contentView).offset(offset);
    }];

}

#pragma password
- (void)passwordBtnClicked:(UIButton *)button{
    _textField.secureTextEntry = !_textField.secureTextEntry;
    [button setImage:[UIImage imageNamed:_textField.secureTextEntry? @"password_unlook": @"password_look"] forState:UIControlStateNormal];
}

- (void)clearBtnClicked:(id)sender {
    self.textField.text = @"";
    [self textValueChanged:nil];
}

- (void)phoneCodeButtonClicked:(id)sender{
    if (self.phoneCodeBtnClckedBlock) {
        self.phoneCodeBtnClckedBlock(sender);
    }
}

#pragma mark TextField
- (void)editDidBegin:(id)sender {
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"0xffffff"];
    self.clearBtn.hidden = self.textField.text.length <= 0;
    
    if (self.editDidBeginBlock) {
        self.editDidBeginBlock(self.textField.text);
    }
}

- (void)editDidEnd:(id)sender {
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"0xffffff" andAlpha:0.5];
    self.clearBtn.hidden = YES;
    
    if (self.editDidEndBlock) {
        self.editDidEndBlock(self.textField.text);
    }
}

- (void)textValueChanged:(id)sender {
    self.clearBtn.hidden =  self.textField.text.length <= 0;
   
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(self.textField.text);
    }
}
- (void)setPlaceholder:(NSString *)phStr value:(NSString *)valueStr{
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:phStr? phStr: @"" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
     self.textField.text = valueStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
