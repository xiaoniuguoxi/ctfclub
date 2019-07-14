//
//  AboutCtfClubViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 25/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "AboutCtfClubViewController.h"
#import "ActionSheetStringPicker.h"

@interface AboutCtfClubViewController ()

@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;
@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;

@property (nonatomic, strong) NSArray *filterTitleArray;
@property (nonatomic, assign) NSInteger filterPosition;

@end

@implementation AboutCtfClubViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarTitleKey = @"title_about_ctf_club";
    self.showLoginButton = YES;
    self.showLogoutButton = NO;
    
    // Set transparent to show the grey background
    [self.descriptionWebView setBackgroundColor:[UIColor clearColor]];
    [self.descriptionWebView setOpaque:NO];
    
    // Set webview delegate
    self.descriptionWebView.delegate = self;
    
    // Disable bounces
    self.descriptionWebView.scrollView.bounces = NO;
    
    // Prepare filter
    self.filterTitleArray = [NSArray arrayWithObjects:AMLocalizedString(@"about_ctf_club_introduction", nil), AMLocalizedString(@"about_ctf_club_membership_tier", nil), AMLocalizedString(@"about_ctf_club_programme_details", nil), AMLocalizedString(@"about_ctf_club_rewards", nil), nil];
    
    // default laod the first one
    [self selectFilterOption:0];
}

- (void)selectFilterOption:(NSInteger)position
{
    int informationId = INTRODUCTION_INFORMATION_ID;
    
    if (position == 0) {
        informationId = INTRODUCTION_INFORMATION_ID;
    } else if (position == 1) {
        informationId = MEMBERSHIP_TIER_INFORMATION_ID;
    } else if (position == 2) {
        informationId = PROGRAMME_DETAILS_INFORMATION_ID;
    } else if (position == 3) {
        informationId = REWARDS_INFORMATION_ID;
    }
    
    self.filterPosition = position;
    self.filterLabel.text = [self.filterTitleArray objectAtIndex:position];
    
    // Prepare API request
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:[@(informationId) stringValue] forKey:INFORMATION_ID];
    
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_INFORMATION] parameters:parameters tag:nil];
}

- (IBAction)selectFilter:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.filterTitleArray
                                initialSelection:self.filterPosition
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [self selectFilterOption:selectedIndex];
                                       }
                                     cancelBlock:nil
                                          origin:self.filterLabel];
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    NSDictionary *item = jsonObject[INFORMATION];
    
    if (item) {
        if (item[DESCRIPTION] != nil && item[DESCRIPTION] != [NSNull null]) {
            NSString *header = @"<html><head><style type=\"text/css\">body {font-family:\"Arial\";}</style></head><body>";
            NSString *footer = @"</body></html>";
            NSString *description = [[header stringByAppendingString:item[DESCRIPTION]] stringByAppendingString:footer];
            
            [self.descriptionWebView loadHTMLString:description baseURL:nil];
        }
    }
}

#pragma mark - UIWebViewDelegate

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    // auto resize the webview to fit the content
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    self.webViewHeightConstraint.constant = [result integerValue] + 20 /*buffer or margin*/;
}

@end
