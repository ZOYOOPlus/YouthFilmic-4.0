//
//  RxWebViewController.h
//  RxWebViewController
//
//  Created by roxasora on 15/10/23.
//  Copyright © 2015年 roxasora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RxWebViewController : UIViewController

/**
 *  origin url
 */
@property (nonatomic)NSURL* url;
@property(nonatomic , strong)NSString *strUrl;
@property(nonatomic, strong)NSString  *sharetitle;
/**
 *  embed webView
 */
@property (nonatomic)UIWebView* webView;

/**
 *  tint color of progress view
 */
@property (nonatomic)UIColor* progressViewColor;

//@property (nonatomic,copy)NSString *comeF;
/**
 *  get instance with url
 *
 *  @param url url
 *
 *  @return instance
 */

@property (nonatomic,copy)NSString *indentifire;
-(instancetype)initWithUrl:(NSURL*)url;


-(void)reloadWebView;



@end



