//
//  ViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 7/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "IndexViewController.h"
#import "UserDefaultsUtil.h"
#import "LocalizationSystem.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "LoginViewController.h"
#import "TabViewController.h"
#import "InformationViewController.h"
#import "NewsPromotionsDetailViewController.h"
#import "EventDetailViewController.h"
#import "BirthdayOfferDetailViewController.h"
#import "SimpleWebViewController.h"
#import "AdViewController.h"

//Hugh
#import "CTFHomeVC.h"

@interface IndexViewController ()

@property (weak, nonatomic) IBOutlet SwipeView *bannerSwipeView;

@property (weak, nonatomic) IBOutlet UILabel *memberAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsPromotionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventsLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayOffersLabel;
@property (weak, nonatomic) IBOutlet UILabel *eShopLabel;
@property (weak, nonatomic) IBOutlet UILabel *conciergeServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceProductInquiryLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutCtfClubLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsletterLabel;
@property (weak, nonatomic) IBOutlet UILabel *lifestyleJournalLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyGoldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactUsLabel;
@property (weak, nonatomic) IBOutlet UILabel *staffRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *internationalShopperLabel;

@property (nonatomic, strong) CommunicationProtocol *communicator;
@property (nonatomic, strong) NSArray *banners;

@property (nonatomic, assign) bool openConciergeServiceLinkWhenDisplayAgain;
@property (nonatomic, assign) bool openQuestionnaireLinkWhenDisplayAgain;

@end

@implementation IndexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // initialize the communicator
    self.communicator = [CommunicationProtocol new];
    self.communicator.delegate = self;
    
    // init timer for changing top banner every 5 seconds
    [NSTimer scheduledTimerWithTimeInterval: 5.0 target:self selector:@selector(scrollToNextBanner) userInfo:nil repeats:YES];
    
    // Prepare API request
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_ADVERTISEMENT] parameters:nil tag:ROUTE_GET_ADVERTISEMENT];
    
    //Hugh
//    CTFHomeVC *homeVC = [[CTFHomeVC alloc] init];
//    [self.navigationController pushViewController:homeVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Hide navigation bar
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [self reloadLocalization];
    
    // Prepare API request
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_BANNERS] parameters:nil tag:ROUTE_GET_BANNERS];
    
    // Open concierge service page if return from login after selecting concierge service
    if (self.openConciergeServiceLinkWhenDisplayAgain && [LoginUtil getCardNumber] && [LoginUtil getPassword]) {
        [self selectConciergeService:nil];
        self.openConciergeServiceLinkWhenDisplayAgain = NO;
    }
    
    // Open questionnaire page if return from login after selecting questionnaire
//    if (self.openQuestionnaireLinkWhenDisplayAgain && [LoginUtil getCardNumber] && [LoginUtil getPassword]) {
//        [self selectQuestionnaire:nil];
//        self.openQuestionnaireLinkWhenDisplayAgain = NO;
//    }
}

- (void)reloadLocalization
{
    self.memberAreaLabel.text = AMLocalizedString(@"member_area", nil);
    self.newsPromotionsLabel.text = AMLocalizedString(@"news_promotions", nil);
    self.eventsLabel.text = AMLocalizedString(@"events", nil);
    self.birthdayOffersLabel.text = AMLocalizedString(@"birthday_offers", nil);
    self.eShopLabel.text = AMLocalizedString(@"eshop", nil);
    self.conciergeServiceLabel.text = AMLocalizedString(@"concierge_service", nil);
    self.serviceProductInquiryLabel.text = AMLocalizedString(@"service_product_inquiry", nil);
    self.aboutCtfClubLabel.text = AMLocalizedString(@"about_ctf_club", nil);
    self.newsletterLabel.text = AMLocalizedString(@"newsletter", nil);
    self.lifestyleJournalLabel.text = AMLocalizedString(@"lifestyle_journal", nil);
    self.shopLocationLabel.text = AMLocalizedString(@"shop_location", nil);
    self.dailyGoldPriceLabel.text = AMLocalizedString(@"daily_gold_price", nil);
    self.contactUsLabel.text = AMLocalizedString(@"contact_us", nil);
    self.staffRatingLabel.text = AMLocalizedString(@"staff_rating", nil);
    self.settingsLabel.text = AMLocalizedString(@"settings", nil);
    self.internationalShopperLabel.text = AMLocalizedString(@"international_shopper", nil);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)scrollToNextBanner
{
    NSInteger newIndex = self.bannerSwipeView.currentItemIndex + 1;
    if (newIndex >= self.bannerSwipeView.numberOfItems) {
        newIndex = 0;
    }
    [self.bannerSwipeView scrollToItemAtIndex:newIndex duration:1];
}

- (void)openTabVCWithIndex:(int)tabIndex
{
    UINavigationController *mainNC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabNavigationController"];
    TabViewController *tabVC = (TabViewController *) [mainNC.childViewControllers firstObject];
    tabVC.currentTabIndex = tabIndex;
    
    [self presentViewController:mainNC animated:YES completion:nil];
}

- (IBAction)selectMemberArea:(id)sender {
    [self openTabVCWithIndex:0];
}

- (IBAction)selectNewsPromotions:(id)sender {
    [self openTabVCWithIndex:1];
}

- (IBAction)selectEvents:(id)sender {
    [self openTabVCWithIndex:2];
}

- (IBAction)selectBirthdayOffers:(id)sender {
    [self openTabVCWithIndex:3];
}

- (IBAction)selectEShop:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserDefaultsUtil getEShopUrl]]];
}

