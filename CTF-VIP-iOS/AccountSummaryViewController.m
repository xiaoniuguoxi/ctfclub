//
//  AccountSummaryViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 2/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "AccountSummaryViewController.h"

@interface AccountSummaryViewController ()

@property (weak, nonatomic) IBOutlet UILabel *helloLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *card1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *card2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *card3ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *card4ImageView;

@property (weak, nonatomic) IBOutlet UIView *card4to3View;
@property (weak, nonatomic) IBOutlet UIView *card3to2View;
@property (weak, nonatomic) IBOutlet UIView *card2to1View;

@property (weak, nonatomic) IBOutlet UILabel *upgradeToLabel;
@property (weak, nonatomic) IBOutlet UILabel *upgradeToQualifyLabel;
@property (weak, nonatomic) IBOutlet UILabel *upgradeToQualifyValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *upgradeToExtraLabel;
@property (weak, nonatomic) IBOutlet UILabel *upgradeToExtraValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *retainAsLabel;
@property (weak, nonatomic) IBOutlet UILabel *retainAsQualifyLabel;
@property (weak, nonatomic) IBOutlet UILabel *retainAsQualifyValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *retainAsExtraLabel;
@property (weak, nonatomic) IBOutlet UILabel *retainAsExtraValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedAsOfLabel;

@property (weak, nonatomic) IBOutlet UIView *upgradeTable;
@property (weak, nonatomic) IBOutlet UIView *retainTable;

@end

