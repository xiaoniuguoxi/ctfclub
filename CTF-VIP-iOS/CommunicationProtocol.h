//
//  CommunicationProtocol.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 23/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import <UIKit/UIKit.h>

// API URL
#ifdef DEBUG
//#define HOST_URL @"http://demo7.hkitechplus.org/ctf/"
#define HOST_URL @"https://club.samprasdev.com/"
#define IMAGE_DIR_URL @"http://demo7.hkitechplus.org/ctf/image/"
#else
//#define HOST_URL @"https://www.ctfclub.chowtaifook.com/"
#define HOST_URL @"https://club.samprasdev.com/"
#define IMAGE_DIR_URL @"http://www.ctfclub.chowtaifook.com/image/"
#endif

// Member Area
#define PDF2_URL @"http://www.ctfclub.chowtaifook.com/image/ctf-form-2.pdf"
#define PDF1_URL @"http://www.ctfclub.chowtaifook.com/image/ctf-form-1.pdf"

// First Time Reg
#define ROUTE_STORE_ADDRESSES @"?route=api2/connect/store_addresses"

// Advertisement
#define ROUTE_GET_ADVERTISEMENT @"?route=api2/advertisement/getAdvertisement"

// E-SHOP URL
#define ESHOP_URL_EN @"https://www.ctfeshop.com.hk/?lang=en"
#define ESHOP_URL_ZH_HK @"https://www.ctfeshop.com.hk/?lang=hk"
#define ESHOP_URL_ZH_CN @"https://www.ctfeshop.com.hk/?lang=hk"

// Shop Location
#define SHOP_LOCATION_URL_EN @"http://www.chowtaifook.com/en/shop.html"
#define SHOP_LOCATION_URL_ZH_HK @"http://www.chowtaifook.com/zh-hant/shop.html"
#define SHOP_LOCATION_URL_ZH_CN @"http://www.ctf.com.cn/zh-hans/shop.html"

// International Shopper
#define INTERNATIONAL_SHOPPER_URL_EN @"korea?language=en&mobile=0"
#define INTERNATIONAL_SHOPPER_URL_ZH_HK @"korea?language=zh-HK&mobile=0"
#define INTERNATIONAL_SHOPPER_URL_ZH_CN @"korea?language=zh-CN&mobile=0"

// Banner
#define ROUTE_GET_BANNERS @"?route=api2/banner/getBanner"

// HomePage
#define ROUTE_GET_HOME_PAGE @"?route=api2/member2/getHomePage"

// MenuTop
#define ROUTE_GET_MENU_TOP @"?route=api2/member2/getGoidPrice"

// News
#define ROUTE_GET_NEWS_CATEGORY @"?route=api2/news/getNewsCategory"
#define ROUTE_GET_NEWSES @"?route=api2/news/getNewses"
#define ROUTE_GET_NEWS @"?route=api2/news/getNews"

// Event
#define ROUTE_GET_EVENT_CATEGORY @"?route=api2/events/getEventCategory"
#define ROUTE_GET_EVENTS @"?route=api2/events/getEventes"
#define ROUTE_GET_EVENT @"?route=api2/events/getEvent"
#define ROUTE_APPLY_EVENT @"?route=api2/apply/Events"

// Birthday Offers
#define ROUTE_GET_BIRTHDAY_OFFERS_CATEGORY @"?route=api2/birthday/getBirthdayCategory"
#define ROUTE_GET_BIRTHDAY_OFFERS @"?route=api2/birthday/getBirthdayes"
#define ROUTE_GET_BIRTHDAY_OFFER @"?route=api2/birthday/getBirthday"
#define ROUTE_APPLY_BIRTHDAY_OFFER @"?route=api2/apply/Birthday"
#define ROUTE_GET_SHOP_ZONE @"?route=api2/apply/getshopzone"

// Staff Rating
#define ROUTE_GET_STAFF_RATING_OPTION @"?route=api2/apply/getStaffsratingOption"
#define ROUTE_APPLY_STAFF_RATING @"?route=api2/apply/Staffsrating"

// Service & Product Inquiry
#define ROUTE_INQUIRY @"?route=api2/inquiry/inquiry"

// Concierge
#define CONCIERGE_SERVICE_URL @"?route=account/login/by_hash&language=%@&card_number=%@&hash=%@&redirect=information/concierge&mobile=1"

// Questionnaire
#define QUESTIONNAIRE_URL @"app_questionnaires_details/2/%@&a=%@&b=%@"

// About CTF Club
#define ROUTE_GET_INFORMATION_CATEGORY @"?route=api2/information/getInformationCategory"
#define ROUTE_GET_INFORMATION @"?route=api2/information/getInformation"
#define INTRODUCTION_INFORMATION_ID 7
#define MEMBERSHIP_TIER_INFORMATION_ID 8
#define PROGRAMME_DETAILS_INFORMATION_ID 9
#define REWARDS_INFORMATION_ID 14

// Newsletter
#define ROUTE_GET_NEWSLETTERS @"?route=api2/newsletter/getNewsletters"

