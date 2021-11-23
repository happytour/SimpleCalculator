//
//  AppDelegate.m
//  SimpleCalculator
//
//  Created by laole918 on 2021/11/21.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <LYAdSDK/LYAdSDK.h>

@interface AppDelegate () <LYSplashAdDelegate>

@property (nonatomic, strong) ViewController *rootController;
@property (nonatomic, strong) LYSplashAd * splashAd;
@property (nonatomic, assign) NSTimeInterval lastActiveTime;
@property (nonatomic, assign) BOOL didEnterBackground;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor grayColor];
    self.rootController = [[ViewController alloc] init];
    self.window.rootViewController = self.rootController;
    [self.window makeKeyAndVisible];
    
    [LYAdSDKConfig initAppId:@"11037255"];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    CGRect splashFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.splashAd = [[LYSplashAd alloc] initWithFrame:splashFrame slotId:@"31036636" viewController:self.rootController];
    self.splashAd.delegate = self;
    [self.splashAd loadAd];
    
    self.lastActiveTime = [[NSDate date] timeIntervalSince1970];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.didEnterBackground = YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    //指定一个最小展示间隔
    if (time - self.lastActiveTime >= 60 && self.didEnterBackground) {
        self.lastActiveTime = time;
        [self.splashAd loadAd];
    }
    self.didEnterBackground = NO;
}

#pragma mark - LYSplashAdDelegate

- (void)ly_splashAdDidLoad:(LYSplashAd *)splashAd {
    UIWindow *mainWindow = nil;
    if (@available(iOS 13.0, *)) {
        mainWindow = [UIApplication sharedApplication].windows.firstObject;
    } else {
        mainWindow = [UIApplication sharedApplication].keyWindow;
    }
    [self.splashAd showAdInWindow:mainWindow];
}

- (void)ly_splashAdDidFailToLoad:(LYSplashAd *)splashAd error:(NSError *)error {
    
}

- (void)ly_splashAdDidExpose:(LYSplashAd *)splashAd {
    
}

- (void)ly_splashAdDidClick:(LYSplashAd *)splashAd {
    
}

- (void)ly_splashAdDidClose:(LYSplashAd *)splashAd {
    
}

- (void)ly_splashAdLifeTime:(LYSplashAd *)splashAd time:(NSUInteger)time {
    
}

- (void)ly_splashAdDidCloseOtherController:(LYSplashAd *)splashAd {

}


@end
