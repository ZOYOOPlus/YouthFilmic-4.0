//
//  ddWebViewController.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/19.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "ddWebViewController.h"
#import "WebViewJavascriptBridge.h"
@interface ddWebViewController ()<UIWebViewDelegate>
{
    float _progressNum;
    NSTimer *_progressTimer;
}

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property WebViewJavascriptBridge *brige;

@end

@implementation ddWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackNaviButton];
    
    self.title = @"原文内容";
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(pressBackBtn:)];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
    
    _progressView.hidden = YES;
//    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:webView];
    
    [WebViewJavascriptBridge enableLogging];
    
    self.brige = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    
    [self.brige registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"薛燕子testObjcCallback called: %@", data);
        responseCallback(@"高刘备Response from testObjcCallback");
    }];
    
    [self.brige callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
    [_webView loadRequest: request];
    
    

    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    if (self.brige) { return; }
    
    
    
 }

- (void)pressBackBtn:(id)sender
{
    if (_webView.canGoBack)
    {
        [_webView goBack];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _progressNum = 0.2;
    [_progressView setProgress:_progressNum animated:NO];
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(handleNumberTimer:) userInfo:nil repeats:YES];
    _progressView.hidden = NO;
    
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = theTitle;

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _progressView.hidden = YES;
    if (_progressTimer)
    {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _progressView.hidden = YES;
    if (_progressTimer)
    {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
}

- (void)handleNumberTimer:(id)sender
{
    _progressNum += 0.01;
    
    if (_progressNum < 0.8)
    {
        [_progressView setProgress:_progressNum animated:YES];
    }
    
    if (_progressNum >= 1.5) {
        [_progressTimer invalidate];
        _progressTimer = nil;
        _progressView.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