// Lifestyle Journal
#define ROUTE_GET_LIFESTYLE_CATEGORY @"?route=api2/lifestyle/getLifestyleCategory"
#define ROUTE_GET_LIFESTYLES @"?route=api2/lifestyle/getLifestylees"
#define ROUTE_GET_LIFESTYLE @"?route=api2/lifestyle/getlifestyle"

// Gold Price
#define ROUTE_GET_GOLD_PRICE @"?route=api2/gold_price/getGoldPrice2"

// Contact Us
#define ROUTE_CONTACT_US @"?route=api2/contact/contact"

// Settings
#define TERMS_URL_EN @"http://corporate.chowtaifook.com/en/global/terms.php"
#define TERMS_URL_ZH_HK @"http://corporate.chowtaifook.com/tc/global/terms.php"
#define TERMS_URL_ZH_CN @"http://corporate.chowtaifook.com/sc/global/terms.php"

#define PRIVACY_URL_EN @"http://corporate.chowtaifook.com/en/global/privacy.php"
#define PRIVACY_URL_ZH_HK @"http://corporate.chowtaifook.com/tc/global/privacy.php"
#define PRIVACY_URL_ZH_CN @"http://corporate.chowtaifook.com/sc/global/privacy.php"

#define PROGRAMME_TERMS_EN @"?route=information/information&language=en&information_id=13&mobile=1"
#define PROGRAMME_TERMS_ZH_HK @"?route=information/information&language=zh-HK&information_id=13&mobile=1"
#define PROGRAMME_TERMS_ZH_CN @"?route=information/information&language=zh-CN&information_id=13&mobile=1"

#define HELP_INFORMATION_ID 15

// Login
#define ROUTE_LOGIN_SALT @"?route=api2/connect/salt"
#define ROUTE_LOGIN_CHECK @"?route=api2/connect/check"
#define ROUTE_LOGIN_FORGET @"?route=api2/connect/forget"
#define ROUTE_CHANGE_PASSWORD @"?route=api2/password/changePassword"
#define ROUTE_GET_CARD_IMAGE @"?route=api2/connect/get_card_image"
#define ROUTE_FINISH @"?route=api2/connect/finish"

// JSON Keys
#define PARAMETER @"parameters"
#define TAG @"tag"
#define OUT @"out"
#define STATUS @"status"
#define SUCCESS @"success"
#define ERROR @"error"
#define PAGE @"page"
#define PAGE_TOTAL @"page_total"
#define LIMIT @"limit"

#define CUSTOMER_ID @"customer_id"
#define LOGIN_CUSTOMER_ID @"Customer_ID"
#define CARD_NUMBER @"card_number"
#define MEMBER_CARD_NUMBER @"member_card_number"
#define SALT @"salt"
#define HASH @"hash"
#define DETAIL @"detail"

#define Customer_Eng_Name @"Customer_Eng_Name"
#define English_Family_Name @"English_Family_Name"
#define Chinese_Family_Name @"Chinese_Family_Name"
#define Customer_Chi_Name @"Customer_Chi_Name"
#define Customer_Title_Desc @"Customer_Title_Desc"
#define Customer_Title_Desc_Eng @"Customer_Title_Desc_Eng"

#define CARD_LEVEL @"Card_Level"

#define CARD_LEVEL_DESC @"Card_Level_Desc"
#define CARD_LEVEL_DESC_EN @"Card_Level_Desc_en"
#define CARD_LEVEL_DESC_CHT @"Card_Level_Desc_cht"
#define CARD_LEVEL_DESC_CHS @"Card_Level_Desc_chs"

#define NEXT_CARD_LEVEL_DESC @"NextCardLevelDesc"
#define NEXT_CARD_LEVEL_DESC_EN @"NextCardLevelDesc_en"
#define NEXT_CARD_LEVEL_DESC_CHT @"NextCardLevelDesc_cht"
#define NEXT_CARD_LEVEL_DESC_CHS @"NextCardLevelDesc_chs"

#define CONSUME_TOTAL @"Consume_Total"
#define UPGRADE_NEED_CONSUME @"UpgradeNeedConsume"
#define RECONSUME_TOTAL @"ReConsume_Total"
#define RENEW_NEED_CONSUME @"RenewNeedConsume"
#define LAST_MODIFY @"Last_Modify"
#define DATE @"date"
#define TEL1 @"Tel1"
#define EMAIL_ADD @"Email_Add"

#define NEED_FINISH_ADDRESS @"need_finish_address"
#define GETCARD @"getcard"
#define BRANCH @"branch"
#define MAIL @"mail"
#define MON @"mon"
#define DAY @"day"

#define BRANCH_LONG @"Branch Long"
#define DISTRICT_DESC @"District Desc"
#define BRIEF_ADDRESS @"Brief Address"
#define BRANCH_CODE @"Branch Code"

#define BANNERS @"banners"
#define APPURL @"appurl"

#define ADVERTISEMENTES @"advertisementes"
#define PURL @"url"

