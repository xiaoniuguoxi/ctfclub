//
//  LoginViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 2/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "LoginViewController.h"
#import "TabViewController.h"
#import "ForgotPasswordViewController.h"
#import "LoginUtil.h"
#import "FirstTimeRegViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *loginInstructionLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UILabel *downloadTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadInstructionLabel;
@property (weak, nonatomic) IBOutlet UIButton *pdf2Button;
@property (weak, nonatomic) IBOutlet UIButton *pdf1Button;

@property (nonatomic, copy) NSString *hashPassword;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarTitleKey = @"title_login";
}

- (void)reloadLocalization
{
    [super reloadLocalization];
    
    self.cardNumberLabel.text = AMLocalizedString(@"login_form_card_number", nil);
    self.passwordLabel.text = AMLocalizedString(@"login_form_password", nil);
    self.loginInstructionLabel.text = AMLocalizedString(@"login_form_instruction", nil);
    
    [self.loginButton setTitle:AMLocalizedString(@"login_form_login", nil) forState:UIControlStateNormal];
    [self.forgotPasswordButton setTitle:AMLocalizedString(@"login_form_forgot_password", nil) forState:UIControlStateNormal];
    
    self.downloadTitleLabel.text = AMLocalizedString(@"login_download_zone", nil);
    self.downloadInstructionLabel.text = AMLocalizedString(@"login_download_instruction", nil);
    
    [self.pdf2Button setTitle:AMLocalizedString(@"login_download_pdf2", nil) forState:UIControlStateNormal];
    [self.pdf1Button setTitle:AMLocalizedString(@"login_download_pdf1", nil) forState:UIControlStateNormal];
}

- (IBAction)selectLogin:(id)sender
{
    [self.communicator startIndicator];
    
    // Prepare API request
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:self.cardNumberTextField.text forKey:CARD_NUMBER];
    
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_LOGIN_SALT] isPost:YES parameters:parameters tag:ROUTE_LOGIN_SALT];
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleError:(NSDictionary *)jsonObject
{
    [self.communicator stopIndicator];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"error", nil)
                                                    message:AMLocalizedString(@"error_login_failed", nil)
                                                   delegate:nil
                                          cancelButtonTitle:AMLocalizedString(@"ok", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)handleResponse:(NSDictionary *)jsonObject
{
    // override the whole parent class
    
    [self.communicator stopIndicator];
    
    NSString *tag = jsonObject[TAG];
    
    if ([tag isEqualToString:ROUTE_LOGIN_SALT]) {
        NSString *salt = jsonObject[SALT];
        
        if (salt && salt.length > 0) {
            self.hashPassword = [LoginUtil encryptPassword:self.passwordTextField.text bySalt:salt];
            
            [self.communicator startIndicator];
            
            // Prepare API request
            NSMutableDictionary *parameters = [NSMutableDictionary new];
            [parameters setValue:self.cardNumberTextField.text forKey:CARD_NUMBER];
            [parameters setValue:self.hashPassword forKey:HASH];
            
            [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_LOGIN_CHECK] isPost:YES parameters:parameters tag:ROUTE_LOGIN_CHECK];
        }
        
    } else if ([tag isEqualToString:ROUTE_LOGIN_CHECK]) {
        NSDictionary *detail = jsonObject[DETAIL];
        [LoginUtil getInstance].detail = detail;
        NSString *customerId = [NSString stringWithFormat:@"%@", detail[LOGIN_CUSTOMER_ID]];
        [LoginUtil setPassword:self.hashPassword cardNumber:self.cardNumberTextField.text customerId:customerId];
        
        UIViewController *parentVC = self.navigationController.parentViewController;
        if ([parentVC isKindOfClass:[TabViewController class]]) {
            TabViewController *tabVC = (TabViewController *) parentVC;
            if (tabVC.currentTabIndex == 0) {
                [tabVC restartCurrentVC];
            } else {
                [self popBack];
            }
        } else {
            [self popBack];
        }
        
        // Show first time reg form if the flag is true
        bool flag = [jsonObject[NEED_FINISH_ADDRESS] boolValue];
        if (flag) {
            FirstTimeRegViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstTimeRegViewController"];
            
            if ([parentVC isKindOfClass:[TabViewController class]]) {
                vc.tabViewController = (TabViewController *) parentVC;
                [parentVC presentViewController:vc animated:YES completion:nil];
            } else {
                [self presentViewController:vc animated:YES completion:nil];
            }
            
        }
    }
}

- (IBAction)selectForgotPassword:(id)sender
{
    ForgotPasswordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)selectPdf2:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PDF2_URL]];
}

- (IBAction)selectPdf1:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PDF1_URL]];
}

@end
