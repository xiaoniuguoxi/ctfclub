//
//  CTFNavC.m
//  CTF-VIP-iOS
//
//  Created by HughChiu on 2019/7/12.
//  Copyright © 2019 ctf. All rights reserved.
//

#import "CTFNavC.h"
#import "CTFDefine.h"
#import "UIView+Frame.h"
#import "CTFSliderVC.h"

@interface CTFNavC ()

@end

@implementation CTFNavC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, SCREEN.width, 64 + kApplicationStatusBarHeight);
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, SCREEN.width, 64 + kApplicationStatusBarHeight);
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIImageView *navIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, topView.width, topView.height)];
    navIV.image = [UIImage imageNamed:@"ctf_nav_bar_background"];
    [topView addSubview:navIV];
    
    UIImageView *iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 57)];
    iconIV.center = CGPointMake(topView.width / 2, kApplicationStatusBarHeight + 26);
    iconIV.image = [UIImage imageNamed:@"ctf_ic_ctf_icon"];
    [topView addSubview:iconIV];
    
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(10, kApplicationStatusBarHeight + 8, 20, 20);
//    backBtn.backgroundColor = [UIColor whiteColor];
    [backBtn setImage:[UIImage imageNamed:@"ctf_ic_nav_home"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navBackAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UIButton *userBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 32)];
    userBtn.center = CGPointMake(SCREEN.width - 26, kApplicationStatusBarHeight + 22);
    [userBtn setImage:[UIImage imageNamed:@"ctf_ic_nav_login"] forState:UIControlStateNormal];
    [topView addSubview:userBtn];
}

- (void)navBackAction:(UIButton *)sender {
    [[CTFSliderVC sharedSliderController] leftItemClick];
}

@end
