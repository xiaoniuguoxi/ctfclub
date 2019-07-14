//
//  EventBookViewController.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 1/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "CommonViewController.h"

@interface EventBookViewController : CommonViewController

@property (nonatomic, assign) int eventId;
@property (nonatomic, strong) NSDictionary *event;

@end
