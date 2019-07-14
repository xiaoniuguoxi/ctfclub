//
//  EventsViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "EventsViewController.h"
#import "EventDetailViewController.h"

@interface EventsViewController ()

@end

@implementation EventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBarTitleKey = @"title_events";
    self.showLoginButton = YES;
    self.showLogoutButton = NO;
}

- (void)reloadCategories
{
    // Prepare API request
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_EVENT_CATEGORY] parameters:nil tag:ROUTE_GET_EVENT_CATEGORY];
}

- (void)loadItemsInCategoryId:(int)categoryId atPage:(int)page
{
    // Prepare API request
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:[@(categoryId) stringValue] forKey:CATEGORY_ID];
    [parameters setValue:@"10" forKey:LIMIT];
    [parameters setValue:[@(page) stringValue] forKey:PAGE];
    
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_EVENTS] parameters:parameters tag:ROUTE_GET_EVENTS];
}

- (void)selectCategory:(NSInteger)position
{
    if (position < [self.categories count]) {
        NSDictionary *category = [self.categories objectAtIndex:position];
        self.currentCategoryId = [category[EVENTS_CATEGORY_ID] intValue];
        self.categoryPosition = position;
    }
    
    [super selectCategory:position];
}

- (void)selectItem:(NSInteger)position
{
    NSMutableArray *items = [self getItems];
    if (position < items.count) {
        NSDictionary *item = [items objectAtIndex:position];
        
        EventDetailViewController *detailVC = [[EventDetailViewController alloc] init];
        detailVC.itemId = [item[EVENTS_ID] intValue];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    NSString *tag = jsonObject[TAG];
    
    if ([tag isEqualToString:ROUTE_GET_EVENT_CATEGORY]) {
        // Category list
        self.categories = jsonObject[EVENTS_CATEGORIES];
        if ([self.categories count] > 0) {
            self.categoryTitleArray = [NSMutableArray new];
            for (NSDictionary *category in self.categories) {
                [self.categoryTitleArray addObject:category[NAME]];
            }
            
            // show the first category as default
            [self selectCategory:0];
        }
        
        [self.collectionView reloadData];
        
    } else if ([tag isEqualToString:ROUTE_GET_EVENTS]) {
        NSDictionary *parameters = jsonObject[PARAMETER];
        int categoryId = [parameters[CATEGORY_ID] intValue];
        int page = [parameters[PAGE] intValue];
        
        [self handleItems:jsonObject inCategoryId:categoryId atPage:page withArrayKey:EVENTES];
    }
}

@end
