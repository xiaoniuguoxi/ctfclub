//
//  StaffRatingViewController.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 28/10/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "CommonViewController.h"
#import "OptionTextTableViewCell.h"
#import "OptionImageTableViewCell.h"
#import "OptionSelectTableViewCell.h"
#import "OptionCheckboxTableViewCell.h"
#import "OptionPhoneTableViewCell.h"

@interface StaffRatingViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, OptionPhoneTableViewCellDelegate, OptionSelectTableViewCellDelegate>

@end
