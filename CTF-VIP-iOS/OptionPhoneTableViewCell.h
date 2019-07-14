//
//  OptionPhoneTableViewCell.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 4/11/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "CommonOptionTableViewCell.h"

@protocol OptionPhoneTableViewCellDelegate

@required
- (void)openSelector:(id)sender;

@end

@interface OptionPhoneTableViewCell : CommonOptionTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *phoneZoneValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (nonatomic, strong) NSArray *phoneZoneArray;

@property (nonatomic, weak) id<OptionPhoneTableViewCellDelegate> customDelegate;

- (void)selectItem:(NSInteger)position;

@end
