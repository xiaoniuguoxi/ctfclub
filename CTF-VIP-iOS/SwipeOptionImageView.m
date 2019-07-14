//
//  SwipeOptionImageView.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 28/10/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "SwipeOptionImageView.h"

@interface SwipeOptionImageView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation SwipeOptionImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code.
        //
        [[NSBundle mainBundle] loadNibNamed:@"SwipeOptionImageView" owner:self options:nil];
        [self addSubview:self.contentView];
    }
    return self;
}

@end
