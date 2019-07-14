//
//  CTFMenuVC.h
//  CTF-VIP-iOS
//
//  Created by HughChiu on 2019/7/12.
//  Copyright © 2019 ctf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTFMenuVC : UIViewController <CommunicatorProtocolDelegate>
@property (nonatomic, strong) CommunicationProtocol *communicator;
@end

NS_ASSUME_NONNULL_END
