//
//  WebViewController.m
//  ADLaunchDemo
//
//  Created by BOOM on 16/10/11.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()

//@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WebViewController

- (void)dealloc
{
    NSLog(@"Dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Hi, I am Devil";
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.cocoachina.com/ios/20160621/16764.html"]]];
    
    [self.view addSubview:self.webView];
}

@end

@implementation UIViewController (NAV)

- (UINavigationController *)my_navigationController
{
    UINavigationController *nav = nil;
    if ([self isKindOfClass:[UINavigationController class]])
    {
        nav = (id)self;
    }
    else if ([self isKindOfClass:[UITabBarController class]])
    {
        nav = [((UITabBarController *)self).selectedViewController my_navigationController];
    }
    else
    {
        nav = self.navigationController;
    }
    
    return nav;
}

@end
