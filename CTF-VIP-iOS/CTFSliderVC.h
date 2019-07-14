//
//  CTFSliderVC.h
//  CTF-VIP-iOS
//
//  Created by HughChiu on 2019/7/11.
//  Copyright © 2019 ctf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTFDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTFSliderVC : UIViewController
@property(nonatomic,strong)UIViewController *LeftVC;
@property(nonatomic,strong)UIViewController *RightVC;
@property(nonatomic,strong)UIViewController *MainVC;

@property(nonatomic,assign)float LeftSContentOffset;
@property(nonatomic,assign)float RightSContentOffset;

@property(nonatomic,assign)float LeftSContentScale;
@property(nonatomic,assign)float RightSContentScale;

@property(nonatomic,assign)float LeftSJudgeOffset;
@property(nonatomic,assign)float RightSJudgeOffset;

@property(nonatomic,assign)float LeftSOpenDuration;
@property(nonatomic,assign)float RightSOpenDuration;

@property(nonatomic,assign)float LeftSCloseDuration;
@property(nonatomic,assign)float RightSCloseDuration;

+ (CTFSliderVC *)sharedSliderController;

- (void)showContentControllerWithModel:(NSString*)className animated:(BOOL)flag;
- (void)showContentControllerWithVC:(UIViewController*)viewController animated:(BOOL)flag;
- (void)popSubViewControllerWithModel:(NSString *)className animated:(BOOL)flag;
- (void)presentSubViewController:(UIViewController*)inView animated:(BOOL)flag;
- (void)leftItemClick;
- (void)rightItemClick;
- (void)closeSideBar:(UIGestureRecognizer *)tapGes;
- (void)showMainVC:(UIViewController *)vc;
- (void)unInit;
@end

NS_ASSUME_NONNULL_END
