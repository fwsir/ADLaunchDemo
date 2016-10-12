//
//  ADLaunch.m
//  ADLaunchDemo
//
//  Created by BOOM on 16/10/11.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import "ADLaunch.h"
#import "WebViewController.h"

@interface ADLaunch ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) NSInteger downCount;
@property (nonatomic, weak) UIButton *downCountBtn;

@end

@implementation ADLaunch

+ (void)load
{
    [self shareInstance];
}

+ (instancetype)shareInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        // 首次启动
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            
            // 要等DidFinished方法结束后才能出实话UIWindow，不然会监测是否有rootViewController;
            [self _checkAD];
        }];
        
        // 进入后台
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            
            [self _request];
        }];
        
        // 后台启动
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            
            [self _checkAD];
        }];
    }
    
    return self;
}

- (void)_request
{
    // 请求新的数据
}

- (void)_checkAD
{
    // 有广告则显示，无则请求，下次启动再显示
    // 这里当作一直有
    [self _show];
}

- (void)_letGo
{
    UIViewController *rootVC = [[[UIApplication sharedApplication].delegate window]rootViewController];
    [[rootVC my_navigationController] pushViewController:[WebViewController new] animated:YES];
    
    [self _hide];
}

- (void)_show
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = [UIViewController new];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;
    
    // 初始化布局
    [self _setupSubviews:window];
    
    // 置为最顶层
    window.windowLevel = UIWindowLevelAlert + 1;
    window.hidden = NO;
    window.alpha = 1;
    
    self.window = window;
}

- (void)_goOut
{
    
    [self _hide];
}

- (void)_hide
{
    [UIView animateWithDuration:.3 animations:^{
        self.window.alpha = 0;
    } completion:^(BOOL finished) {
        [self.window.subviews.copy enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        self.window.hidden = YES;
        self.window = nil;
    }];
}

- (void)_setupSubviews:(UIWindow *)window
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    imageView.image = [UIImage imageNamed:@"adimage"];
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_letGo)];
    [imageView addGestureRecognizer:tap];
    [window addSubview:imageView];
    
    self.downCount = 3;
    UIButton *goOut = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(window.frame) - 100 - 20, 20, 100, 60)];
    [goOut setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [goOut addTarget:self action:@selector(_goOut) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:goOut];
    
    self.downCountBtn = goOut;
    [self _timer];
}

- (void)_timer
{
    [self.downCountBtn setTitle:[NSString stringWithFormat:@"跳过: %ld", self.downCount] forState:UIControlStateNormal];
    if (self.downCount <= 0)
    {
        [self _hide];
    }
    else
    {
        --self.downCount;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self _timer];
        });
    }
}

@end
