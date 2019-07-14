//
//  CTFDetailVC.h
//  CTF-VIP-iOS
//
//  Created by HughChiu on 2019/7/14.
//  Copyright © 2019 ctf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTFDetailVC : UIViewController <CommunicatorProtocolDelegate>
@property (nonatomic, strong) CommunicationProtocol *communicator;
@property (nonatomic, strong) NSDictionary *superDic;
@property (nonatomic, assign) NSInteger requestType;
@end

NS_ASSUME_NONNULL_END
