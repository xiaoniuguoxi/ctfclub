//
//  GoldPriceViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "GoldPriceViewController.h"

#define GRAM_PER_TAEL 37.46

@interface GoldPriceViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *weightUnitButton;
@property (weak, nonatomic) IBOutlet UIButton *currencyButton;

@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseLabel;

@property (weak, nonatomic) IBOutlet UILabel *goldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldSellValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldBuyValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *redemptionPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *redemptionSellValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *redemptionBuyValueLabel;

@property (strong, nonatomic) IBOutlet UILabel *platinumLabel;
@property (strong, nonatomic) IBOutlet UILabel *platinumSellValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *platinumBuyValueLabel;

@property (strong, nonatomic) IBOutlet UILabel *goldPelletLabel;
@property (strong, nonatomic) IBOutlet UILabel *goldPelletSellValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *goldPelletBuyValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *exchangeRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLabel;

@property (nonatomic, assign) BOOL isHKD;
@property (nonatomic, assign) BOOL isTeal;
@property (nonatomic, assign) int goldSellPrice;
@property (nonatomic, assign) int goldBuyPrice;
@property (nonatomic, assign) int redemptionSellPrice;
@property (nonatomic, assign) int redemptionBuyPrice;
@property (nonatomic, assign) int platinumSellPrice;
@property (nonatomic, assign) int platinumBuyPrice;
@property (nonatomic, assign) int goldPelletSellPrice;
@property (nonatomic, assign) int goldPelletBuyPrice;
@property (nonatomic, assign) double exchangeRate;

@end

@implementation GoldPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarTitleKey = @"title_daily_gold_price";
    self.showLoginButton = YES;
    self.showLogoutButton = NO;
    
    self.contentView.hidden = YES;
    
    [self assignPriceValues];
    
    // Prepare API request
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_GOLD_PRICE] parameters:nil tag:nil];
}

- (void)reloadLocalization
{
    [super reloadLocalization];
    
    self.titleLabel.text = AMLocalizedString(@"gold_price_header", nil);
    self.goldPriceLabel.text = AMLocalizedString(@"gold_price_999", nil);
    self.redemptionPriceLabel.text = AMLocalizedString(@"gold_price_redemption", nil);
    self.platinumLabel.text = AMLocalizedString(@"gold_price_platinum", nil);
    self.goldPelletLabel.text = AMLocalizedString(@"gold_price_gold_pellet", nil);
}

- (IBAction)selectWeightUnit:(id)sender {
    self.isTeal = !self.isTeal;
    [self assignPriceValues];
}

- (IBAction)selectCurrency:(id)sender {
    self.isHKD = !self.isHKD;
    [self assignPriceValues];
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    self.isHKD = true;
    self.isTeal = true;
    
    if (jsonObject[GOLD_SELL] != nil && jsonObject[GOLD_SELL] != [NSNull null]) {
        self.goldSellPrice = [jsonObject[GOLD_SELL] intValue];
    }
    
    if (jsonObject[GOLD_BUY] != nil && jsonObject[GOLD_BUY] != [NSNull null]) {
        self.goldBuyPrice = [jsonObject[GOLD_BUY] intValue];
    }
    
    if (jsonObject[HUANJIN_SELL] != nil && jsonObject[HUANJIN_SELL] != [NSNull null]) {
        self.redemptionSellPrice = [jsonObject[HUANJIN_SELL] intValue];
    }
    
    if (jsonObject[HUANJIN_BUY] != nil && jsonObject[HUANJIN_BUY] != [NSNull null]) {
        self.redemptionBuyPrice = [jsonObject[HUANJIN_BUY] intValue];
    }
    
    if (jsonObject[PLATINUM_SELL] != nil && jsonObject[PLATINUM_SELL] != [NSNull null]) {
        self.platinumSellPrice = [jsonObject[PLATINUM_SELL] intValue];
    }
    
    if (jsonObject[PLATINUM_BUY] != nil && jsonObject[PLATINUM_BUY] != [NSNull null]) {
        self.platinumBuyPrice = [jsonObject[PLATINUM_BUY] intValue];
    }
    
    if (jsonObject[GOLD_PELLET_SELL] != nil && jsonObject[GOLD_PELLET_SELL] != [NSNull null]) {
        self.goldPelletSellPrice = [jsonObject[GOLD_PELLET_SELL] intValue];
    }
    
    if (jsonObject[GOLD_PELLET_BUY] != nil && jsonObject[GOLD_PELLET_BUY] != [NSNull null]) {
        self.goldPelletBuyPrice = [jsonObject[GOLD_PELLET_BUY] intValue];
    }
    
    if (jsonObject[EXCHANGE_RATE] != nil && jsonObject[EXCHANGE_RATE] != [NSNull null]) {
        self.exchangeRate = [jsonObject[EXCHANGE_RATE] doubleValue];
        self.exchangeRateLabel.text = [AMLocalizedString(@"gold_price_exchange_rate", nil) stringByAppendingString:jsonObject[EXCHANGE_RATE]];
    }
    
    if (jsonObject[LAST_UPDATE_DATETIME] != nil && jsonObject[LAST_UPDATE_DATETIME] != [NSNull null]) {
        self.lastUpdateLabel.text = [AMLocalizedString(@"gold_price_last_update", nil) stringByAppendingString:jsonObject[LAST_UPDATE_DATETIME]];
    }
    
    [self assignPriceValues];
    
    self.contentView.hidden = NO;
}

