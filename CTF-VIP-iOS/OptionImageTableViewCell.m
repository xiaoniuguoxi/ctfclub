//
//  OptionImageTableViewCell.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 28/10/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "OptionImageTableViewCell.h"
#import "SwipeOptionImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CommunicationProtocol.h"

#define OPTION_IMAGE_WIDTH 46
#define OPTION_IMAGE_HEIGHT 46

@implementation OptionImageTableViewCell

- (id)getValue
{
    if (self.selectedPosition > -1) {
        NSDictionary *image = [self.images objectAtIndex:self.selectedPosition];
        return [NSString stringWithFormat:@"%@", image[STAFF_RATING_OPTION_VALUE_ID]];
    } else {
        return nil;
    }
}

#pragma mark - SwipeViewDataSource

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.images ? self.images.count : 0;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    SwipeOptionImageView *optionImageView = [[SwipeOptionImageView alloc] initWithFrame:CGRectMake(0, 0, OPTION_IMAGE_WIDTH, OPTION_IMAGE_HEIGHT)];
    
    NSDictionary *image = [self.images objectAtIndex:index];
    [optionImageView.imageView sd_setImageWithURL:[NSURL URLWithString:[image[index == self.selectedPosition ? VALUE2 : VALUE] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    return optionImageView;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return CGSizeMake(OPTION_IMAGE_WIDTH, OPTION_IMAGE_HEIGHT);
}

#pragma mark - SwipeViewDelegate

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    NSInteger prevIndex = self.selectedPosition;
    self.selectedPosition = index;
    [swipeView reloadItemAtIndex:prevIndex];
    [swipeView reloadItemAtIndex:index];
}

@end
