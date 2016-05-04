//
//  XiugaiViewController.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/21.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "XiugaiViewController.h"
#import "TitleValueMoreCell.h"
#import "TitleRImageMoreCell.h"
#import "Masonry.h"
#import "User.h"
#import "UITableView+Common.h"
#import "ActionSheetStringPicker.h"
#import "SettingTextViewController.h"
#import <QiniuSDK.h>
#import "HXTools.h"
#import "MBProgressHUD+MJ.h"
#import "LogViewController.h"
@import AVFoundation;

@interface XiugaiViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImage *editedImage;
    NSString *_imageUrl;

    
}

@property (strong, nonatomic) UITableView *myTableView;
@end

@implementation XiugaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self setLeftNaviButtonWithString:@"返回"];

    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//        tableView.backgroundColor = kColorTableSectionBg;
        tableView.dataSource = self;
        tableView.rowHeight = 44;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[TitleValueMoreCell class] forCellReuseIdentifier:kCellIdentifier_TitleValueMore];
        [tableView registerClass:[TitleRImageMoreCell class] forCellReuseIdentifier:kCellIdentifier_TitleRImageMore];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tableView.tableFooterView = [self customFootView];
        tableView;
    });

    // Do any additional setup after loading the view.
}

#pragma mark tableViewDelegate  tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        TitleRImageMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TitleRImageMore forIndexPath:indexPath];
        cell.iconImage = [User sharedInstance].IconImage;
        if (editedImage)
        {
            cell.icIMaegl = editedImage;
        }
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:10];
        

         return cell;
 
    }
    else
    {
        TitleValueMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TitleValueMore forIndexPath:indexPath];

        switch (indexPath.row) {
            case 1:
            {
                [cell setTitleStr:@"昵称" valueStr:[User sharedInstance].nick_name];
            }
                break;
            case 2:
            {
                
                 [cell setTitleStr:@"性别" valueStr:[User sharedInstance].sex];


            }
                break;
            case 3:
            {
            
//            [cell setTitleStr:@"职位" valueStr:@""];
 
            }
                break;

                
            default:
                break;
        }
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:10];

        return cell;
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak typeof(self) weakSelf = self;

    switch (indexPath.row) {
        case 0:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
            [actionSheet showInView:self.view];

        }
            break;
        case 1:
        {
            
            SettingTextViewController *vc = [SettingTextViewController settingTextVCWithTitle:@"昵称" textValue:[User sharedInstance].nick_name doneBlock:^(NSString *textValue) {
                
                [User sharedInstance].nick_name = textValue;
                [self.myTableView reloadData];
                
            }];
            [self.navigationController pushViewController:vc animated:YES]; 
        }
            break;

        case 2:
        {
            
            NSNumber *nun = [ [User sharedInstance].sex isEqualToString:@"男"]?@1:@0;
            [ActionSheetStringPicker showPickerWithTitle:nil rows:@[@[@"男",@"女"]] initialSelection:@[nun] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
                NSNumber *num = [selectedIndex firstObject];
                [User sharedInstance].sex = ([num  isEqual: @0]?@"男":@"女");
                [weakSelf.myTableView reloadData];
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:self.view];
            
         }
            break;

        case 3:
        {
            SettingTextViewController *vc = [SettingTextViewController settingTextVCWithTitle:@"" textValue:[User sharedInstance].nick_name doneBlock:^(NSString *textValue) {
                
                [User sharedInstance].nick_name = textValue;
                [self.myTableView reloadData];
                
            }];
            [self.navigationController pushViewController:vc animated:YES];
 
        }
            break;

            
        default:
            break;
    }
                                             
    
}

#pragma mark UIActionSheetDelegate M
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    
    if (buttonIndex == 0) {
        //        拍照
        if (![self checkCameraAuthorizationStatus]) {
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (buttonIndex == 1){
        //        相册
        if (![self checkCameraAuthorizationStatus]) {
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *originalImage;
        editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        __weak typeof(self) weakSelf = self;
        NSData *data;
        if (UIImagePNGRepresentation(editedImage) == nil) {
            
            data = UIImageJPEGRepresentation(editedImage, 1);
            
        } else {
            
            data = UIImagePNGRepresentation(editedImage);
        }
        
        [[NetworkSingleton sharedManager]getQiniuTokenAndKeysuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
//            NSDictionary *dic = [HXTools jsonStringToObject:operation.responseString];
//            NSLog(@"哈哈%@",operation.responseString);
            
            NSLog(@"七牛token%@",responseObject);
            
            
            NSDictionary *dic = (NSDictionary*)responseObject;
            NSNumber *code = dic[@"code"];
            if ([code isEqual:@000004 ])
            {
                [self showToast:@"由于长时间未操作，请重新登录"];
                LogViewController *logView = [[LogViewController alloc]init];
                [self presentViewController:logView animated:YES completion:^{
                    
                }];
                
                return;
  
            }
            NSDictionary *dataDic = dic[@"data"];
            NSDictionary *tokeDic = dataDic[@"token"];
            NSString *token = tokeDic[@"token"];
            NSString *key = tokeDic[@"key"];
            NSString *demon = tokeDic[@"domain"];
            key = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self showLoading];
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            [upManager putData:data key:key token:token
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          NSLog(@"七牛怎么了%@",info);
                          _imageUrl = [NSString stringWithFormat:@"%@%@",demon,key];
                          
                    [weakSelf.myTableView reloadData];
                          [self hideLoading];
                          [self showToast:@"照片上传成功"];

                      } option:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSString *code) {
            [self showToast:@"有点小问题，请稍后重试"];
        }];
        
 
         // 保存原图片到相册中
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)checkCameraAuthorizationStatus
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showToast:@"该设备不支持拍照"];
         return NO;
    }
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [self showToast:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"];
 
            return NO;
        }
    }
    
    return YES;
}


- (UIView *)customFootView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 100)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, kScreen_Width-20, 30)];
    [btn setTitle:@"保存资料" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:67/255.0 green:155/255.0 blue:247/255.0 alpha:1];
    [btn addTarget:self action:@selector(btnclik) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    return footView;
    
}

- (void)btnclik
{
  
    NSLog(@"修改个人资料是嘛情况");
    [MBProgressHUD showMessage:@"正在保存资料" toView:self.view];
    
    if ([User sharedInstance].nick_name.length < 1)
    {
        [self showToast:@"请输入昵称"];
        return;
    }
    NSString *sex = [ [User sharedInstance].sex isEqualToString:@"男"]?@"1":@"0";
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[User sharedInstance].UserToken,@"token",[User sharedInstance].nick_name,@"nick_name",sex,@"sex",_imageUrl,@"pic", nil];
    [[NetworkSingleton sharedManager]updateUserInfor:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [MBProgressHUD hideHUD];
        
        NSLog(@"更改成功%@",responseObject);
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSString *code) {
        [MBProgressHUD hideHUD];

        [self showToast:@"有点小问题，请稍后重试"];
    }];
    
    
}

- (void)tapNaviLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
