//
//  InformationViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 25/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation InformationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    // Set transparent to show the grey background
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    
    // Prepare API request
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:[@(self.informationId) stringValue] forKey:INFORMATION_ID];
    
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_INFORMATION] parameters:parameters tag:nil];
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    NSDictionary *item = jsonObject[INFORMATION];
    
    if (item) {
        if (item[TITLE] != nil && item[TITLE] != [NSNull null]) {
            self.navigationItem.title = [HtmlUtil decodeHTML:item[TITLE]];
        }
        
        if (item[DESCRIPTION] != nil && item[DESCRIPTION] != [NSNull null]) {
            NSString *header = @"<html><head><style type=\"text/css\">body {font-family:Arial;}</style></head><body>";
            NSString *footer = @"</body></html>";
            NSString *description = [[header stringByAppendingString:item[DESCRIPTION]] stringByAppendingString:footer];
            
            [self.webView loadHTMLString:description baseURL:nil];
        }
    }
}

@end
