//
//  RestPasswordViewController.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/15.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "RestPasswordViewController.h"

@interface RestPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTf;
@property (weak, nonatomic) IBOutlet UITextField *yanPassTf;
@property (weak, nonatomic) IBOutlet UITextField *passWordTf;

@end

@implementation RestPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)yanPasswordClick:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
