//
//  BirthdayOfferDetailViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "BirthdayOfferDetailViewController.h"
#import "BirthdayOfferApplyViewController.h"
#import "LoginViewController.h"

@interface BirthdayOfferDetailViewController ()

@end

@implementation BirthdayOfferDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarTitleKey = @"title_birthday_offers";
    
    self.upperButtonTranslationKey = @"redemption";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.itemId > 0) {
        [self.communicator startIndicator];
        
        // Prepare API request
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setValue:[@(self.itemId) stringValue] forKey:BIRTHDAY_ID];
        if ([LoginUtil getCardNumber]) {
            [parameters setValue:[LoginUtil getCardNumber] forKey:MEMBER_CARD_NUMBER];
        }
        
        [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_BIRTHDAY_OFFER] parameters:parameters tag:nil];
    }
}

- (IBAction)selectSubmit:(id)sender
{
    if (sender == self.upperButton)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        if ([LoginUtil getCardNumber] != nil) {
            BirthdayOfferApplyViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"BirthdayOfferApplyViewController"];
            vc.birthdayId = self.itemId;
            vc.birthdayOffer = self.item;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            LoginViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    self.item = jsonObject[BIRTHDAY];
    [self assignValues];
    
    // set book button
    if ([LoginUtil getCardNumber] == nil)
    {
        // keep the book button
    }
    else if (self.item[BUTTON_BOOK_SHOW] != nil && self.item[BUTTON_BOOK_SHOW] != [NSNull null])
    {
        // 0 表示 不可以申请
        // 1 表示 允许显示申请按钮
        // 2 表示 未找到相关客户 ID
        int show = [self.item[BUTTON_BOOK_SHOW] intValue];
        
        if (show != 1) {
            [self.upperButton removeFromSuperview];
        }
    }
}

@end
