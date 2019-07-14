//
//  UserDefaultsUtil.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "UserDefaultsUtil.h"

@implementation UserDefaultsUtil

+ (void)setUserDefault:(NSString *)key value:(id)value
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setValue:value forKey:key];
    const BOOL didSave = [preferences synchronize];
    
    if (!didSave) {
        // Couldn't save (I've never seen this happen in real world testing)
        //NSLog(@"setUserDefaults failed");
    }
}

+ (id)getUserDefault:(NSString *)key
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    return [preferences objectForKey:key];
}

+ (void)setLanguageCode:(id)value
{
    return [UserDefaultsUtil setUserDefault:USER_DEFAULT_LANGUAGE value:value];
}

+ (id)getLanguageCode
{
    return [UserDefaultsUtil getUserDefault:USER_DEFAULT_LANGUAGE];
}

+ (id)getLocaleCode
{
    id language = [UserDefaultsUtil getUserDefault:USER_DEFAULT_LANGUAGE];
    if ([language isEqualToString:LANG_EN]) {
        return APPLE_LOCALE_CODE_EN;
    } else if ([language isEqualToString:LANG_ZH_HK]) {
        return APPLE_LOCALE_CODE_ZH_HANT;
    } else if ([language isEqualToString:LANG_ZH_CN]) {
        return APPLE_LOCALE_CODE_ZH_HANS;
    }
    return nil;
}

+ (id)getEShopUrl
{
    id language = [UserDefaultsUtil getUserDefault:USER_DEFAULT_LANGUAGE];
    if ([language isEqualToString:LANG_EN]) {
        return ESHOP_URL_EN;
    } else if ([language isEqualToString:LANG_ZH_HK]) {
        return ESHOP_URL_ZH_HK;
    } else if ([language isEqualToString:LANG_ZH_CN]) {
        return ESHOP_URL_ZH_CN;
    }
    return ESHOP_URL_EN;
}

+ (id)getShopLocationUrl
{
    id language = [UserDefaultsUtil getUserDefault:USER_DEFAULT_LANGUAGE];
    if ([language isEqualToString:LANG_EN]) {
        return SHOP_LOCATION_URL_EN;
    } else if ([language isEqualToString:LANG_ZH_HK]) {
        return SHOP_LOCATION_URL_ZH_HK;
    } else if ([language isEqualToString:LANG_ZH_CN]) {
        return SHOP_LOCATION_URL_ZH_CN;
    }
    return SHOP_LOCATION_URL_EN;
}

+ (id)getInternationalShopperUrl
{
    id language = [UserDefaultsUtil getUserDefault:USER_DEFAULT_LANGUAGE];
    if ([language isEqualToString:LANG_EN]) {
        return [HOST_URL stringByAppendingString:INTERNATIONAL_SHOPPER_URL_EN];
    } else if ([language isEqualToString:LANG_ZH_HK]) {
        return [HOST_URL stringByAppendingString:INTERNATIONAL_SHOPPER_URL_ZH_HK];
    } else if ([language isEqualToString:LANG_ZH_CN]) {
        return [HOST_URL stringByAppendingString:INTERNATIONAL_SHOPPER_URL_ZH_CN];
    }
    return [HOST_URL stringByAppendingString:INTERNATIONAL_SHOPPER_URL_EN];
}

+ (id)getTermsUrl
{
    id language = [UserDefaultsUtil getUserDefault:USER_DEFAULT_LANGUAGE];
    if ([language isEqualToString:LANG_EN]) {
        return TERMS_URL_EN;
    } else if ([language isEqualToString:LANG_ZH_HK]) {
        return TERMS_URL_ZH_HK;
    } else if ([language isEqualToString:LANG_ZH_CN]) {
        return TERMS_URL_ZH_CN;
    }
    return TERMS_URL_EN;
}

+ (id)getPrivacyUrl
{
    id language = [UserDefaultsUtil getUserDefault:USER_DEFAULT_LANGUAGE];
    if ([language isEqualToString:LANG_EN]) {
        return PRIVACY_URL_EN;
    } else if ([language isEqualToString:LANG_ZH_HK]) {
        return PRIVACY_URL_ZH_HK;
    } else if ([language isEqualToString:LANG_ZH_CN]) {
        return PRIVACY_URL_ZH_CN;
    }
    return PRIVACY_URL_EN;
}

+ (id)getProgrammeTermsUrl
{
    id language = [UserDefaultsUtil getUserDefault:USER_DEFAULT_LANGUAGE];
    if ([language isEqualToString:LANG_EN]) {
        return [HOST_URL stringByAppendingString:PROGRAMME_TERMS_EN];
    } else if ([language isEqualToString:LANG_ZH_HK]) {
        return [HOST_URL stringByAppendingString:PROGRAMME_TERMS_ZH_HK];
    } else if ([language isEqualToString:LANG_ZH_CN]) {
        return [HOST_URL stringByAppendingString:PROGRAMME_TERMS_ZH_CN];
    }
    return [HOST_URL stringByAppendingString:PROGRAMME_TERMS_EN];
}

+ (id)getShareTag
{
    id language = [UserDefaultsUtil getUserDefault:USER_DEFAULT_LANGUAGE];
    if ([language isEqualToString:LANG_EN]) {
        return SHAREURL_EN;
    } else if ([language isEqualToString:LANG_ZH_HK]) {
        return SHAREURL_ZH_HK;
    } else if ([language isEqualToString:LANG_ZH_CN]) {
        return SHAREURL_ZH_CN;
    }
    return SHAREURL_EN;
}

@end
