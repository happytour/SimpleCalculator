//
//  ViewController.m
//  SimpleCalculator
//
//  Created by laole918 on 2021/11/21.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    //
    //    NSString * headJs = @"window.statusHeight=%f;";
    //    headJs = [NSString stringWithFormat:headJs, statusHeight];
    //    WKUserScript *headScript = [[WKUserScript alloc] initWithSource:headJs injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        WKUserScript *logScript = [[WKUserScript alloc] initWithSource:@"var console={};console.log=function(){for(var i=0;i<arguments.length;i++){window.webkit.messageHandlers['logger'].postMessage(JSON.stringify(arguments[i]))}};" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        WKWebViewConfiguration * webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        [userContentController addUserScript:logScript];
    //    [userContentController addUserScript:headScript];
        [userContentController addScriptMessageHandler:self name:@"logger"];
        webViewConfiguration.userContentController = userContentController;
        webViewConfiguration.selectionGranularity = YES;
        
    //    webViewConfiguration.websiteDataStore = [WKWebsiteDataStore defaultDataStore];
        
        
        self.webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) configuration:webViewConfiguration];
        [self.view addSubview:self.webview];
        
        self.webview.backgroundColor = UIColor.redColor;
        
        [self.webview setAllowsBackForwardNavigationGestures:true];
        
        self.webview.scrollView.alwaysBounceVertical = YES;
        self.webview.scrollView.showsHorizontalScrollIndicator = NO;
        self.webview.scrollView.bouncesZoom = NO;
        self.webview.navigationDelegate = self;
        self.webview.UIDelegate = self;
        
        if (@available(iOS 11.0, *)) {
            self.webview.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"Assets/www/SimpleCalculator"];
        NSURL * pathURL = [NSURL fileURLWithPath:filePath];
        [self.webview loadFileURL:pathURL allowingReadAccessToURL:pathURL];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([@"logger" compare: message.name] == NSOrderedSame) {
        NSLog(@"console: %@", message.body);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    NSLog(@"url: %@", url);
    NSString *urlString = (url) ? url.absoluteString : @"";
    // iTunes: App Store link
    //For example, wechat download link: https://itunes.apple.com/cn/app/id414478124? MT = 8
    if ([urlString containsString:@"//itunes.apple.com/"]) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    // Protocol/URL-Scheme without http(s),file
    else if (url.scheme && ![url.scheme hasPrefix:@"http"] && ![url.scheme hasPrefix:@"file"]) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

//是否旋转
-(BOOL)shouldAutorotate {
    return NO;
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
//viewController初始显示的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
