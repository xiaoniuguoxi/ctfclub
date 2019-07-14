//
//  MemberAreaViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 2/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "MemberAreaViewController.h"
#import "ActionSheetStringPicker.h"

@interface MemberAreaViewController ()

@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

@property (nonatomic, strong) NSArray *filterTitleArray;
@property (nonatomic, assign) NSInteger filterPosition;
@property (nonatomic, assign) bool firstLoad;

@end

@implementation MemberAreaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarTitleKey = @"title_member_area";
    self.showLoginButton = YES;
    self.showLogoutButton = YES;
    
    self.firstLoad = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
    if (self.firstLoad)
    {
        // This login request must be placed in viewDidAppear in order to support switching to login view if login failure
        // ------------------------------------------------------------------------------------------------------------
        // Get login detail
        if ([LoginUtil getInstance].detail == nil) {
            if ([LoginUtil getCardNumber] && [LoginUtil getPassword]) {
                [self.communicator startIndicator];
                
                // Prepare API request
                NSMutableDictionary *parameters = [NSMutableDictionary new];
                [parameters setValue:[LoginUtil getCardNumber] forKey:CARD_NUMBER];
                [parameters setValue:[LoginUtil getPassword] forKey:HASH];
                
                [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_LOGIN_CHECK] isPost:YES parameters:parameters tag:ROUTE_LOGIN_CHECK];
            }
        } else {
            // Load default
            [self initFormWithDetail];
        }
        
        self.firstLoad = NO;
    }
}

- (void)initFormWithDetail
{
    NSDictionary *detail = [LoginUtil getInstance].detail;
    if (detail == nil) {
        // prevent crash
        return;
    }
    
    int cardLevel = [detail[CARD_LEVEL] intValue];
    if (cardLevel >= 2 && cardLevel <= 5) {
        self.filterTitleArray = [NSArray arrayWithObjects:AMLocalizedString(@"account_summary_title", nil), AMLocalizedString(@"membership_card_title", nil), AMLocalizedString(@"membership_barcode_title", nil),AMLocalizedString(@"change_password_title", nil), nil];
    } else {
        self.filterTitleArray = [NSArray arrayWithObjects:AMLocalizedString(@"account_summary_title", nil), AMLocalizedString(@"membership_barcode_title", nil),AMLocalizedString(@"change_password_title", nil), nil];
    }
    
    // Load default
    [self selectFilterOption:0];
}

- (void)selectFilterOption:(NSInteger)position
{
    NSString *selected = [self.filterTitleArray objectAtIndex:position];
    NSString *identifier = nil;
    
    if ([selected isEqualToString:AMLocalizedString(@"account_summary_title", nil)]) {
        identifier = @"AccountSummaryViewController";
    } else if ([selected isEqualToString:AMLocalizedString(@"membership_card_title", nil)]) {
        identifier = @"MembershipCardViewController";
    } else if ([selected isEqualToString:AMLocalizedString(@"membership_barcode_title", nil)]) {
        identifier = @"MembershipBarcodeViewController";
    } else if ([selected isEqualToString:AMLocalizedString(@"membership_card_qrcode_title", nil)]) {
        identifier = @"MembershipCardQRCodeViewController";
    } else if ([selected isEqualToString:AMLocalizedString(@"change_password_title", nil)]) {
        identifier = @"ChangePasswordViewController";
    }
    
    if (identifier) {
        self.filterPosition = position;
        self.filterLabel.text = [self.filterTitleArray objectAtIndex:position];
        
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        UINavigationController *navControler = [self.childViewControllers firstObject];
        [navControler setViewControllers:[NSArray arrayWithObject:vc] animated:NO];
    }
}

- (IBAction)selectFilter:(id)sender
{
    if (self.filterTitleArray == nil) {
        return;
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.filterTitleArray
                                initialSelection:self.filterPosition
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [self selectFilterOption:selectedIndex];
                                       }
                                     cancelBlock:nil
                                          origin:self.filterLabel];
}

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
}

@end