#define NAME @"name"
#define TITLE @"title"
#define IMAGES @"images"
#define IMAGE @"image"
#define THUMB @"thumb"
#define POPUP @"popup"
#define VIDEO @"video"
#define DESCRIPTION @"description"
#define SHAREURL_EN @"shareurl_en"
#define SHAREURL_ZH_HK @"shareurl_zh-HK"
#define SHAREURL_ZH_CN @"shareurl_zh-CN"
#define BUTTON_BOOK_SHOW @"button_book_show"
#define BEFORE_LOGIN_SHOW_BUTTON @"beforeloginshowbutton"
#define AGREE_NUMBER @"agree_number"
#define TERM @"term"
#define TEXT_SHOW_END @"text_show_end"
#define FULL_MESSAGE @"full_message"
#define MESSAGE @"message"

#define NEWS_CATEGORIES @"news_categories"
#define NEWS_CATEGORY @"news_category"
#define NEWS_CATEGORY_ID @"news_category_id"
#define CATEGORY_ID @"category_id"
#define NEWS @"news"
#define NEWSES @"newses"
#define NEWS_ID @"news_id"

#define EVENTS_CATEGORIES @"events_categories"
#define EVENTS_CATEGORY @"events_category"
#define EVENTS_CATEGORY_ID @"events_category_id"
#define EVENTES @"eventes"
#define EVENTS @"events"
#define EVENT @"event"
#define EVENTS_ID @"events_id"
#define EVENT_ID @"event_id"

#define ACTIVITY_ID @"activity_id"
#define CARRY_NO @"carry_no"
#define CONTACT @"contact"

#define MEMBER_LEVEL @"member_level"
#define MEMBER_LEVEL_ID @"member_level_id"
#define BIRTHDAYES @"birthdayes"
#define BIRTHDAY @"birthday"
#define GIFT_ID @"gift_id"
#define BIRTHDAY_ID @"birthday_id"
#define SELECTES @"selectes"
#define GIFT_SELECT_ID @"gift_select_id"
#define COLLECT_TYPE @"collect_type"
#define SHOP_ID @"shop_id"
#define ADDRESS @"address"
#define ADDRESSES @"addresses"
#define SHOP_ZONES @"shop_zones"
#define SHOP_ZONE_ID @"shop_zone_id"
#define SHOPS @"shops"

#define INFORMATION @"information"
#define INFORMATION_ID @"information_id"

#define NEWSLETTERS @"newsletters"
#define YEAR @"year"
#define MONTH @"month"
#define LINK @"link"

#define LIFESTYLE_CATEGORIES @"lifestyle_categories"
#define LIFESTYLE_CATEGORY @"lifestyle_category"
#define LIFESTYLE_CATEGORY_ID @"lifestyle_category_id"
#define LIFESTYLEES @"lifestylees"
#define LIFESTYLE @"lifestyle"
#define LIFESTYLE_ID @"lifestyle_id"

#define LAST_UPDATE_DATETIME @"last_update_datetime"
#define GOLD_BUY @"999_gold_buy"
#define GOLD_SELL @"999_gold_sell"
#define HUANJIN_BUY @"huanjin_buy"
#define HUANJIN_SELL @"huanjin_sell"
#define PLATINUM_BUY @"zubaijin_buy"
#define PLATINUM_SELL @"zubaijin_sell"
#define GOLD_PELLET_BUY @"jinli_buy"
#define GOLD_PELLET_SELL @"jinli_sell"

#define EXCHANGE_RATE @"exchange_rate"

#define GENDER @"gender"
#define REALNAME @"realname"
#define TELEPHONE @"telephone"
#define TELEPHONE_ZONE @"telephone_zone"
#define EMAIL @"email"
#define ENQUIRY @"enquiry"

#define OPTIONES @"optiones"
#define TYPE @"type"
#define STAFF_RATING_OPTION_ID @"staffsrating_option_id"
#define STAFF_RATING_OPTION_VALUE_ID @"staffsrating_option_value_id"
#define VALUE @"value"
#define VALUE2 @"value2"

#define file_data @"data"
#define file_name @"name"
#define file_filename @"filename"
#define file_mimetype @"mimeType"

@protocol CommunicatorProtocolDelegate

@optional
- (void)handleError:(NSDictionary *)jsonObject;

@required
- (void)handleResponse:(NSDictionary *)jsonObject;

@end

@interface CommunicationProtocol : NSObject

@property (nonatomic, weak) id delegate;

- (void)startIndicator;

- (void)stopIndicator;

- (void)fetchRequestToUrl:(NSString *)url parameters:(NSDictionary *)parameters tag:(NSString *)tag;

- (void)fetchRequestToUrl:(NSString *)url isPost:(BOOL)isPost parameters:(NSDictionary *)parameters tag:(NSString *)tag;

- (void)fetchRequestToUrl:(NSString *)url isPost:(BOOL)isPost parameters:(NSDictionary *)parameters dataDict:(NSDictionary *)dataDict tag:(NSString *)tag;

@end
