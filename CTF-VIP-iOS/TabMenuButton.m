//
//  TabMenuButton.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 18/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "TabMenuButton.h"
#import "ColorAndStyle.h"
#import "LocalizationSystem.h"

@interface TabMenuButton ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TabMenuButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code.
        //
        [[NSBundle mainBundle] loadNibNamed:@"TabMenuButton" owner:self options:nil];
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)initMenuButton
{
    self.iconImageView.image = [self iconImage];
    self.titleLabel.text = AMLocalizedString([self titleCode], nil);
}

- (void)setTabSelected:(BOOL)selected
{
    // Selected background color
    self.backgroundView.backgroundColor = [TAB_MENU_BACKGROUND_SELECTED colorWithAlphaComponent:selected ? 1.0f : 0.0f];
}

- (UIImage *)iconImage
{
    switch (self.tabIndex) {
        case 0:
            return [UIImage imageNamed:@"Tab_Menu_01MemberArea"];
            
        case 1:
            return [UIImage imageNamed:@"Tab_Menu_02NewsPromotions"];
            
        case 2:
            return [UIImage imageNamed:@"Tab_Menu_03Events"];
            
        case 3:
            return [UIImage imageNamed:@"Tab_Menu_04BirthdayOffers"];
            
        case 4:
            return [UIImage imageNamed:@"Tab_Menu_05EShop"];
            
        case 5:
            return [UIImage imageNamed:@"Tab_Menu_06ConciergeService"];
            
        case 6:
            return [UIImage imageNamed:@"Tab_Menu_15StaffRating"];
            
        case 7:
            return [UIImage imageNamed:@"Tab_Menu_08ServiceProductInquiry"];
            
        case 8:
            return [UIImage imageNamed:@"Tab_Menu_09AboutCTFClub"];
            
        case 9:
            return [UIImage imageNamed:@"Tab_Menu_10Newsletter"];
            
        case 10:
            return [UIImage imageNamed:@"Tab_Menu_11LifestyleJournal"];
            
        case 11:
            return [UIImage imageNamed:@"Tab_Menu_12ShopLocation"];
            
        case 12:
            return [UIImage imageNamed:@"Tab_Menu_13DailyGoldPrice"];
            
        case 13:
            return [UIImage imageNamed:@"Tab_Menu_14ContactUs"];
            
        case 14:
            return [UIImage imageNamed:@"Tab_Menu_InternationalShopper"];
            
        case 15:
            return [UIImage imageNamed:@"Tab_Menu_16Settings"];
            
        default:
            break;
    }
    return nil;
}

- (NSString *)titleCode
{
    switch (self.tabIndex) {
        case 0:
            return @"member_area";
            
        case 1:
            return @"news_promotions";
            
        case 2:
            return @"events";
            
        case 3:
            return @"birthday_offers";
            
        case 4:
            return @"eshop";
            
        case 5:
            return @"concierge_service";
            
        case 6:
            return @"staff_rating";
            
        case 7:
            return @"service_product_inquiry";
            
        case 8:
            return @"about_ctf_club";
            
        case 9:
            return @"newsletter";
            
        case 10:
            return @"lifestyle_journal";
            
        case 11:
            return @"shop_location";
            
        case 12:
            return @"daily_gold_price";
            
        case 13:
            return @"contact_us";
            
        case 14:
            return @"international_shopper";
            
        case 15:
            return @"settings";
            
        default:
            break;
    }
    return nil;
}

@end
