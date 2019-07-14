//
//  CTFDefine.m
//  CTF-VIP-iOS
//
//  Created by Beeba on 2019/7/11.
//  Copyright © 2019年 ctf. All rights reserved.
//

#import <Foundation/Foundation.h>

//Hugh

// 屏幕宽高
#define SCREEN ([[UIScreen mainScreen] bounds].size)
//状态栏的高度
#define kApplicationStatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height

//判断是否iPhone X
#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// Tabbar safe bottom margin
#define  kTabbarSafeBottomMargin        (IS_iPhoneX ? 34.f : 0.f)

//颜色宏
#define UIColorFromRGBandAlpha(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
