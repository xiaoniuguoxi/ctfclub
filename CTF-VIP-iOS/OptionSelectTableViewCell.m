//
//  OptionSelectTableViewCell.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 28/10/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "OptionSelectTableViewCell.h"
#import "CommunicationProtocol.h"
#import "LocalizationSystem.h"

@interface OptionSelectTableViewCell ()

@end

@implementation OptionSelectTableViewCell

- (id)getValue
{
    if (self.selectedPosition > 0) {
        NSDictionary *select = [self.selects objectAtIndex:self.selectedPosition - 1];
        return [NSString stringWithFormat:@"%@", select[STAFF_RATING_OPTION_VALUE_ID]];
    } else {
        return nil;
    }
}

- (void)initSelects
{
    self.selectTitleArray = [NSMutableArray new];
    [self.selectTitleArray addObject:AMLocalizedString(@"select", nil)];
    for (NSDictionary *select in self.selects) {
        if (select[VALUE]) {
            [self.selectTitleArray addObject:[HtmlUtil decodeHTML:select[VALUE]]];
        }
    }
}

- (IBAction)selectSelector:(id)sender
{
    if (!self.selectTitleArray) {
        [self initSelects];
    }
    [self.customDelegate openSelector:self];
}

- (void)selectItem:(NSInteger)position
{
    if (!self.selectTitleArray) {
        [self initSelects];
    }
    self.selectLabel.text = [self.selectTitleArray objectAtIndex:position];
    self.selectedPosition = position;
    
    if ([self.param isEqualToString:SHOP_ZONE_ID] && position > 0) {
        [self.customDelegate getShopsAtZonePosition:position - 1];
    }
}

@end
