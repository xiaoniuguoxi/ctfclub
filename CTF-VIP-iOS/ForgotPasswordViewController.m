//
//  ForgotPasswordViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 2/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) UIAlertView *resultAlert;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarTitleKey = @"title_forgot_password";
}

- (void)reloadLocalization
{
    [super reloadLocalization];
    
    self.instructionLabel.text = AMLocalizedString(@"forgot_password_instruction", nil);
    self.cardNumberLabel.text = AMLocalizedString(@"login_form_card_number", nil);
    
    [self.submitButton setTitle:AMLocalizedString(@"submit", nil) forState:UIControlStateNormal];
}

- (IBAction)selectSubmit:(id)sender
{
    [self.communicator startIndicator];
    
    // Prepare API request
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:self.cardNumberTextField.text forKey:CARD_NUMBER];
    
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_LOGIN_FORGET] isPost:YES parameters:parameters tag:ROUTE_LOGIN_FORGET];
}

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    self.resultAlert = [[UIAlertView alloc] initWithTitle:nil
                                                  message:AMLocalizedString(@"forgot_password_success", nil)
                                                 delegate:self
                                        cancelButtonTitle:AMLocalizedString(@"ok", nil)
                                        otherButtonTitles:nil];
    [self.resultAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (alertView == self.resultAlert) {
        [self popBack];
    }
}

@end
