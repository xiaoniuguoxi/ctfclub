//
//  LifestyleJournalDetailViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 1/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "LifestyleJournalDetailViewController.h"

@interface LifestyleJournalDetailViewController ()

@end

@implementation LifestyleJournalDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.itemId > 0) {
        [self.communicator startIndicator];
        
        // Prepare API request
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setValue:[@(self.itemId) stringValue] forKey:LIFESTYLE_ID];
        
        [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_LIFESTYLE] parameters:parameters tag:nil];
    }
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    self.item = jsonObject[LIFESTYLE];
    [self assignValues];
    
    // set toolbar title
    if (self.item[LIFESTYLE_CATEGORY] != nil && self.item[LIFESTYLE_CATEGORY] != [NSNull null]) {
        [self.navigationItem setTitle:self.item[LIFESTYLE_CATEGORY]];
    }
}

@end
