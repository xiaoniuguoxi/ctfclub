//
//  CTFMunuHead.h
//  CTF-VIP-iOS
//
//  Created by Beeba on 2019/7/12.
//  Copyright © 2019年 ctf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HerderStyle) {
    HerderStyleNone,
    HerderStyleTotal
};

@protocol FoldSectionHeaderViewDelegate <NSObject>

- (void)foldHeaderInSection:(NSInteger)SectionHeader;

@end

@interface CTFMenuHead : UITableViewHeaderFooterView
@property(nonatomic, assign) BOOL fold;/**< 是否折叠 */
@property(nonatomic, assign) NSInteger section;/**< 选中的section */
@property(nonatomic, weak) id<FoldSectionHeaderViewDelegate> delegate;/**< 代理 */


- (void)setFoldSectionHeaderViewWithTitle:(NSString *)title detail:(NSString *)detail type:(HerderStyle)type section:(NSInteger)section canFold:(BOOL)canFold;
@end

NS_ASSUME_NONNULL_END
