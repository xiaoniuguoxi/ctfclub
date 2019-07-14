//
//  EventDetailViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "EventDetailViewController.h"
#import "EventTermsViewController.h"
#import "LoginViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.upperButtonTranslationKey = @"play_video";
    self.lowerButtonTranslationKey = @"book_now";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.itemId > 0) {
        [self.communicator startIndicator];
        
        // Prepare API request
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setValue:[@(self.itemId) stringValue] forKey:EVENT_ID];
        if ([LoginUtil getCardNumber]) {
            [parameters setValue:[LoginUtil getCardNumber] forKey:MEMBER_CARD_NUMBER];
        }
        
        [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_EVENT] parameters:parameters tag:nil];
    }
}

- (IBAction)selectSubmit:(id)sender
{
    if (sender == self.upperButton)
    {
        [self playVideo:[IMAGE_DIR_URL stringByAppendingString:self.item[VIDEO]]];
    }
    else if (sender == self.lowerButton)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        if ([LoginUtil getCardNumber] != nil) {
            EventTermsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"EventTermsViewController"];
            vc.eventId = self.itemId;
            vc.event = self.item;
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
    
    self.item = jsonObject[EVENTS];
    [self assignValues];
    
    // set toolbar title
    if (self.item[EVENTS_CATEGORY] != nil && self.item[EVENTS_CATEGORY] != [NSNull null]) {
        [self.navigationItem setTitle:self.item[EVENTS_CATEGORY]];
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
    
    // set book button
    if ([LoginUtil getCardNumber] == nil)
    {
        // 1-now show
        // 2-show
        int buttonShow = 1;
        if (self.item[BEFORE_LOGIN_SHOW_BUTTON] != nil && self.item[BEFORE_LOGIN_SHOW_BUTTON] != [NSNull null]) {
            buttonShow = [self.item[BEFORE_LOGIN_SHOW_BUTTON] intValue];
        }
        
        if (buttonShow == 2) {
            // show the book button
        } else {
            // hide the book button
            [self.lowerButton removeFromSuperview];
        }
    }
    else if (self.item[BUTTON_BOOK_SHOW] != nil && self.item[BUTTON_BOOK_SHOW] != [NSNull null])
    {
        // 0 表示 没有申请该活动的资格
        // 1 表示 允许显示申请按钮
        // 2 表示 未找到相关客户 ID
        // 3 表示 已申请过该活动(成功參加)
        // 4 表示 活动已结束
        // 5 表示 已申请过该活动(在等待列)
        int show = [self.item[BUTTON_BOOK_SHOW] intValue];
        
        if (show == 1) {
            // show the book button

            // display the event full message if any
            if (self.item[FULL_MESSAGE] != nil && self.item[FULL_MESSAGE] != [NSNull null]) {
                self.messageLabel.text = self.item[FULL_MESSAGE];
            }
        } else {
            // hide the book button
            [self.lowerButton removeFromSuperview];
        }
        
        if (show == 0) {
            self.messageLabel.text = AMLocalizedString(@"event_booking_disable", nil);
        } else if (show == 3) {
            self.messageLabel.text = AMLocalizedString(@"event_booking_signed", nil);
        } else if (show == 5) {
            self.messageLabel.text = AMLocalizedString(@"event_booking_waiting", nil);
        }
    }
}

@end
