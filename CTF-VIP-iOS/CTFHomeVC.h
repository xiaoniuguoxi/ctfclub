//
//  CTFHomeVC.h
//  CTF-VIP-iOS
//
//  Created by Beeba on 2019/7/11.
//  Copyright © 2019年 ctf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTFHomeVC : UIViewController <CommunicatorProtocolDelegate>
@property (nonatomic, strong) CommunicationProtocol *communicator;
@end

NS_ASSUME_NONNULL_END