- (void)assignPriceValues
{
    double goldSell = self.goldSellPrice;
    double goldBuy = self.goldBuyPrice;
    double redemptionSell = self.redemptionSellPrice;
    double redemptionBuy = self.redemptionBuyPrice;
    double platinumSell = self.platinumSellPrice;
    double platinumBuy = self.platinumBuyPrice;
    double goldPelletSell = self.goldPelletSellPrice;
    double goldPelletBuy = self.goldPelletBuyPrice;
    
    if (!self.isHKD) {
        goldSell *= self.exchangeRate;
        goldBuy *= self.exchangeRate;
        redemptionSell *= self.exchangeRate;
        redemptionBuy *= self.exchangeRate;
        platinumSell *= self.exchangeRate;
        platinumBuy *= self.exchangeRate;
        goldPelletSell *= self.exchangeRate;
        goldPelletBuy *= self.exchangeRate;
    }
    
    if (!self.isTeal) {
        goldSell /= GRAM_PER_TAEL;
        goldBuy /= GRAM_PER_TAEL;
        redemptionSell /= GRAM_PER_TAEL;
        redemptionBuy /= GRAM_PER_TAEL;
        platinumSell /= GRAM_PER_TAEL;
        platinumBuy /= GRAM_PER_TAEL;
        goldPelletSell /= GRAM_PER_TAEL;
        goldPelletBuy /= GRAM_PER_TAEL;
    }
    
    self.goldSellValueLabel.text = [@(round(goldSell)) stringValue];
    self.goldBuyValueLabel.text = [@(round(goldBuy)) stringValue];
    self.redemptionSellValueLabel.text = @"----";
    self.redemptionBuyValueLabel.text = [@(round(redemptionBuy)) stringValue];
    self.platinumSellValueLabel.text = @"----";
    self.platinumBuyValueLabel.text = [@(round(platinumBuy)) stringValue];
    self.goldPelletSellValueLabel.text = [@(round(goldPelletSell)) stringValue];
    self.goldPelletBuyValueLabel.text = [@(round(goldPelletBuy)) stringValue];
    
    self.saleLabel.text = AMLocalizedString(self.isHKD ? @"gold_price_sale_in_hkd" : @"gold_price_sale_in_cny", nil);
    self.purchaseLabel.text = AMLocalizedString(self.isHKD ? @"gold_price_purchase_in_hkd" : @"gold_price_purchase_in_cny", nil);
    [self.weightUnitButton setTitle:AMLocalizedString(self.isTeal ? @"gold_price_display_in_gram" : @"gold_price_display_in_tael", nil) forState:UIControlStateNormal];
    [self.currencyButton setTitle:AMLocalizedString(self.isHKD ? @"gold_price_display_in_cny" : @"gold_price_display_in_hkd", nil) forState:UIControlStateNormal];
}

@end
