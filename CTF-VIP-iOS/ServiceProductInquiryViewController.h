//
//  ServiceProductInquiryViewController.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 2/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "ContactUsViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ServiceProductInquiryViewController : ContactUsViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, assign) bool isAudioRecorded;

@end
