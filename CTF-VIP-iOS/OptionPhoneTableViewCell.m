//
//  OptionPhoneTableViewCell.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 4/11/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "OptionPhoneTableViewCell.h"
#import "LocalizationSystem.h"

@implementation OptionPhoneTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
    self.phoneZoneArray = [NSArray arrayWithObjects:AMLocalizedString(@"852", nil), AMLocalizedString(@"86", nil), AMLocalizedString(@"853", nil), nil];
}

- (IBAction)selectPhoneZonePicker:(id)sender
{
    [self.customDelegate openSelector:self];
}

- (id)getValue
{
    if (self.inputTextField.text.length > 0) {
        return self.inputTextField.text;
    }
    return nil;
}

- (void)selectItem:(NSInteger)position
{
    self.phoneZoneValueLabel.text = [self.phoneZoneArray objectAtIndex:position];
}

@end
