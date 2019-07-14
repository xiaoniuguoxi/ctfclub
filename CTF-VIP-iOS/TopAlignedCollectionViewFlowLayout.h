//
//  TopAlignedCollectionViewFlowLayout.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//
//  Source: http://stackoverflow.com/questions/16837928/uicollection-view-flow-layout-vertical-align
//

#import <UIKit/UIKit.h>

@interface TopAlignedCollectionViewFlowLayout : UICollectionViewFlowLayout

- (void)alignToTopForSameLineElements:(NSArray *)sameLineElements;

@end
