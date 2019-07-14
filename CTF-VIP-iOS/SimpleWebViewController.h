//
//  SimpleWebViewController.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 29/12/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "CommonViewController.h"

@interface SimpleWebViewController : CommonViewController

- (instancetype)initWithAddress:(NSString*)urlString withTitleKey:(NSString *)navBarTitleKey;

@end
