//
//  UserDefaultsUtil.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunicationProtocol.h"

// Keys
#define USER_DEFAULT_LANGUAGE @"language"

// constant values
#define LANG_EN @"en"
#define LANG_ZH_HK @"zh-HK"
#define LANG_ZH_CN @"zh-CN"

#define APPLE_LOCALE_CODE_EN @"en"
#define APPLE_LOCALE_CODE_ZH_HK @"zh-HK"
#define APPLE_LOCALE_CODE_ZH_HANT @"zh-Hant"
#define APPLE_LOCALE_CODE_ZH_HANS @"zh-Hans"

#define LANG_EN_TEXT @"English"
#define LANG_ZH_HK_TEXT @"繁體中文"
#define LANG_ZH_CN_TEXT @"简体中文"

@interface UserDefaultsUtil : NSObject

+ (void)setLanguageCode:(id)value;

+ (id)getLanguageCode;

+ (id)getLocaleCode;

+ (id)getEShopUrl;

+ (id)getShopLocationUrl;

+ (id)getInternationalShopperUrl;

+ (id)getTermsUrl;

+ (id)getPrivacyUrl;

+ (id)getProgrammeTermsUrl;

+ (id)getShareTag;

@end
