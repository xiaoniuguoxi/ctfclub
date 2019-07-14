//
//  LoginUtil.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 2/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUtil : NSObject {
    NSDictionary *detail;
}

@property (nonatomic,retain) NSDictionary *detail;

+ (LoginUtil *)getInstance;

+ (NSString *)getCustomerId;

+ (NSString *)getCardNumber;

+ (NSString *)getPassword;

+ (void)setPassword:(NSString *)password cardNumber:(NSString *)cardNumber;

+ (void)setPassword:(NSString *)password cardNumber:(NSString *)cardNumber customerId:(NSString *)customerId;

+ (void)deletePassword;

+ (BOOL)isValidEmail:(NSString *)checkString;

+ (BOOL)isValidPassword:(NSString *)checkString;

+ (NSString *)encryptPassword:(NSString *)password bySalt:(NSString *)salt;

+ (NSString *)getFullName;

+ (NSString *)getName;

@end
