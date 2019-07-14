//
//  CTFSliderVC.m
//  CTF-VIP-iOS
//
//  Created by HughChiu on 2019/7/11.
//  Copyright © 2019 ctf. All rights reserved.
//

#import "CTFSliderVC.h"
#import "CTFNavC.h"
#import "CTFHomeVC.h"

typedef NS_ENUM(NSInteger, RMoveDirection) {
    RMoveDirectionLeft = 0,
    RMoveDirectionRight
};

@interface CTFSliderVC ()<UIGestureRecognizerDelegate>{
    UIView *_mainContentView;
    UIView *_leftSideView;
    UIView *_rightSideView;
    
    NSMutableDictionary *_controllersDict;
    
    UITapGestureRecognizer *_tapGestureRec;
    UIPanGestureRecognizer *_panGestureRec;
}

@end

@implementation CTFSliderVC

#if __has_feature(objc_arc)
#else
-(void)dealloc{
    [_mainContentView release];
    [_leftSideView release];
    [_rightSideView release];
    
    [_controllersDict release];
    
    [_tapGestureRec release];
    [_panGestureRec release];
    
    [_leftVC release];
    [_rightVC release];
    [_MainVC release];
    [super dealloc];
}
#endif

+ (CTFSliderVC *)sharedSliderController
{
    static CTFSliderVC *sharedSVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSVC = [[self alloc] init];
    });
    
    return sharedSVC;
}

- (id)init{
    if (self = [super init]){
        _LeftSContentOffset     = SCREEN.width;
        _RightSContentOffset    = 0;
        _LeftSContentScale      = 1.0;
        _RightSContentScale     = 1.0;
        _LeftSJudgeOffset       = 100;
        _RightSJudgeOffset      = 100;
        _LeftSOpenDuration      = 0.4;
        _RightSOpenDuration     = 0.4;
        _LeftSCloseDuration     = 0.3;
        _RightSCloseDuration    = 0.3;
    }
    
    return self;
}

- (void)unInit{
    if ([NSThread isMainThread])
    {
        if (_mainContentView)
        {
            for (UIView *subview in [_mainContentView subviews]) {
                subview.userInteractionEnabled = YES;
                [subview removeFromSuperview];
            }
            _mainContentView = nil;
        }
        
        _leftSideView = nil;
        _rightSideView = nil;
        
        [_controllersDict removeAllObjects];
        _controllersDict = nil;
        
        _tapGestureRec.delegate = nil;
        _tapGestureRec = nil;
        _panGestureRec.delegate = nil;
        _panGestureRec = nil;
        
        self.leftVC = nil;
        self.rightVC = nil;
        self.MainVC = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"SliderViewController viewWillAppear。");
    [super viewWillAppear:animated];
    if (_controllersDict)
    {
        [_controllersDict removeAllObjects];
        _controllersDict = nil;
    }
    _controllersDict = [NSMutableDictionary dictionary];
    
    if (_mainContentView)
    {
        for (UIView *subview in [_mainContentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    [self initSubviews];
    
    [self initChildControllers:_LeftVC rightVC:_RightVC];
    
    
    //载入默认首页
    CTFHomeVC *homeVC = [[CTFHomeVC alloc] init];
    CTFNavC *contentNav = [[CTFNavC alloc] initWithRootViewController:homeVC];
    [self showContentControllerWithVC:contentNav animated:NO];
    
    
    
    _tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideBar:)];
    _tapGestureRec.delegate = self;
    [self.view addGestureRecognizer:_tapGestureRec];
    _tapGestureRec.enabled = NO;
    
    _panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    [_mainContentView addGestureRecognizer:_panGestureRec];
    
    [self.MainVC viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.MainVC)
    {
        [self.MainVC viewDidAppear:animated];
    }
    [self.view layoutSubviews];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.MainVC)
    {
        [self.MainVC viewWillDisappear:animated];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"slider viewDidLoad.");
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"slider didReceiveMemoryWarning.");
}

