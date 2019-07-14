//
//  CommonTwoColumnLayoutViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 23/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "CommonTwoColumnLayoutViewController.h"
#import "FilterCollectionViewCell.h"
#import "ThumbnailWithTitleCollectionViewCell.h"
#import "LoadingCollectionViewCell.h"
#import "ActionSheetStringPicker.h"

#define NUM_OF_FILTER 1
#define HEIGHT_OF_FILTER 61
#define MARGIN 10
#define IMAGE_RATIO 0.75

#define FILTER_CELL @"FilterCollectionViewCell"
#define ITEM_CELL @"ThumbnailWithTitleCollectionViewCell"
#define LOADING_CELL @"LoadingCollectionViewCell"

@interface CommonTwoColumnLayoutViewController ()

@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat itemWidth;

@end

@implementation CommonTwoColumnLayoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cachedItems = [NSMutableDictionary new];
    self.cachedPageNumbers = [NSMutableDictionary new];
    self.cachedTotalPageNumbers = [NSMutableDictionary new];
    
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.itemWidth = self.screenWidth / 2 - MARGIN;
    
    [self.collectionView registerNib:[UINib nibWithNibName:FILTER_CELL bundle:nil] forCellWithReuseIdentifier:FILTER_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:ITEM_CELL bundle:nil] forCellWithReuseIdentifier:ITEM_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:LOADING_CELL bundle:nil] forCellWithReuseIdentifier:LOADING_CELL];
    
    [self reloadCategories];
}

- (NSNumber *)getCurrentCategoryId
{
    return [NSNumber numberWithInt:self.currentCategoryId];
}

- (NSMutableArray *)getItems
{
    NSNumber *currentCategoryId = [self getCurrentCategoryId];
    return self.cachedItems[currentCategoryId];
}

- (void)reloadCategories
{
    // implemented in subclass
}

- (void)reloadItems
{
    // implemented in subclass
}

- (void)loadItemsInCategoryId:(int)categoryId atPage:(int)page
{
    NSNumber *currentCategoryId = [self getCurrentCategoryId];
    if (page == 1) {
        [self.cachedItems setObject:[NSMutableArray new] forKey:currentCategoryId];
    }
    [self.cachedPageNumbers setObject:[NSNumber numberWithInt:page] forKey:currentCategoryId];
    [self.collectionView reloadData];
    
    // implemented in subclass
}

- (void)handleItems:(NSDictionary *)jsonObject inCategoryId:(int)categoryId atPage:(int)page withArrayKey:(NSString *)arrayKey
{   
    NSNumber *key = [NSNumber numberWithInt:categoryId];
    
    // Item list
    NSArray *items = jsonObject[arrayKey];
    NSMutableArray *cachedItems = self.cachedItems[key];
    [cachedItems addObjectsFromArray:items];
    
    [self.collectionView reloadData];
    
    int totalPage = [jsonObject[PAGE_TOTAL] intValue];
    [self.cachedTotalPageNumbers setObject:[NSNumber numberWithInt:totalPage] forKey:key];
    [self.cachedPageNumbers setObject:[NSNumber numberWithInt:page + 1] forKey:key];
    if (page < totalPage) {
        [self loadItemsInCategoryId:categoryId atPage:page + 1];
    }
}

- (void)selectCategory:(NSInteger)position
{
    NSNumber *key = [self getCurrentCategoryId];
    if (!self.cachedItems[key]) {
        [self.cachedItems setObject:[NSMutableArray new] forKey:key];
        [self loadItemsInCategoryId:self.currentCategoryId atPage:1];
    }
    [self.collectionView reloadData];
    
    // implemented in subclass
}

- (void)selectItem:(NSInteger)position
{
    // implemented in subclass
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleResponse:(NSDictionary *)jsonObject
{
    // implemented in subclass
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSNumber *key = [self getCurrentCategoryId];
    NSMutableArray *items = self.cachedItems[key];
    NSNumber *page = self.cachedPageNumbers[key];
    NSNumber *totalPage = self.cachedTotalPageNumbers[key];
    
    return (self.categories ? NUM_OF_FILTER : 0) // Filter
    + (!items ? 0 : items.count) // items
    + (!page || !totalPage || page < totalPage ? 1 : 0); // loading
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.categories && indexPath.row < NUM_OF_FILTER) {
        FilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FILTER_CELL forIndexPath:indexPath];
        
        NSDictionary *category = [self.categories objectAtIndex:self.categoryPosition];
        [cell assignCategory:category];
        
        return cell;
    } else if (indexPath.row - 1 < [self getItems].count){
        ThumbnailWithTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ITEM_CELL forIndexPath:indexPath];
        
        int position = (int)indexPath.row - NUM_OF_FILTER;
        NSDictionary *item = [[self getItems] objectAtIndex:position];
        [cell assignItem:item];
        
        return cell;
    } else {
        LoadingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LOADING_CELL forIndexPath:indexPath];
        [cell.activityIndicator startAnimating];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.categories && indexPath.row < NUM_OF_FILTER) {
        [ActionSheetStringPicker showPickerWithTitle:@""
                                                rows:self.categoryTitleArray
                                    initialSelection:self.categoryPosition
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               [self selectCategory:selectedIndex];
                                           }
                                         cancelBlock:nil
                                              origin:[collectionView cellForItemAtIndexPath:indexPath]];
    } else {
        [self selectItem:indexPath.row - NUM_OF_FILTER];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.categories && indexPath.row < NUM_OF_FILTER) {
        return CGSizeMake(self.screenWidth, HEIGHT_OF_FILTER);
    }
    
    if (indexPath.row - 1 < [self getItems].count) {
        int position = (int)indexPath.row - NUM_OF_FILTER;
        NSDictionary *item = [[self getItems] objectAtIndex:position];
        
        if (item[TITLE] == nil || item[TITLE] == [NSNull null]) {
            return CGSizeMake(self.itemWidth, self.itemWidth * IMAGE_RATIO);
        }
        
        //Calculate the expected size based on the font and linebreak mode of your label
        // FLT_MAX here simply means no constraint in height
        CGRect expectedLabelSize = [item[TITLE] boundingRectWithSize:CGSizeMake(self.itemWidth - MARGIN, CGFLOAT_MAX)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}
                                                             context:nil];
        
        return CGSizeMake(self.itemWidth, self.itemWidth * IMAGE_RATIO + expectedLabelSize.size.height + MARGIN);
    }
    
    return CGSizeMake(self.screenWidth, HEIGHT_OF_FILTER);
}

@end
