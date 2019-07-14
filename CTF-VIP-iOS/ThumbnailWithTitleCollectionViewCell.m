//
//  ThumbnailWithTitleCollectionViewCell.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "ThumbnailWithTitleCollectionViewCell.h"
#import "CommunicationProtocol.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HtmlUtil.h"

@interface ThumbnailWithTitleCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ThumbnailWithTitleCollectionViewCell

- (void)assignItem:(NSDictionary*)item
{
    if (item[TITLE] != nil && item[TITLE] != [NSNull null]) {
        self.titleLabel.text = [HtmlUtil decodeHTML:item[TITLE]];
    }
    
    if (item[POPUP] != nil && item[POPUP] != [NSNull null]) {
        [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:[item[POPUP] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
}

@end