#pragma mark - Init
#define     LEFT_SIDE_VIEW_TAG          2001
#define     MAIN_SIDE_VIEW_TAG          2002
#define     RIGHT_SIDE_VIEW_TAG         2003
- (void)initSubviews
{
    //    _rightSideView = [[UIView alloc] initWithFrame:self.view.bounds];
    //    [self.view addSubview:_rightSideView];
    
    UIView *subview = nil;
    subview = [self.view viewWithTag:LEFT_SIDE_VIEW_TAG];
    if (subview)
    {
        [subview removeFromSuperview];
    }
    _leftSideView = [[UIView alloc] initWithFrame:self.view.bounds];
    _leftSideView.tag = LEFT_SIDE_VIEW_TAG;
    [self.view addSubview:_leftSideView];
    
    subview = nil;
    subview = [self.view viewWithTag:MAIN_SIDE_VIEW_TAG];
    if (subview)
    {
        [subview removeFromSuperview];
    }
    _mainContentView = [[UIView alloc] initWithFrame:self.view.bounds];
    _mainContentView.tag = MAIN_SIDE_VIEW_TAG;
    [self.view addSubview:_mainContentView];
}

- (void)initChildControllers:(UIViewController*)leftVC rightVC:(UIViewController*)rightVC
{
    if (leftVC)
    {
        [self addChildViewController:leftVC];
        leftVC.view.frame=CGRectMake(0, 0, leftVC.view.frame.size.width, leftVC.view.frame.size.height);
        [_leftSideView addSubview:leftVC.view];
    }
    
    if (rightVC)
    {
        [self addChildViewController:rightVC];
        rightVC.view.frame=CGRectMake(0, 0, rightVC.view.frame.size.width, rightVC.view.frame.size.height);
        [_rightSideView addSubview:rightVC.view];
    }
}

#pragma mark - Actions
- (void)presentSubViewController:(UIViewController*)inView animated:(BOOL)flag
{
    [UIView setAnimationsEnabled:YES];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationStartDate:[NSDate date]];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if ([_mainContentView viewWithTag:inView.view.tag])
    {
        [inView viewWillAppear:flag];
        return;
    }
    if (flag)
    {
        // 添加动画
        inView.view.frame = CGRectOffset(inView.view.frame, 0.0, inView.view.frame.size.height);
        [_mainContentView addSubview:inView.view];
        [UIView animateWithDuration:0.4
                         animations:^{
                             inView.view.frame = CGRectOffset(self.view.frame, 0, -30);
                             //inView.view.frame = self.view.frame;
                         } completion:^(BOOL finished) {
                             if (finished)
                             {
                                 [UIView animateWithDuration:0.2 animations:^{
                                     inView.view.frame = CGRectOffset(self.view.frame, 0, 10);
                                 } completion:^(BOOL finished) {
                                     if (finished)
                                     {
                                         [UIView animateWithDuration:0.1 animations:^{
                                             inView.view.frame = self.view.frame;
                                         }];
                                     }
                                 }];
                             }
                         }];
    }
    else
    {
        [_mainContentView addSubview:inView.view];
        [inView viewWillAppear:NO];
    }
    
}

- (void)showMainVC:(UIViewController *)vc {
    [UIView setAnimationsEnabled:YES];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationStartDate:[NSDate date]];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//
//    [self showContentControllerWithVC:vc animated:YES];
    
//    [_mainContentView ]
    
    [self closeSideBar:nil];
    
    for (UIView *aview in _mainContentView.subviews) {
        [aview removeFromSuperview];
    }
    vc.view.frame = _mainContentView.frame;
    [_mainContentView addSubview:vc.view];
    self.MainVC = vc;
}

