//
//  LifestyleJournalViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 1/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "LifestyleJournalViewController.h"
#import "LifestyleJournalDetailViewController.h"

@interface LifestyleJournalViewController ()

@end

@implementation LifestyleJournalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarTitleKey = @"title_lifestyle_journal";
    self.showLoginButton = YES;
    self.showLogoutButton = NO;
}

- (void)reloadCategories
{
    // Prepare API request
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_LIFESTYLE_CATEGORY] parameters:nil tag:ROUTE_GET_LIFESTYLE_CATEGORY];
}

- (void)loadItemsInCategoryId:(int)categoryId atPage:(int)page
{
    // Prepare API request
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:[@(categoryId) stringValue] forKey:CATEGORY_ID];
    [parameters setValue:@"10" forKey:LIMIT];
    [parameters setValue:[@(page) stringValue] forKey:PAGE];
    
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_LIFESTYLES] parameters:parameters tag:ROUTE_GET_LIFESTYLES];
}

- (void)selectCategory:(NSInteger)position
{
    if (position < [self.categories count]) {
        NSDictionary *category = [self.categories objectAtIndex:position];
        self.currentCategoryId = [category[LIFESTYLE_CATEGORY_ID] intValue];
        self.categoryPosition = position;
    }
    
    [super selectCategory:position];
}

- (void)selectItem:(NSInteger)position
{
    NSMutableArray *items = [self getItems];
    if (position < items.count) {
        NSDictionary *item = [items objectAtIndex:position];
        
        LifestyleJournalDetailViewController *detailVC = [[LifestyleJournalDetailViewController alloc] init];
        detailVC.itemId = [item[LIFESTYLE_ID] intValue];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    NSString *tag = jsonObject[TAG];
    
    if ([tag isEqualToString:ROUTE_GET_LIFESTYLE_CATEGORY]) {
        // Category list
        self.categories = jsonObject[LIFESTYLE_CATEGORIES];
        if ([self.categories count] > 0) {
            self.categoryTitleArray = [NSMutableArray new];
            for (NSDictionary *category in self.categories) {
                [self.categoryTitleArray addObject:category[NAME]];
            }
            
            // show the first category as default
            [self selectCategory:0];
        }
        
        [self.collectionView reloadData];
        
    } else if ([tag isEqualToString:ROUTE_GET_LIFESTYLES]) {
        NSDictionary *parameters = jsonObject[PARAMETER];
        int categoryId = [parameters[CATEGORY_ID] intValue];
        int page = [parameters[PAGE] intValue];
        
        [self handleItems:jsonObject inCategoryId:categoryId atPage:page withArrayKey:LIFESTYLEES];
    }
}

@end
