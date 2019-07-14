//
//  TabViewController.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 18/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

@interface TabViewController : UIViewController <SwipeViewDataSource, SwipeViewDelegate>

@property (weak, nonatomic) IBOutlet SwipeView *tabbarSwipeView;

@property (nonatomic, assign) NSInteger currentTabIndex;

- (void)selectLogin;

- (void)restartCurrentVC;

- (void)loadContentVC:(NSInteger)updateTabIndex force:(BOOL)forceUpdate;

@end
