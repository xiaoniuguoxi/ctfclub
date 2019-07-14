//
//  EventBookViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 1/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "EventBookViewController.h"
#import "ActionSheetStringPicker.h"

@interface EventBookViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneZoneValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *carryNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *carryNumValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactMethodValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) NSArray *phoneZoneArray;
@property (nonatomic, assign) NSInteger phoneZonePosition;

@property (nonatomic, strong) NSMutableArray *carryNumArray;
@property (nonatomic, assign) NSInteger carryNumPosition;

@property (nonatomic, strong) NSArray *contactMethodArray;
@property (nonatomic, assign) NSInteger contactMethodPosition;

@property (nonatomic, strong) UIAlertView *resultAlert;

@end

@implementation EventBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarTitleKey = @"event_booking_title";
    
    self.titleLabel.text = self.event[TITLE];
    
    // Get login detail
    if ([LoginUtil getInstance].detail == nil && [LoginUtil getCardNumber] && [LoginUtil getPassword]) {
        [self.communicator startIndicator];
        
        // Prepare API request
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setValue:[LoginUtil getCardNumber] forKey:CARD_NUMBER];
        [parameters setValue:[LoginUtil getPassword] forKey:HASH];
        
        [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_LOGIN_CHECK] isPost:YES parameters:parameters tag:ROUTE_LOGIN_CHECK];
    } else {
        [self initFormWithDetail];
    }
}

- (void)reloadLocalization
{
    [super reloadLocalization];
    
    self.nameLabel.text = AMLocalizedString(@"event_booking_name", nil);
    self.phoneLabel.text = AMLocalizedString(@"event_booking_telephone", nil);
    self.emailLabel.text = AMLocalizedString(@"event_booking_email", nil);
    self.carryNumLabel.text = AMLocalizedString(@"event_booking_carry_num", nil);;
    self.contactMethodLabel.text = AMLocalizedString(@"event_booking_contact", nil);
    
    [self.submitButton setTitle:AMLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    
    // Prepare filter
    self.phoneZoneArray = [NSArray arrayWithObjects:AMLocalizedString(@"852", nil), AMLocalizedString(@"86", nil), AMLocalizedString(@"853", nil), nil];
    
    self.carryNumArray = [NSMutableArray new];
    int maxNum = [self.event[AGREE_NUMBER] intValue];
    for (int i = 0; i <= maxNum; i++) {
        [self.carryNumArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    self.contactMethodArray = [NSArray arrayWithObjects:AMLocalizedString(@"select", nil), AMLocalizedString(@"event_booking_option_email", nil), AMLocalizedString(@"event_booking_option_telephone", nil), nil];
    
    // Set default
    [self selectPhoneZone:0];
    [self selectCarryNum:0];
    [self selectContactMethod:0];
}

- (void)initFormWithDetail
{
    NSDictionary *detail = [LoginUtil getInstance].detail;
    NSString *name = [LoginUtil getName];
    NSString *phone = detail[TEL1];
    
    self.nameTextField.text = name;
    self.nameTextField.enabled = NO;
    self.phoneTextField.text = phone;
}

- (void)selectPhoneZone:(NSInteger)position
{
    self.phoneZonePosition = position;
    self.phoneZoneValueLabel.text = [self.phoneZoneArray objectAtIndex:position];
}

- (void)selectCarryNum:(NSInteger)position
{
    if (position < self.carryNumArray.count) {
        self.carryNumPosition = position;
        self.carryNumValueLabel.text = [self.carryNumArray objectAtIndex:position];
    }
}

- (void)selectContactMethod:(NSInteger)position
{
    if (position < self.contactMethodArray.count) {
        self.contactMethodPosition = position;
        self.contactMethodValueLabel.text = [self.contactMethodArray objectAtIndex:position];
    }
}

- (IBAction)selectPhoneZonePicker:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.phoneZoneArray
                                initialSelection:self.phoneZonePosition
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [self selectPhoneZone:selectedIndex];
                                       }
                                     cancelBlock:nil
                                          origin:self.phoneZoneValueLabel];
}

- (IBAction)selectCarryNumPicker:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.carryNumArray
                                initialSelection:self.carryNumPosition
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [self selectCarryNum:selectedIndex];
                                       }
                                     cancelBlock:nil
                                          origin:self.carryNumValueLabel];
}

- (IBAction)selectContactMethodPicker:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.contactMethodArray
                                initialSelection:self.contactMethodPosition
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [self selectContactMethod:selectedIndex];
                                       }
                                     cancelBlock:nil
                                          origin:self.contactMethodValueLabel];
}

- (IBAction)selectSubmit:(id)sender {
    NSString *errorMessage = @"";
    
    if (self.emailTextField.text.length == 0 && self.phoneTextField.text.length == 0) {
        errorMessage = [errorMessage stringByAppendingString:AMLocalizedString(@"error_phone_or_email", nil)];
    }
    
    if (self.carryNumPosition == 0) {
        errorMessage = [errorMessage stringByAppendingString:AMLocalizedString(@"event_booking_participants_error", nil)];
    }
    
    if (self.contactMethodPosition == 0) {
        errorMessage = [errorMessage stringByAppendingString:AMLocalizedString(@"error_contact", nil)];
    }
    
    if (errorMessage.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"error", nil)
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:AMLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self.communicator startIndicator];
    
    // Prepare API request
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:[@(self.eventId) stringValue] forKey:ACTIVITY_ID];
    [parameters setValue:[LoginUtil getCardNumber] forKey:MEMBER_CARD_NUMBER];
    
    NSString *phoneZone = (self.phoneZonePosition == 0) ? @"852" : (self.phoneZonePosition == 1) ? @"86" : @"853";
    [parameters setValue:phoneZone forKey:TELEPHONE_ZONE];
    [parameters setValue:self.phoneTextField.text forKey:TELEPHONE];
    
    [parameters setValue:[@(self.carryNumPosition) stringValue] forKey:CARRY_NO];
    [parameters setValue:[@(self.contactMethodPosition-1) stringValue] forKey:CONTACT];//not include 0 - "select"
    
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_APPLY_EVENT] isPost:YES parameters:parameters tag:ROUTE_APPLY_EVENT];
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    NSString *tag = jsonObject[TAG];
    
    if ([tag isEqualToString:ROUTE_APPLY_EVENT]) {
        self.resultAlert = [[UIAlertView alloc] initWithTitle:nil
                                                      message:jsonObject[@"message"]
                                                     delegate:self
                                            cancelButtonTitle:AMLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil];
        [self.resultAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (alertView == self.resultAlert) {
        [self popBack];
    }
}

@end