- (void)showContentControllerWithModel:(NSString *)className animated:(BOOL)flag
{
    [UIView setAnimationsEnabled:YES];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationStartDate:[NSDate date]];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self closeSideBar:nil];
    self.MainVC = nil;
    
    NSString *newClassName = nil;
    NSRange range = [className rangeOfString:@"_ip5"];
    if (range.location != NSNotFound && range.location < [className length])
    {
        newClassName = [className substringToIndex:range.location];
    }
    else
    {
        newClassName = className;
    }
    
    for (UIView *psubview in [_mainContentView subviews])
    {
        [psubview removeFromSuperview];
    }
    
    UIViewController *oldController = [_controllersDict objectForKey:newClassName];
    if (oldController)
    {
        [oldController viewDidUnload];
    }
    
    for (NSString *viewName in [_controllersDict allKeys]) {
        UIViewController *viewControl = [_controllersDict objectForKey:viewName];
        [viewControl viewWillDisappear:YES];
        [viewControl.view removeFromSuperview];
    }
    [_controllersDict removeAllObjects];
    
    Class c = NSClassFromString(newClassName);
    
//    UIViewController *controller = [[c alloc] initWithNibName:className bundle:nil];
    UIViewController *controller = [[c alloc] init];
    [_controllersDict setObject:controller forKey:newClassName];
    
    if (flag && [_mainContentView.subviews count] > 0)
    {
        controller.view.frame = CGRectOffset(_mainContentView.frame, _mainContentView.frame.size.width, 0);
        [_mainContentView addSubview:controller.view];
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             controller.view.frame = _mainContentView.frame;
                         } completion:^(BOOL finished) {
                         }];
    }
    else
    {
        controller.view.frame = _mainContentView.frame;
        [_mainContentView addSubview:controller.view];
    }
    
    self.MainVC = controller;
}

- (void)showContentControllerWithVC:(UIViewController*)viewController animated:(BOOL)flag
{
    NSString *className = NSStringFromClass([viewController class]);
    if (className && [_controllersDict objectForKey:className])
    {
        return;
    }
    if (viewController == nil || className == nil)
    {
        return;
    }
    [_controllersDict setObject:viewController forKey:className];
    
    viewController.view.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    viewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    viewController.view.layer.shadowOpacity = 0.3f;
    if (flag && [_mainContentView.subviews count] > 0)
    {
        UIView *oldView = [_mainContentView.subviews lastObject];
        viewController.view.frame = CGRectOffset(_mainContentView.frame, _mainContentView.frame.size.width, 0);
        [_mainContentView addSubview:viewController.view];
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             viewController.view.frame = _mainContentView.frame;
                             oldView.frame = CGRectOffset(_mainContentView.frame, -_mainContentView.frame.size.width, 0);
                         } completion:^(BOOL finished) {
                             if (finished)
                             {
                                 oldView.frame = _mainContentView.frame;
                                 //oldView.hidden = YES;
                             }
                         }];
    }
    else
    {
        viewController.view.frame = _mainContentView.frame;
        [_mainContentView addSubview:viewController.view];
    }
    self.MainVC = viewController;
}

- (void)popSubViewControllerWithModel:(NSString *)className animated:(BOOL)flag
{
    NSString *newClassName = nil;
    NSRange range = [className rangeOfString:@"_ip5"];
    if (range.location != NSNotFound && range.location < [className length])
    {
        newClassName = [className substringToIndex:range.location];
    }
    else
    {
        newClassName = className;
    }
    //NSLog(@"%@", _controllersDict);
    if ([_mainContentView.subviews count] >= 2)
    {
        UIView *lastView = [_mainContentView.subviews lastObject];
        UIView *pushedView = [_mainContentView.subviews objectAtIndex:[_mainContentView.subviews count]-2];
        pushedView.hidden = NO;
        if (flag)
        {
            [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 pushedView.frame = _mainContentView.frame;
                                 lastView.frame = CGRectOffset(_mainContentView.frame, _mainContentView.frame.size.width, 0);
                             } completion:^(BOOL finished) {
                                 if (finished)
                                 {
                                     [lastView removeFromSuperview];
                                     if (newClassName)
                                     {
                                         [_controllersDict removeObjectForKey:newClassName];
                                     }
                                 }
                             }];
        }
        else
        {
            pushedView.frame = _mainContentView.frame;
            [lastView removeFromSuperview];
            if (newClassName)
            {
                [_controllersDict removeObjectForKey:newClassName];
            }
        }
        for (UIViewController *item in [_controllersDict allValues])
        {
            if (item.view == pushedView)
            {
                [item viewWillAppear:YES];
            }
        }
    }
    self.MainVC = nil;
}