- (IBAction)selectConciergeService:(id)sender {
    // Get login detail
    if ([LoginUtil getCardNumber] && [LoginUtil getPassword]) {
        NSString *urlString = [NSString stringWithFormat:CONCIERGE_SERVICE_URL, [UserDefaultsUtil getLanguageCode], [LoginUtil getCardNumber], [LoginUtil getPassword]];
        urlString = [HOST_URL stringByAppendingString:urlString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//        SimpleWebViewController *vc = [[SimpleWebViewController alloc] initWithAddress:urlString withTitleKey:@"concierge_service"];
//        vc.pushedWithNavBar = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    } else {
        self.openConciergeServiceLinkWhenDisplayAgain = YES;
        
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.pushedWithNavBar = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//- (IBAction)selectQuestionnaire:(id)sender {
//    // Get login detail
//    if ([LoginUtil getCardNumber] && [LoginUtil getPassword]) {
//        NSString *urlString = [NSString stringWithFormat:QUESTIONNAIRE_URL, [UserDefaultsUtil getLanguageCode], [LoginUtil getCardNumber], [LoginUtil getPassword]];
//        urlString = [HOST_URL stringByAppendingString:urlString];
//        SimpleWebViewController *vc = [[SimpleWebViewController alloc] initWithAddress:urlString withTitleKey:@"questionnaire"];
//        vc.pushedWithNavBar = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
//        self.openQuestionnaireLinkWhenDisplayAgain = YES;
//        
//        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        vc.pushedWithNavBar = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}

- (IBAction)selectServiceProductInquiry:(id)sender {
    [self openTabVCWithIndex:7];
}

- (IBAction)selectAboutCtfClub:(id)sender {
    [self openTabVCWithIndex:8];
}

- (IBAction)selectNewsletters:(id)sender {
    [self openTabVCWithIndex:9];
}

- (IBAction)selectLifestyleJournal:(id)sender {
    [self openTabVCWithIndex:10];
}

- (IBAction)selectShopLocation:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserDefaultsUtil getShopLocationUrl]]];
}

- (IBAction)selectDailyGoldPrice:(id)sender {
    [self openTabVCWithIndex:12];
}

- (IBAction)selectContactUs:(id)sender {
    [self openTabVCWithIndex:13];
}

- (IBAction)selectStaffRating:(id)sender {
    [self openTabVCWithIndex:6];
}

- (IBAction)selectInternationalShopper:(id)sender {
    NSString *urlString = [UserDefaultsUtil getInternationalShopperUrl];
//    SimpleWebViewController *vc = [[SimpleWebViewController alloc] initWithAddress:urlString withTitleKey:@"international_shopper"];
//    vc.pushedWithNavBar = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (IBAction)selectSettings:(id)sender {
    [self openTabVCWithIndex:15];
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleError:(NSDictionary *)jsonObject
{
    // do nothing
}

- (void)handleResponse:(NSDictionary *)jsonObject
{
    NSString *tag = jsonObject[TAG];
    
    if ([tag isEqualToString:ROUTE_GET_BANNERS]) {
        self.banners = jsonObject[BANNERS];
        [self.bannerSwipeView reloadData];
    } else if ([tag isEqualToString:ROUTE_GET_ADVERTISEMENT]) {
        NSArray *advArray = jsonObject[ADVERTISEMENTES];
        if (advArray != nil && [advArray count] > 0) {
            NSString *imageUrl = [advArray firstObject][IMAGE];
            NSString *linkUrl = [advArray firstObject][PURL];
            
            if (imageUrl != nil && imageUrl.length > 0) {
                AdViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AdViewController"];
                vc.imageUrl = imageUrl;
                vc.linkUrl = linkUrl;
                self.definesPresentationContext = YES;
                vc.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.9];
                vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
    }
}

#pragma mark - SwipeViewDataSource

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.banners ? [self.banners count] : 0;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    NSDictionary *banner = [self.banners objectAtIndex:index];
    
    UIImageView *bannerView = [[UIImageView alloc] initWithFrame:swipeView.bounds];
    
    bannerView.contentMode = UIViewContentModeScaleAspectFill;
    bannerView.clipsToBounds = YES;
    
    [bannerView sd_setImageWithURL:[NSURL URLWithString:[banner[IMAGE] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    return bannerView;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return swipeView.bounds.size;
}

#pragma mark - SwipeViewDelegate

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *banner = [self.banners objectAtIndex:index];
    if (banner[APPURL] != nil && banner[APPURL] != [NSNull null]) {
        [self openLink:banner[APPURL]];
    }
}

- (void)openLink:(NSString *)appUrl
{
    NSRange rangeOfEqual = [appUrl rangeOfString:@"="];
    if (rangeOfEqual.location == NSNotFound) {
        return;
    }
    
    int itemId = [[appUrl substringFromIndex:rangeOfEqual.location + 1] intValue];
    
    /*
     for phase 1 has
     information=
     news=
     event=
     birthday=
     */
    if ([appUrl containsString:INFORMATION]) {
        InformationViewController *informationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
        informationVC.informationId = itemId;
        informationVC.pushedWithNavBar = YES;
        [self.navigationController pushViewController:informationVC animated:YES];
        
    } else if ([appUrl containsString:NEWS]) {
        NewsPromotionsDetailViewController *detailVC = [[NewsPromotionsDetailViewController alloc] init];
        detailVC.itemId = itemId;
        detailVC.pushedWithNavBar = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    } else if ([appUrl containsString:EVENT]) {
        EventDetailViewController *detailVC = [[EventDetailViewController alloc] init];
        detailVC.itemId = itemId;
        detailVC.pushedWithNavBar = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    } else if ([appUrl containsString:BIRTHDAY]) {
        BirthdayOfferDetailViewController *detailVC = [[BirthdayOfferDetailViewController alloc] init];
        detailVC.itemId = itemId;
        detailVC.pushedWithNavBar = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

@end
