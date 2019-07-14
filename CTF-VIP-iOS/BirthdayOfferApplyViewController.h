//
//  BirthdayOfferApplyViewController.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 2/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "CommonViewController.h"

@interface BirthdayOfferApplyViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) int birthdayId;
@property (nonatomic, strong) NSDictionary *birthdayOffer;

@end