- (void)leftItemClick
{
    CGAffineTransform conT = [self transformWithDirection:RMoveDirectionRight];
    
    [self.view sendSubviewToBack:_rightSideView];
    [self configureViewShadowWithDirection:RMoveDirectionRight];
    
    [UIView animateWithDuration:_LeftSOpenDuration
                     animations:^{
                         _mainContentView.transform = conT;

                     }
                     completion:^(BOOL finished) {
                         _tapGestureRec.enabled = YES;
                         for (UIView *subview in _mainContentView.subviews)
                         {
                             subview.userInteractionEnabled = NO;
                         }
                         [_LeftVC viewWillAppear:YES];
                         

                     }];
}

- (void)rightItemClick
{
    CGAffineTransform conT = [self transformWithDirection:RMoveDirectionLeft];
    
    [self.view sendSubviewToBack:_leftSideView];
    
    [UIView animateWithDuration:_RightSOpenDuration
                     animations:^{
                         _mainContentView.transform = conT;
                     }
                     completion:^(BOOL finished) {
                         _tapGestureRec.enabled = YES;
                     }];
}


- (void)closeSideBar:(UIGestureRecognizer *)tapGes
{
//    [[AppDelegate instance] appdelegateHideVolumeView];
    CGAffineTransform oriT = CGAffineTransformIdentity;
    [UIView animateWithDuration:_mainContentView.transform.tx==_LeftSContentOffset?_LeftSCloseDuration:_RightSCloseDuration
                     animations:^{
                         _mainContentView.transform = oriT;
                         UIView *miniplayerview = [self.navigationController.view viewWithTag:1214];
                         UIView *headerView = [self.navigationController.view viewWithTag:1215];
                         if (miniplayerview)
                         {
                             miniplayerview.transform = oriT;
                             miniplayerview.userInteractionEnabled = YES;
                         }
                         if (headerView)
                         {
                             headerView.transform = oriT;
                             headerView.userInteractionEnabled = YES;
                         }
                     }
                     completion:^(BOOL finished) {
                         _tapGestureRec.enabled = NO;
                         [_LeftVC viewWillDisappear:YES];
                         for (UIView *subview in _mainContentView.subviews)
                         {
                             subview.userInteractionEnabled = YES;
                         }
                         
                         [UIView animateWithDuration:0.2 animations:^{
                             _mainContentView.frame = CGRectOffset(_mainContentView.frame, 7, 0);
                             UIView *miniplayerview = [self.navigationController.view viewWithTag:1214];
                             UIView *headerView = [self.navigationController.view viewWithTag:1215];
                             miniplayerview.frame = CGRectOffset(miniplayerview.frame, 7, 0);
                             headerView.frame = CGRectOffset(headerView.frame, 7, 0);
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.2 animations:^{
                                 _mainContentView.frame = self.view.frame;//CGRectOffset(_mainContentView.frame, -7, 0);
                                 UIView *miniplayerview = [self.navigationController.view viewWithTag:1214];
                                 UIView *headerView = [self.navigationController.view viewWithTag:1215];
                                 miniplayerview.frame = CGRectOffset(miniplayerview.frame, -7, 0);
                                 headerView.frame = CGRectOffset(headerView.frame, -7, 0);
                             }];
                         }];
                     }];
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes
{
    static CGFloat currentTranslateX = 0.0;
    if ([_mainContentView viewWithTag:1001] ||
        [_mainContentView viewWithTag:1002] ||
        [_mainContentView viewWithTag:1003])
    {
        if (!_tapGestureRec.enabled)
        {
            return;
        }
    }
    if (panGes.state == UIGestureRecognizerStateBegan)
    {
//        [[AppDelegate instance] appdelegateHideVolumeView];
        [_LeftVC viewWillAppear:YES];
        currentTranslateX = _mainContentView.transform.tx;
    }
    if (panGes.state == UIGestureRecognizerStateChanged)
    {
        CGFloat transX = [panGes translationInView:_mainContentView].x;
        transX = transX + currentTranslateX;
        
        CGFloat sca;
        if (transX > 0)
        {
            [self.view sendSubviewToBack:_rightSideView];
            [self configureViewShadowWithDirection:RMoveDirectionRight];
            
            if (_mainContentView.frame.origin.x < _LeftSContentOffset)
            {
                sca = 1 - (_mainContentView.frame.origin.x/_LeftSContentOffset) * (1-_LeftSContentScale);
            }
            else
            {
                sca = _LeftSContentScale;
            }
        }
        else    //transX < 0
        {
            // 右边不处理
            /*
             [self.view sendSubviewToBack:_leftSideView];
             [self configureViewShadowWithDirection:RMoveDirectionLeft];
             
             if (_mainContentView.frame.origin.x > -_RightSContentOffset)
             {
             sca = 1 - (-_mainContentView.frame.origin.x/_RightSContentOffset) * (1-_RightSContentScale);
             }
             else
             {
             sca = _RightSContentScale;
             }*/
            return;
        }
        CGAffineTransform transS = CGAffineTransformMakeScale(1.0, sca);
        CGAffineTransform transT = CGAffineTransformMakeTranslation(transX, 0);
        
        CGAffineTransform conT = CGAffineTransformConcat(transT, transS);
        
        _mainContentView.transform = conT;
        // 处理MiniPlayer
        UIView *miniplayerview = [self.navigationController.view viewWithTag:1214];
        UIView *headerView = [self.navigationController.view viewWithTag:1215];
        if (miniplayerview)
        {
            CGFloat ty = 0.0;
            ty = miniplayerview.frame.origin.y*(sca-1)/2;
            CGAffineTransform transMini = CGAffineTransformMakeTranslation(transX, ty);
            CGAffineTransform scaleMini = CGAffineTransformMakeScale(1.0, 1.0);
            CGAffineTransform conMini = CGAffineTransformConcat(transMini, scaleMini);
            miniplayerview.transform = conMini;
        }
        if (headerView)
        {
            CGFloat ty = 0.0;
            ty = headerView.frame.origin.y*(sca-1)/2;
            CGAffineTransform transMini = CGAffineTransformMakeTranslation(transX, ty);
            CGAffineTransform scaleMini = CGAffineTransformMakeScale(1.0, 1.0);
            CGAffineTransform conMini = CGAffineTransformConcat(transMini, scaleMini);
            headerView.transform = conMini;
        }
    }
    else if (panGes.state == UIGestureRecognizerStateEnded)
    {
        CGFloat panX = [panGes translationInView:_mainContentView].x;
        CGFloat finalX = currentTranslateX + panX;
        if (finalX > _LeftSJudgeOffset)
        {
            CGAffineTransform conT = [self transformWithDirection:RMoveDirectionRight];
            [UIView beginAnimations:nil context:nil];
            _mainContentView.transform = conT;
            // 处理MiniPlayer
            UIView *miniplayerview = [self.navigationController.view viewWithTag:1214];
            if (miniplayerview)
            {
                CGFloat ty = 0.0;
                ty = miniplayerview.frame.origin.y*(_LeftSContentScale-1)/2;
                CGAffineTransform transMini = CGAffineTransformMakeTranslation(_LeftSContentOffset, ty);
                CGAffineTransform scaleMini = CGAffineTransformMakeScale(1.0, 1.0);
                CGAffineTransform conMini = CGAffineTransformConcat(transMini, scaleMini);
                miniplayerview.transform = conMini;
                miniplayerview.userInteractionEnabled = NO;
            }
            UIView *headerView = [self.navigationController.view viewWithTag:1215];
            if (headerView)
            {
                CGFloat ty = 0.0;
                ty = headerView.frame.origin.y*(_LeftSContentScale-1)/2;
                CGAffineTransform transMini = CGAffineTransformMakeTranslation(_LeftSContentOffset, ty);
                CGAffineTransform scaleMini = CGAffineTransformMakeScale(1.0, 1.0);
                CGAffineTransform conMini = CGAffineTransformConcat(transMini, scaleMini);
                headerView.transform = conMini;
                headerView.userInteractionEnabled = NO;
            }
            [UIView commitAnimations];
            
            _tapGestureRec.enabled = YES;
            for (UIView *subview in _mainContentView.subviews)
            {
                subview.userInteractionEnabled = NO;
            }
            [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _mainContentView.frame = CGRectOffset(_mainContentView.frame, -7, 0);
                miniplayerview.frame = CGRectOffset(miniplayerview.frame, -7, 0);
                headerView.frame = CGRectOffset(headerView.frame, -7, 0);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    _mainContentView.frame = CGRectOffset(_mainContentView.frame, 7, 0);
                    miniplayerview.frame = CGRectOffset(miniplayerview.frame, 7, 0);
                    headerView.frame = CGRectOffset(headerView.frame, 7, 0);
                }];
            }];
            return;
        }
        if (finalX < -_RightSJudgeOffset)
        {
            CGAffineTransform conT = [self transformWithDirection:RMoveDirectionLeft];
            [UIView beginAnimations:nil context:nil];
            _mainContentView.transform = conT;
            [UIView commitAnimations];
            
            _tapGestureRec.enabled = YES;
            return;
        }
        else
        {
            CGAffineTransform oriT = CGAffineTransformIdentity;
            [UIView beginAnimations:nil context:nil];
            _mainContentView.transform = oriT;
            // 处理MiniPlayer
            UIView *miniplayerview = [self.navigationController.view viewWithTag:1214];
            if (miniplayerview)
            {
                miniplayerview.transform = oriT;
                miniplayerview.userInteractionEnabled = YES;
            }
            UIView *headerView = [self.navigationController.view viewWithTag:1215];
            if (headerView)
            {
                headerView.transform = oriT;
                headerView.userInteractionEnabled = YES;
            }
            [UIView commitAnimations];
            
            _tapGestureRec.enabled = NO;
            for (UIView *subview in _mainContentView.subviews)
            {
                subview.userInteractionEnabled = YES;
            }
            [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _mainContentView.frame = CGRectOffset(_mainContentView.frame, 7, 0);
                miniplayerview.frame = CGRectOffset(miniplayerview.frame, 7, 0);
                headerView.frame = CGRectOffset(headerView.frame, 7, 0);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    _mainContentView.frame = CGRectOffset(_mainContentView.frame, -7, 0);
                    miniplayerview.frame = CGRectOffset(miniplayerview.frame, -7, 0);
                    headerView.frame = CGRectOffset(headerView.frame, -7, 0);
                }];
            }];
        }
    }
}

