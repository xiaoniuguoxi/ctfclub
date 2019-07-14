//
//  OptionSelectTableViewCell.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 28/10/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "CommonOptionTableViewCell.h"

@protocol OptionSelectTableViewCellDelegate

@required
- (void)openSelector:(id)sender;
- (void)getShopsAtZonePosition:(NSInteger)position;

@end

@interface OptionSelectTableViewCell : CommonOptionTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *selectLabel;

@property (nonatomic, strong) NSArray *selects;
@property (nonatomic, strong) NSMutableArray *selectTitleArray;
@property (nonatomic, assign) NSInteger selectedPosition;

@property (nonatomic, weak) id<OptionSelectTableViewCellDelegate> customDelegate;

- (void)selectItem:(NSInteger)position;

@end
