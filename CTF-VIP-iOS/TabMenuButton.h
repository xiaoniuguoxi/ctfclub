//
//  TabMenuButton.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 18/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabMenuButton : UIView

@property (nonatomic, assign) int tabIndex;

- (void)initMenuButton;
- (void)setTabSelected:(BOOL)selected;

@end
