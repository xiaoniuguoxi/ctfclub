//
//  CTFWebVC.m
//  CTF-VIP-iOS
//
//  Created by Beeba on 2019/7/13.
//  Copyright © 2019年 ctf. All rights reserved.
//

#import "CTFWebVC.h"
#import "CTFDefine.h"


@interface CTFWebVC ()
{
    UIWebView *webV;
}
@end

@implementation CTFWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN.width, SCREEN.height - 64 - kApplicationStatusBarHeight)];
    if (self.shouldFit) {
        webV.scalesPageToFit = YES;
        webV.opaque = NO;
    }
    webV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webV];
    
    NSURL *url = [NSURL URLWithString:self.webUrl];
    NSURLRequest *webRequest = [[NSURLRequest alloc] initWithURL:url];
    [webV loadRequest:webRequest];
    
}


@end
