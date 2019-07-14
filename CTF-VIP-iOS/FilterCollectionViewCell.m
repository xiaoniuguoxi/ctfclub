//
//  FilterCollectionViewCell.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "FilterCollectionViewCell.h"
#import "CommunicationProtocol.h"
#import "HtmlUtil.h"

@interface FilterCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FilterCollectionViewCell

- (void)assignCategory:(NSDictionary*)category
{
    if (category[NAME] != nil && category[NAME] != [NSNull null]) {
        self.titleLabel.text = [HtmlUtil decodeHTML:category[NAME]];
    } else if (category[TITLE] != nil && category[TITLE] != [NSNull null]) {
        self.titleLabel.text = [HtmlUtil decodeHTML:category[TITLE]];
    }
}

@end
