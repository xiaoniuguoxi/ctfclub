//
//  CommonOptionTableViewCell.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 28/10/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HtmlUtil.h"

#define OPTION_CELL_HEIGHT 90

@interface CommonOptionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (nonatomic, copy) NSString *param;
@property (nonatomic, copy) NSString *optionId;

- (id)getValue;

- (CGFloat)getCellHeight;

@end
