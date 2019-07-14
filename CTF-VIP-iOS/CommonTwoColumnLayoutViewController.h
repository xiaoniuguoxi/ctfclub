//
//  CommonTwoColumnLayoutViewController.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 23/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface CommonTwoColumnLayoutViewController : CommonViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableDictionary *cachedItems;
@property (nonatomic, strong) NSMutableDictionary *cachedPageNumbers;
@property (nonatomic, strong) NSMutableDictionary *cachedTotalPageNumbers;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, assign) int currentCategoryId;

// Variables for spinner popup
@property (nonatomic, assign) NSInteger categoryPosition;
@property (nonatomic, strong) NSMutableArray *categoryTitleArray;

- (NSNumber *)getCurrentCategoryId;
- (NSMutableArray *)getItems;
- (void)selectCategory:(NSInteger)position;
- (void)loadItemsInCategoryId:(int)categoryId atPage:(int)page;
- (void)handleItems:(NSDictionary *)jsonObject inCategoryId:(int)categoryId atPage:(int)page withArrayKey:(NSString *)arrayKey;

@end
