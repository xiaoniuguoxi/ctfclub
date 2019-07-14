//
//  OptionCheckboxTableViewCell.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 28/10/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "CommonOptionTableViewCell.h"

@interface OptionCheckboxTableViewCell : CommonOptionTableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property (nonatomic, strong) NSArray *selects;
@property (nonatomic, assign) BOOL isRadio;

@end
