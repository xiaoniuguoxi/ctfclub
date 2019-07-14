//
//  CTFNewsVC.h
//  CTF-VIP-iOS
//
//  Created by Beeba on 2019/7/13.
//  Copyright © 2019年 ctf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTFNewsVC : UIViewController <CommunicatorProtocolDelegate>
@property (nonatomic, strong) CommunicationProtocol *communicator;

@property (nonatomic, assign) NSInteger requestType;

@end

NS_ASSUME_NONNULL_END
