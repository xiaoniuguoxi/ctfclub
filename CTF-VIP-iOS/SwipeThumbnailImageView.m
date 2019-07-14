//
//  SwipeThumbnailImageView.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 25/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "SwipeThumbnailImageView.h"

@interface SwipeThumbnailImageView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation SwipeThumbnailImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code.
        //
        [[NSBundle mainBundle] loadNibNamed:@"SwipeThumbnailImageView" owner:self options:nil];
        [self addSubview:self.contentView];
    }
    return self;
}

@end