@implementation AccountSummaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *detail = [LoginUtil getInstance].detail;
    if (detail == nil) {
        // prevent crash
        return;
    }
    
    NSString *name = [LoginUtil getFullName];
    int cardLevel = [detail[CARD_LEVEL] intValue];
    NSString *updatedAsOf = [detail[LAST_MODIFY][DATE] substringToIndex:10];
    
    self.helloLabel.text = [NSString stringWithFormat:AMLocalizedString(@"account_summary_hello", nil), name];
    
    /*
     Card_Level    Card_Level_Desc
     0    無
     1    Follower/追隨者
     2    準會員
     3    黃金會員
     4    鉑金會員
     5    鑽石會員
     11    FansMember/粉絲會員
     150    非會員
     */
    if (cardLevel >= 2 && cardLevel <= 5)
    {
        if (cardLevel >= 2) {
            self.card4ImageView.layer.borderWidth = 5;
            self.card4ImageView.layer.borderColor = PRIMARY_PURPLE.CGColor;
        }
        
        if (cardLevel >= 3) {
            self.card4to3View.backgroundColor = PRIMARY_PURPLE;
            self.card3ImageView.layer.borderWidth = 5;
            self.card3ImageView.layer.borderColor = PRIMARY_PURPLE.CGColor;
        }
        
        if (cardLevel >= 4) {
            self.card3to2View.backgroundColor = PRIMARY_PURPLE;
            self.card2ImageView.layer.borderWidth = 5;
            self.card2ImageView.layer.borderColor = PRIMARY_PURPLE.CGColor;
        }
        
        if (cardLevel == 5) {
            self.card2to1View.backgroundColor = PRIMARY_PURPLE;
            self.card1ImageView.layer.borderWidth = 5;
            self.card1ImageView.layer.borderColor = PRIMARY_PURPLE.CGColor;
        }
    }
    
    NSString *cardLevelDesc;
    if ([[UserDefaultsUtil getLanguageCode] isEqualToString:LANG_EN]) {
        cardLevelDesc = detail[CARD_LEVEL_DESC_EN];
    } else if ([[UserDefaultsUtil getLanguageCode] isEqualToString:LANG_ZH_HK]) {
        cardLevelDesc = detail[CARD_LEVEL_DESC_CHT];
    } else if ([[UserDefaultsUtil getLanguageCode] isEqualToString:LANG_ZH_CN]) {
        cardLevelDesc = detail[CARD_LEVEL_DESC_CHS];
    }
    if (cardLevelDesc == nil) {
        cardLevelDesc = detail[CARD_LEVEL_DESC];
    }
    
    NSString *nextCardLevelDesc;
    if ([[UserDefaultsUtil getLanguageCode] isEqualToString:LANG_EN]) {
        nextCardLevelDesc = detail[NEXT_CARD_LEVEL_DESC_EN];
    } else if ([[UserDefaultsUtil getLanguageCode] isEqualToString:LANG_ZH_HK]) {
        nextCardLevelDesc = detail[NEXT_CARD_LEVEL_DESC_CHT];
    } else if ([[UserDefaultsUtil getLanguageCode] isEqualToString:LANG_ZH_CN]) {
        nextCardLevelDesc = detail[NEXT_CARD_LEVEL_DESC_CHS];
    }
    if (nextCardLevelDesc == nil) {
        nextCardLevelDesc = detail[NEXT_CARD_LEVEL_DESC];
    }
    
    self.cardNumberLabel.text = [NSString stringWithFormat:AMLocalizedString(@"account_summary_card_number", nil), [LoginUtil getCardNumber], cardLevelDesc];
    
    // Show Upgrade: Fans, Premember, Gold, Platinum
    if (cardLevel == 11 || cardLevel == 2 || cardLevel == 3 || cardLevel == 4)
    {
        self.upgradeToLabel.text = [NSString stringWithFormat:AMLocalizedString(@"account_summary_upgrade_to", nil), nextCardLevelDesc];
        self.upgradeToQualifyLabel.text = AMLocalizedString(@"account_summary_quali_for_upgrade", nil);
        self.upgradeToExtraLabel.text = AMLocalizedString(@"account_summary_extra_for_upgrade", nil);
        
        id value1 = detail[CONSUME_TOTAL];
        if (![value1 isKindOfClass:[NSString class]]) {
            value1 = [detail[CONSUME_TOTAL] stringValue];
        }
        self.upgradeToQualifyValueLabel.text = [NSString stringWithFormat:@"HK$%d", [value1 intValue]];
        
        id value2 = detail[UPGRADE_NEED_CONSUME];
        if (![value2 isKindOfClass:[NSString class]]) {
            value2 = [detail[UPGRADE_NEED_CONSUME] stringValue];
        }
        self.upgradeToExtraValueLabel.text = [NSString stringWithFormat:@"HK$%d", [value2 intValue]];
    }
    else
    {
        [self.upgradeToLabel removeFromSuperview];
        [self.upgradeTable removeFromSuperview];
    }
    
    // Show Renew/Retain: Gold, Platium, Diamond
    if (cardLevel == 3 || cardLevel == 4 || cardLevel == 5)
    {
        self.retainAsLabel.text = [NSString stringWithFormat:AMLocalizedString(@"account_summary_retain_as", nil), cardLevelDesc];
        self.retainAsQualifyLabel.text = AMLocalizedString(@"account_summary_quali_for_retain", nil);
        self.retainAsExtraLabel.text = AMLocalizedString(@"account_summary_extra_for_retain", nil);
        
        id value1 = detail[RECONSUME_TOTAL];
        if (![value1 isKindOfClass:[NSString class]]) {
            value1 = [detail[RECONSUME_TOTAL] stringValue];
        }
        self.retainAsQualifyValueLabel.text = [NSString stringWithFormat:@"HK$%d", [value1 intValue]];
        
        id value2 = detail[RENEW_NEED_CONSUME];
        if (![value2 isKindOfClass:[NSString class]]) {
            value2 = [detail[RENEW_NEED_CONSUME] stringValue];
        }
        self.retainAsExtraValueLabel.text = [NSString stringWithFormat:@"HK$%d", [value2 intValue]];
    }
    else
    {
        [self.retainAsLabel removeFromSuperview];
        [self.retainTable removeFromSuperview];
    }
    
    self.updatedAsOfLabel.text = nil;//[AMLocalizedString(@"account_summary_updated_as_of", nil) stringByAppendingString:updatedAsOf];
}

@end
