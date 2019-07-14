//
//  LoginUtil.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 2/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "LoginUtil.h"
#import <CommonCrypto/CommonHMAC.h>
#import "SSKeychain.h"
#import "UserDefaultsUtil.h"

#define SERVICE_NAME_LOGIN @"CTF_VIP_CLUB_PASSWORD"
#define SERVICE_NAME_CUSTOMER_ID @"CTF_VIP_CLUB_CUSTOMER_ID"

@implementation LoginUtil

@synthesize detail;

static LoginUtil *instance = nil;

+ (LoginUtil *)getInstance
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance= [LoginUtil new];
        }
    }
    return instance;
}

+ (NSString *)getCustomerId
{
    return [SSKeychain passwordForService:SERVICE_NAME_CUSTOMER_ID account:[self getCardNumber]];
}

+ (NSString *)getCardNumber
{
    NSArray *accounts = [SSKeychain accountsForService:SERVICE_NAME_LOGIN];
    if (accounts && accounts.count > 0) {
        return [accounts firstObject][@"acct"];
    }
    return nil;
}

+ (NSString *)getPassword
{
    return [SSKeychain passwordForService:SERVICE_NAME_LOGIN account:[self getCardNumber]];
}

+ (void)setPassword:(NSString *)password cardNumber:(NSString *)cardNumber
{
    [SSKeychain setPassword:password forService:SERVICE_NAME_LOGIN account:cardNumber];
}

+ (void)setPassword:(NSString *)password cardNumber:(NSString *)cardNumber customerId:(NSString *)customerId
{
    [self setPassword:password cardNumber:cardNumber];
    [SSKeychain setPassword:customerId forService:SERVICE_NAME_CUSTOMER_ID account:cardNumber];
}

+ (void)deletePassword
{
    [SSKeychain deletePasswordForService:SERVICE_NAME_LOGIN account:[self getCardNumber]];
    [SSKeychain deletePasswordForService:SERVICE_NAME_CUSTOMER_ID account:[self getCardNumber]];
}

+ (BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+ (BOOL)isValidPassword:(NSString *)checkString
{
    return checkString.length >= 4 && checkString.length <= 20;
}

+ (NSString *)SHA1:(NSString*)input;
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

+ (NSString *)encryptPassword:(NSString *)password bySalt:(NSString *)salt
{
    // Hashing formula provided by backend programmer
    NSString *hashing = [self SHA1:password];
    hashing = [self SHA1:[salt stringByAppendingString:hashing]];
    NSString *hashPassword = [self SHA1:[salt stringByAppendingString:hashing]];
    
    return hashPassword;
}

+ (NSString *)getFullName
{
    NSDictionary *detail = [self getInstance].detail;
    
    NSString *engName = [NSString stringWithFormat:@"%@ %@", detail[Customer_Eng_Name], detail[English_Family_Name]];
    NSString *chiName = [NSString stringWithFormat:@"%@%@", detail[Chinese_Family_Name], detail[Customer_Chi_Name]];
    
    if ([[UserDefaultsUtil getLanguageCode] isEqualToString:LANG_EN]) {
        if (engName.length <= 1) {
            return [NSString stringWithFormat:@"%@%@", chiName, detail[Customer_Title_Desc]];
        }
        return [NSString stringWithFormat:@"%@ %@", detail[Customer_Title_Desc_Eng], engName];
    } else {
        if (chiName.length <= 0) {
            return [NSString stringWithFormat:@"%@ %@", detail[Customer_Title_Desc_Eng], engName];
        }
        return [NSString stringWithFormat:@"%@%@", chiName, detail[Customer_Title_Desc]];
    }
}

+ (NSString *)getName
{
    NSDictionary *detail = [self getInstance].detail;
    
    NSString *engName = [NSString stringWithFormat:@"%@ %@", detail[Customer_Eng_Name], detail[English_Family_Name]];
    NSString *chiName = [NSString stringWithFormat:@"%@%@", detail[Chinese_Family_Name], detail[Customer_Chi_Name]];
    
    if ([[UserDefaultsUtil getLanguageCode] isEqualToString:LANG_EN]) {
        if (engName.length <= 1) {
            return chiName;
        }
        return engName;
    } else {
        if (chiName.length <= 0) {
            return engName;
        }
        return chiName;
    }
}

@end
