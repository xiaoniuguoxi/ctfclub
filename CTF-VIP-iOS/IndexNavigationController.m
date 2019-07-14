//
//  IndexNavigationController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 13/11/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "IndexNavigationController.h"

//Hugh
#import "CTFDefine.h"
#import "UIView+Frame.h"

@interface IndexNavigationController ()

@end

@implementation IndexNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Hugh
//    UIView *topView = [[UIView alloc] init];
//    topView.frame = CGRectMake(0, 0, SCREEN.width, 64 + kApplicationStatusBarHeight);
//    topView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:topView];
//    
//    UIImageView *navIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, topView.width, topView.height)];
//    navIV.image = [UIImage imageNamed:@"ctf_nav_bar_background"];
//    [topView addSubview:navIV];
//    
//    UIImageView *iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 57)];
//    iconIV.center = CGPointMake(topView.width / 2, kApplicationStatusBarHeight + 26);
//    iconIV.image = [UIImage imageNamed:@"ctf_ic_ctf_icon"];
//    [topView addSubview:iconIV];
//    
//    UIButton *backBtn = [[UIButton alloc] init];
//    backBtn.frame = CGRectMake(8, kApplicationStatusBarHeight + 8, 20, 20);
//    backBtn.backgroundColor = [UIColor whiteColor];
//    [backBtn addTarget:self action:@selector(navBackAction:) forControlEvents:UIControlEventTouchUpInside];
//    [topView addSubview:backBtn];
//    
//    UIButton *userBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 32)];
//    userBtn.center = CGPointMake(SCREEN.width - 26, kApplicationStatusBarHeight + 22);
//    [userBtn setImage:[UIImage imageNamed:@"ctf_ic_nav_login"] forState:UIControlStateNormal];
//    [topView addSubview:userBtn];
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

//Hugh
- (void)navBackAction:(UIButton *)sender {
    [self popViewControllerAnimated:YES];
}

@end
