//
//  CommonItemDetailViewController.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "CommonViewController.h"
#import "SwipeView.h"
#import "MWPhotoBrowser.h"

@interface CommonItemDetailViewController : CommonViewController <SwipeViewDataSource, SwipeViewDelegate, UIWebViewDelegate, MWPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UIButton *upperButton;
@property (weak, nonatomic) IBOutlet UIButton *lowerButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic, strong) NSDictionary *item;
@property (nonatomic, assign) int itemId;
@property (nonatomic, copy) NSString *upperButtonTranslationKey;
@property (nonatomic, copy) NSString *lowerButtonTranslationKey;

- (void)assignValues;

- (void)playVideo:(NSString *)videoUrl;

@end
