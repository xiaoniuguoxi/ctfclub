//
//  ColorAndStyle.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 8/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define TAB_MENU_BACKGROUND UIColorFromRGB(0xa861b4)
#define TAB_MENU_BACKGROUND_SELECTED UIColorFromRGB(0x9c50a7)
#define PRIMARY_PURPLE UIColorFromRGB(0x15738c)
#define GRAY_COLOR UIColorFromRGB(0x636363)
