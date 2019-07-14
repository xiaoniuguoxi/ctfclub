//
//  NewsPromotionsDetailViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "NewsPromotionsDetailViewController.h"

@interface NewsPromotionsDetailViewController ()

@end

@implementation NewsPromotionsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.upperButtonTranslationKey = @"play_video";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.itemId > 0) {
        [self.communicator startIndicator];
        
        // Prepare API request
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setValue:[@(self.itemId) stringValue] forKey:NEWS_ID];
        
        [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_NEWS] parameters:parameters tag:nil];
    }
}

- (IBAction)selectSubmit:(id)sender
{
    if (sender == self.upperButton) {
        [self playVideo:[IMAGE_DIR_URL stringByAppendingString:self.item[VIDEO]]];
    }
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    self.item = jsonObject[NEWS];
    [self assignValues];
    
    // set toolbar title
    if (self.item[NEWS_CATEGORY] != nil && self.item[NEWS_CATEGORY] != [NSNull null]) {
        [self.navigationItem setTitle:self.item[NEWS_CATEGORY]];
    }
    
    // set video button
    if (self.item[VIDEO] != nil && self.item[VIDEO] != [NSNull null]) {
        NSString *video = self.item[VIDEO];
        if (video.length == 0) {
            [self.upperButton removeFromSuperview];
        }
    } else {
        [self.upperButton removeFromSuperview];
    }
}

@end
