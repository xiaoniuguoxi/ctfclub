//
//  CommonViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "CommonViewController.h"
#import "TabViewController.h"
#import "LoginViewController.h"
#import "CommonItemDetailViewController.h"

@interface CommonViewController ()

@property (nonatomic, strong) UIAlertView *logoutAlertView;

@end

@implementation CommonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // initialize the communicator
    self.communicator = [CommunicationProtocol new];
    self.communicator.delegate = self;
    
    // Show navigation bar if pushed from IndexViewController
    if (self.pushedWithNavBar) {
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
    
    // Custom title font
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor whiteColor] }];
    
    // custom back button
    if ([self.navigationController.childViewControllers count] > 1) {
        self.navigationItem.leftBarButtonItem = [CommonUtil barButtonItemFromImageNamed:@"ic_nav_back" target:self selector:@selector(popBack)];
        
        // not to break swipe gesture
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    } else {
        self.navigationItem.leftBarButtonItem = [CommonUtil barButtonItemFromImageNamed:@"ic_nav_home" target:self selector:@selector(popBack)];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadLocalization];
    
    // Reset login/logout button each time when display
    [self updateLoginLogoutButton];
}

- (void)reloadLocalization
{
    if (self.navBarTitleKey) {
        self.navigationItem.title = AMLocalizedString(self.navBarTitleKey, nil);
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)updateLoginLogoutButton
{
    if ([self isKindOfClass:[CommonItemDetailViewController class]]) {
        return;
    }
    
    if ([LoginUtil getCardNumber]) {
        if (self.showLogoutButton) {
            self.navigationItem.rightBarButtonItem = [CommonUtil barButtonItemFromImageNamed:@"ic_nav_logout" target:self selector:@selector(selectLoginLogout)];
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    } else if (self.showLoginButton) {
        self.navigationItem.rightBarButtonItem = [CommonUtil barButtonItemFromImageNamed:@"ic_nav_login" target:self selector:@selector(selectLoginLogout)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)selectLoginLogout
{
    if ([LoginUtil getCardNumber]) {
        self.logoutAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:AMLocalizedString(@"alert_confirm_logout", nil)
                                                       delegate:self
                                              cancelButtonTitle:AMLocalizedString(@"no", nil)
                                              otherButtonTitles:AMLocalizedString(@"yes", nil), nil];
        [self.logoutAlertView show];
    } else {
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.logoutAlertView) {
        if (buttonIndex == 1) {
            [self logoutAndClear];
        }
    }
}

- (void)logoutAndClear
{
    // logout (clear user account)
    [LoginUtil deletePassword];
    [LoginUtil getInstance].detail = nil;
    [self updateLoginLogoutButton];
    
    TabViewController *tabVC = (TabViewController *)self.navigationController.parentViewController;
    if (tabVC.currentTabIndex == 0) {
        [tabVC restartCurrentVC];
    }
}

- (void)initFormWithDetail
{
    // implement in subclass
}

- (void)popBack
{
    if ([self.navigationController.childViewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        TabViewController *tabVC = (TabViewController *)self.navigationController.parentViewController;
        if (tabVC != nil) {
            [tabVC dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleError:(NSDictionary *)jsonObject
{
    [self.communicator stopIndicator];
    
    NSString * error = nil;
    if ([jsonObject[ERROR] isKindOfClass:[NSArray class]]) {
        error = [jsonObject[ERROR] componentsJoinedByString:@"\n"];
    } else if ([jsonObject[ERROR] isKindOfClass:[NSString class]]) {
        error = jsonObject[ERROR];
    }
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"error", nil)
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:AMLocalizedString(@"ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Reset login detail if it is a login failure
    NSString *tag = jsonObject[TAG];
    if ([tag isEqualToString:ROUTE_LOGIN_CHECK]) {
        [self logoutAndClear];
    }
}

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [self.communicator stopIndicator];
    
    NSString *tag = jsonObject[TAG];
    
    if ([tag isEqualToString:ROUTE_LOGIN_CHECK]) {
        NSDictionary *detail = jsonObject[DETAIL];
        [LoginUtil getInstance].detail = detail;
        [self initFormWithDetail];
    }
    
    // implement in subclass
}

#pragma mark - UIWebView delegate

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
