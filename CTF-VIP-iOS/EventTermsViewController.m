//
//  EventTermsViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 3/11/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "EventTermsViewController.h"
#import "EventBookViewController.h"

@interface EventTermsViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation EventTermsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarTitleKey = @"event_terms";
    
    // Set transparent to show the grey background
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    
    NSString *header = @"<html><head><style type=\"text/css\">body {font-family:Arial;}</style></head><body>";
    NSString *footer = @"</body></html>";
    NSString *description = [[header stringByAppendingString:self.event[TERM]] stringByAppendingString:footer];
    
    [self.webView loadHTMLString:description baseURL:nil];
}

- (void)reloadLocalization
{
    [super reloadLocalization];

    [self.agreeButton setTitle:AMLocalizedString(@"agree", nil) forState:UIControlStateNormal];
    [self.cancelButton setTitle:AMLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
}

- (IBAction)selectAgree:(id)sender
{
    [self popBack];
    
    EventBookViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventBookViewController"];
    vc.eventId = self.eventId;
    vc.event = self.event;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)selectCancel:(id)sender
{
    [self popBack];
}

@end
