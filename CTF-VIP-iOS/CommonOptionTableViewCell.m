//
//  CommonOptionTableViewCell.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 28/10/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "CommonOptionTableViewCell.h"

@implementation CommonOptionTableViewCell

- (id)getValue {
    // implement in subclass
    return nil;
}

- (CGFloat)getCellHeight
{
    CGFloat calHeight = OPTION_CELL_HEIGHT + [self getQuestionLabelHeight] - 18;
    return MAX(calHeight, OPTION_CELL_HEIGHT);
}

- (CGFloat)getQuestionLabelHeight
{
    NSString *title = self.questionLabel.text;
    
    //Calculate the expected size based on the font and linebreak mode of your label
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat cellWidth = screenRect.size.width - 20/* margin */;
    CGFloat labelWidth = cellWidth - 30/* exclude the checkbox width */;
    CGSize maximumLabelSize = CGSizeMake(labelWidth, CGFLOAT_MAX);
    CGRect expectedLabelSize = [title boundingRectWithSize:maximumLabelSize
                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]}
                                                   context:nil];
    
    return expectedLabelSize.size.height;
}

@end
