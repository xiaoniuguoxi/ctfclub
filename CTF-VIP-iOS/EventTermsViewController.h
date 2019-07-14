//
//  EventTermsViewController.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 3/11/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "CommonViewController.h"

@interface EventTermsViewController : CommonViewController

@property (nonatomic, assign) int eventId;
@property (nonatomic, strong) NSDictionary *event;

@end
