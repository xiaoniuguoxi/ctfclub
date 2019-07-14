//
//  CommonViewController.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationProtocol.h"
#import "ColorAndStyle.h"
#import "CommonUtil.h"
#import "LoginUtil.h"
#import "HtmlUtil.h"
#import "LocalizationSystem.h"
#import "UserDefaultsUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CommonViewController : UIViewController <CommunicatorProtocolDelegate, UIWebViewDelegate>

@property (nonatomic, strong) CommunicationProtocol *communicator;

@property (nonatomic, copy) NSString *navBarTitleKey;
@property (nonatomic, assign) BOOL pushedWithNavBar;
@property (nonatomic, assign) BOOL showLoginButton;
@property (nonatomic, assign) BOOL showLogoutButton;

- (void)reloadLocalization;

- (void)selectLoginLogout;

- (void)logoutAndClear;

- (void)initFormWithDetail;

- (void)popBack;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
