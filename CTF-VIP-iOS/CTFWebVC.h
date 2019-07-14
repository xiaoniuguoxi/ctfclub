//
//  CTFWebVC.h
//  CTF-VIP-iOS
//
//  Created by Beeba on 2019/7/13.
//  Copyright © 2019年 ctf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTFWebVC : UIViewController
@property (nonatomic, strong) NSString *webUrl;
@property (nonatomic, assign) BOOL shouldFit;
@end

NS_ASSUME_NONNULL_END
