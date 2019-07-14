//
//  NewsPromotionsViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "NewsPromotionsViewController.h"
#import "NewsPromotionsDetailViewController.h"

@interface NewsPromotionsViewController ()

@end

@implementation NewsPromotionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBarTitleKey = @"title_news_promotions";
    self.showLoginButton = YES;
    self.showLogoutButton = NO;
}

- (void)reloadCategories
{
    // Prepare API request
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_NEWS_CATEGORY] parameters:nil tag:ROUTE_GET_NEWS_CATEGORY];
}

- (void)loadItemsInCategoryId:(int)categoryId atPage:(int)page
{
    // Prepare API request
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:[@(categoryId) stringValue] forKey:CATEGORY_ID];
    [parameters setValue:@"10" forKey:LIMIT];
    [parameters setValue:[@(page) stringValue] forKey:PAGE];
    
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_NEWSES] parameters:parameters tag:ROUTE_GET_NEWSES];
}

- (void)selectCategory:(NSInteger)position
{
    if (position < [self.categories count]) {
        NSDictionary *category = [self.categories objectAtIndex:position];
        self.currentCategoryId = [category[NEWS_CATEGORY_ID] intValue];
        self.categoryPosition = position;
    }
    
    [super selectCategory:position];
}

- (void)selectItem:(NSInteger)position
{
    NSMutableArray *items = [self getItems];
    if (position < items.count) {
        NSDictionary *item = [items objectAtIndex:position];
        
        NewsPromotionsDetailViewController *detailVC = [[NewsPromotionsDetailViewController alloc] init];
        detailVC.itemId = [item[NEWS_ID] intValue];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    NSString *tag = jsonObject[TAG];
    
    if ([tag isEqualToString:ROUTE_GET_NEWS_CATEGORY]) {
        // Category list
        self.categories = jsonObject[NEWS_CATEGORIES];
        if ([self.categories count] > 0) {
            self.categoryTitleArray = [NSMutableArray new];
            for (NSDictionary *category in self.categories) {
                [self.categoryTitleArray addObject:category[NAME]];
            }
            
            // show the first category as default
            [self selectCategory:0];
        }
        
        [self.collectionView reloadData];
        
    } else if ([tag isEqualToString:ROUTE_GET_NEWSES]) {
        NSDictionary *parameters = jsonObject[PARAMETER];
        int categoryId = [parameters[CATEGORY_ID] intValue];
        int page = [parameters[PAGE] intValue];
        
        [self handleItems:jsonObject inCategoryId:categoryId atPage:page withArrayKey:NEWSES];
    }
}

@end
