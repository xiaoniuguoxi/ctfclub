//
//  ViewController.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 7/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationProtocol.h"
#import "SwipeView.h"

@interface IndexViewController : UIViewController <CommunicatorProtocolDelegate, SwipeViewDataSource, SwipeViewDelegate>

@end
