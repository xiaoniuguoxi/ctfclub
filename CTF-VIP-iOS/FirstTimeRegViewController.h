//
//  FirstTimeRegViewController.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 2/12/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "CommonViewController.h"
#import "TabViewController.h"

@interface FirstTimeRegViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) TabViewController *tabViewController;

@end
