//
//  ChangePasswordViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 10/11/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *oldPasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *updatePasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *updatePasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *confirmPasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (nonatomic, copy) NSString *hashPassword;
@property (nonatomic, strong) UIAlertView *resultAlert;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)reloadLocalization
{
    [super reloadLocalization];
    
    self.oldPasswordLabel.text = AMLocalizedString(@"change_password_old_password", nil);
    self.updatePasswordLabel.text = AMLocalizedString(@"change_password_new_password", nil);
    self.confirmPasswordLabel.text = AMLocalizedString(@"change_password_confirm_password", nil);
    
    [self.submitButton setTitle:AMLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    [self.resetButton setTitle:AMLocalizedString(@"reset", nil) forState:UIControlStateNormal];
}

- (IBAction)selectSubmit:(id)sender
{
    NSString *errorMsg = @"";
    
    if (![LoginUtil isValidPassword:self.updatePasswordTextField.text]) {
        errorMsg = [errorMsg stringByAppendingString:AMLocalizedString(@"change_password_invalid_password_length", nil)];
    }
    
    if (![self.updatePasswordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        errorMsg = [errorMsg stringByAppendingString:AMLocalizedString(@"change_password_mismatch_password", nil)];
    }
    
    if (errorMsg.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error"
                                                        message:errorMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self.communicator startIndicator];
    
    // Prepare API request
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:[LoginUtil getCardNumber] forKey:CARD_NUMBER];
    
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_LOGIN_SALT] isPost:YES parameters:parameters tag:ROUTE_LOGIN_SALT];
}

- (void)handleResponse:(NSDictionary *)jsonObject
{
    // override the whole parent class
    
    [self.communicator stopIndicator];
    
    NSString *tag = jsonObject[TAG];
    
    if ([tag isEqualToString:ROUTE_LOGIN_SALT]) {
        NSString *salt = jsonObject[SALT];
        
        if (salt && salt.length > 0) {
            NSString *oldPassword = [LoginUtil encryptPassword:self.oldPasswordTextField.text bySalt:salt];
            NSString *updatePassword = [LoginUtil encryptPassword:self.updatePasswordTextField.text bySalt:salt];
            NSString *confirmPassword = [LoginUtil encryptPassword:self.confirmPasswordTextField.text bySalt:salt];
            
            self.hashPassword = updatePassword;
            
            [self.communicator startIndicator];
            
            // Prepare API request
            NSMutableDictionary *parameters = [NSMutableDictionary new];
            [parameters setValue:[LoginUtil getCardNumber] forKey:MEMBER_CARD_NUMBER];
            [parameters setValue:oldPassword forKey:@"old_password"];
            [parameters setValue:updatePassword forKey:@"password"];
            [parameters setValue:confirmPassword forKey:@"confirm"];
            
            [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_CHANGE_PASSWORD] isPost:YES parameters:parameters tag:ROUTE_CHANGE_PASSWORD];
        }
        
    } else if ([tag isEqualToString:ROUTE_CHANGE_PASSWORD]) {
        [LoginUtil setPassword:self.hashPassword cardNumber:[LoginUtil getCardNumber]];
        
        self.resultAlert = [[UIAlertView alloc] initWithTitle:nil
                                                      message:AMLocalizedString(@"change_password_success", nil)
                                                     delegate:self
                                            cancelButtonTitle:AMLocalizedString(@"ok", nil)
                                            otherButtonTitles:nil];
        [self.resultAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (alertView == self.resultAlert) {
        [self selectReset:nil];
    }
}

- (IBAction)selectReset:(id)sender
{
    self.oldPasswordTextField.text = nil;
    self.updatePasswordTextField.text = nil;
    self.confirmPasswordTextField.text = nil;
}

@end
