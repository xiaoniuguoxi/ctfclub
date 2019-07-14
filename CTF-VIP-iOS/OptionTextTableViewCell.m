//
//  OptionTextTableViewCell.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 28/10/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "OptionTextTableViewCell.h"

@implementation OptionTextTableViewCell

- (id)getValue
{
    if (self.inputTextField.text.length > 0) {
        return self.inputTextField.text;
    }
    return nil;
}

@end
