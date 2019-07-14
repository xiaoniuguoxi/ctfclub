//
//  TabViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 18/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "TabViewController.h"
#import "TabMenuButton.h"
#import "UserDefaultsUtil.h"
#import "CommonUtil.h"
#import "LoginUtil.h"
#import "LoginViewController.h"
#import "SimpleWebViewController.h"

#define NUM_OF_TAB 16

#define TAB_MENU_WIDTH 80
#define TAB_MENU_HEIGHT 60

@interface TabViewController ()

@property (nonatomic, assign) bool openConciergeServiceLinkWhenDisplayAgain;
@property (nonatomic, assign) bool openQuestionnaireLinkWhenDisplayAgain;

@end

@implementation TabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set current tab
    [self loadContentVC:self.currentTabIndex force:YES];
    self.tabbarSwipeView.currentItemIndex = self.currentTabIndex;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    // Open concierge service page if return from login after selecting concierge service
    if (self.openConciergeServiceLinkWhenDisplayAgain && [LoginUtil getCardNumber] && [LoginUtil getPassword]) {
        [self selectConciergeService];
        self.openConciergeServiceLinkWhenDisplayAgain = NO;
    }
    
    // Open questionnaire page if return from login after selecting questionnaire
    if (self.openQuestionnaireLinkWhenDisplayAgain && [LoginUtil getCardNumber] && [LoginUtil getPassword]) {
        [self selectQuestionnaire];
        self.openQuestionnaireLinkWhenDisplayAgain = NO;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)selectLogin
{
    [self loadContentVC:0 force:NO];
}

- (void)restartCurrentVC
{
    [self loadContentVC:self.currentTabIndex force:YES];
}

- (void)loadContentVC:(NSInteger)updateTabIndex force:(BOOL)forceUpdate
{
    if (forceUpdate == false && self.currentTabIndex == updateTabIndex) {
        // do nothing
        return;
    }
    
    // update the VC content
    NSString *identifier = nil;
    switch (updateTabIndex) {
        case 0: {
            if ([LoginUtil getCardNumber]) {
                identifier = @"MemberAreaViewController";
            } else {
                identifier = @"LoginViewController";
            }
            break;
        }
            
        case 1:
            identifier = @"NewsPromotionsViewController";
            break;
            
        case 2:
            identifier = @"EventsViewController";
            break;
            
        case 3:
            identifier = @"BirthdayOffersViewController";
            break;
            
        case 4:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserDefaultsUtil getEShopUrl]]];
            break;
            
        case 5:
            [self selectConciergeService];
            break;
            
        case 6:
            identifier = @"StaffRatingViewController";
            break;
            
        case 7:
            identifier = @"ServiceProductInquiryViewController";
            break;
            
        case 8:
            identifier = @"AboutCtfClubViewController";
            break;
            
        case 9:
            identifier = @"NewslettersViewController";
            break;
            
        case 10:
            identifier = @"LifestyleJournalViewController";
            break;
            
        case 11:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserDefaultsUtil getShopLocationUrl]]];
            break;
            
        case 12:
            identifier = @"GoldPriceViewController";
            break;
            
        case 13:
            identifier = @"ContactUsViewController";
            break;
            
        case 14:
            [self selectInternationalShopper];
            break;
            
        case 15:
            identifier = @"SettingsViewController";
            break;
            
        default:
            identifier = nil;
            break;
    }
    
    if (identifier) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        UINavigationController *navController = [self.childViewControllers firstObject];
        [navController setViewControllers:[NSArray arrayWithObject:vc] animated:YES];
        
        // update the index only if there is view controller change in tab
        self.currentTabIndex = updateTabIndex;
        [self.tabbarSwipeView reloadData];
    }
}

- (void)selectConciergeService
{
    // Get login detail
    if ([LoginUtil getCardNumber] && [LoginUtil getPassword]) {
        NSString *urlString = [NSString stringWithFormat:CONCIERGE_SERVICE_URL, [UserDefaultsUtil getLanguageCode], [LoginUtil getCardNumber], [LoginUtil getPassword]];
        urlString = [HOST_URL stringByAppendingString:urlString];
//        SimpleWebViewController *vc = [[SimpleWebViewController alloc] initWithAddress:urlString withTitleKey:@"concierge_service"];
//        vc.pushedWithNavBar = YES;
//        [self.navigationController pushViewController:vc animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else {
        self.openConciergeServiceLinkWhenDisplayAgain = YES;
        
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.pushedWithNavBar = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)selectQuestionnaire
{
    // Get login detail
    if ([LoginUtil getCardNumber] && [LoginUtil getPassword]) {
        NSString *urlString = [NSString stringWithFormat:QUESTIONNAIRE_URL, [UserDefaultsUtil getLanguageCode], [LoginUtil getCardNumber], [LoginUtil getPassword]];
        urlString = [HOST_URL stringByAppendingString:urlString];
//        SimpleWebViewController *vc = [[SimpleWebViewController alloc] initWithAddress:urlString withTitleKey:@"questionnaire"];
//        vc.pushedWithNavBar = YES;
//        [self.navigationController pushViewController:vc animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else {
        self.openQuestionnaireLinkWhenDisplayAgain = YES;
        
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.pushedWithNavBar = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)selectInternationalShopper
{
    NSString *urlString = [UserDefaultsUtil getInternationalShopperUrl];
//    SimpleWebViewController *vc = [[SimpleWebViewController alloc] initWithAddress:urlString withTitleKey:@"international_shopper"];
//    vc.pushedWithNavBar = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

#pragma mark - SwipeViewDataSource

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return NUM_OF_TAB;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    TabMenuButton *tabBarButton = [[TabMenuButton alloc] initWithFrame:CGRectMake(0, 0, TAB_MENU_WIDTH, TAB_MENU_HEIGHT)];
    tabBarButton.tabIndex = (int)index;
    [tabBarButton initMenuButton];
    [tabBarButton setTabSelected:index == self.currentTabIndex];
    
    return tabBarButton;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return CGSizeMake(TAB_MENU_WIDTH, TAB_MENU_HEIGHT);
}

#pragma mark - SwipeViewDelegate

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    [self loadContentVC:index force:NO];
}

@end
