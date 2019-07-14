//
//  OptionImageTableViewCell.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 28/10/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "CommonOptionTableViewCell.h"
#import "SwipeView.h"

@interface OptionImageTableViewCell : CommonOptionTableViewCell <SwipeViewDataSource, SwipeViewDelegate>

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) NSInteger selectedPosition;

@end
