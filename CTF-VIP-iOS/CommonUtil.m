//
//  CommonUtil.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil

+ (UIBarButtonItem *)barButtonItemFromImageNamed:(NSString *)imageName target:(id)target selector:(SEL)selector
{
    return [self barButtonItemFromImageNamed:imageName target:target selector:selector disableImageNamed:nil];
}

+ (UIBarButtonItem *)barButtonItemFromImageNamed:(NSString *)imageName target:(id)target selector:(SEL)selector disableImageNamed:(NSString *)disableImageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *buttonImage = [UIImage imageNamed:imageName];
    button.bounds = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    if (disableImageName) {
        [button setImage:[UIImage imageNamed:disableImageName] forState:UIControlStateDisabled];
    }
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButtonItem;
}

@end