#pragma mark -
- (CGAffineTransform)transformWithDirection:(RMoveDirection)direction
{
    CGFloat translateX = 0;
    CGFloat transcale = 0;
    switch (direction) {
        case RMoveDirectionLeft:
            translateX = -_RightSContentOffset;
            transcale = _RightSContentScale;
            break;
        case RMoveDirectionRight:
            translateX = _LeftSContentOffset;
            transcale = _LeftSContentScale;
            break;
        default:
            break;
    }
    
    CGAffineTransform transT = CGAffineTransformMakeTranslation(translateX, 0);
    CGAffineTransform scaleT = CGAffineTransformMakeScale(1.0, transcale);
    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
    
    return conT;
}

- (void)configureViewShadowWithDirection:(RMoveDirection)direction
{
    /*
     CGFloat shadowW;
     switch (direction)
     {
     case RMoveDirectionLeft:
     shadowW = 1.0f;
     break;
     case RMoveDirectionRight:
     shadowW = -1.0f;
     break;
     default:
     break;
     }
     
     _mainContentView.layer.shadowOffset = CGSizeMake(shadowW, 1.0);
     _mainContentView.layer.shadowColor = [UIColor blackColor].CGColor;
     _mainContentView.layer.shadowOpacity = 0.3f;
     */
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"touch.view class=%@", NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    BOOL bRet = YES;
    CGPoint touchPoint = [touch locationInView:self.view];
    if (touchPoint.x < _LeftSContentOffset)
    {
        bRet = NO;
    }
    else
    {
        bRet = YES;
    }
    return  bRet;
}
@end
