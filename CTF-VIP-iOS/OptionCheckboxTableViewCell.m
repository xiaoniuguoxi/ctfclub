//
//  OptionCheckboxTableViewCell.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 28/10/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "OptionCheckboxTableViewCell.h"
#import "M13Checkbox.h"
#import "ColorAndStyle.h"
#import "CommunicationProtocol.h"

@interface OptionCheckboxTableViewCell ()

@property (nonatomic, copy) NSString *selectedRadioValue;
@property (nonatomic, strong) NSMutableArray *selectedCheckboxValues;

@end

@implementation OptionCheckboxTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
    self.selectedRadioValue = nil;
    self.selectedCheckboxValues = [NSMutableArray new];
}

- (id)getValue
{
    if (self.isRadio) {
        // radio
        return self.selectedRadioValue;
    }
    
    // checkbox
    NSMutableDictionary *optionValues = [NSMutableDictionary new];
    int count = 0;
    for (NSString *value in self.selectedCheckboxValues) {
        [optionValues setValue:value forKey:[@(count) stringValue]];
        count++;
    }
    return optionValues;
}

- (CGFloat)getCellHeight
{
    CGFloat calHeight = [super getCellHeight] - 46/*hardcode original height*/ + [self getTableHeight];
    return MAX(calHeight, OPTION_CELL_HEIGHT);
}

- (CGFloat)getTableHeight
{
    CGFloat calHeight = 0;
    NSUInteger count = self.selects ? self.selects.count : 0;
    for (int rowNumber = 0; rowNumber < count; rowNumber++) {
        calHeight += [self getCheckboxLabelHeight:rowNumber];
    }
    return MAX(calHeight, 46);
}

- (CGFloat)getCheckboxLabelHeight:(int)rowNumber
{
    NSDictionary *select = [self.selects objectAtIndex:rowNumber];
    NSString *title = [HtmlUtil decodeHTML:select[VALUE]];
    
    //Calculate the expected size based on the font and linebreak mode of your label
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat cellWidth = screenRect.size.width - 20/* margin */;
    CGFloat labelWidth = cellWidth - 30/* exclude the checkbox width */;
    CGSize maximumLabelSize = CGSizeMake(labelWidth, CGFLOAT_MAX);
    CGRect expectedLabelSize = [title boundingRectWithSize:maximumLabelSize
                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]}
                                                   context:nil];
    
    return expectedLabelSize.size.height + 20/* margin */;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableViewHeight.constant = [self getTableHeight];
    return self.selects ? self.selects.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *select = [self.selects objectAtIndex:indexPath.row];
    NSString *title = [HtmlUtil decodeHTML:select[VALUE]];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat cellWidth = screenRect.size.width - 20/* margin */;
    CGFloat cellHeight = [self getCheckboxLabelHeight:(int)indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
    
    M13Checkbox *checkbox = [[M13Checkbox alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight) title:title];
    checkbox.checkAlignment = M13CheckboxAlignmentLeft;
    checkbox.titleLabel.numberOfLines = 0;
    checkbox.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    checkbox.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    checkbox.tag = indexPath.row;
    checkbox.checkColor = PRIMARY_PURPLE;
    checkbox.strokeColor = PRIMARY_PURPLE;
    [checkbox addTarget:self action:@selector(checkStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *optionValueId = [NSString stringWithFormat:@"%@", select[STAFF_RATING_OPTION_VALUE_ID]];
    if (self.isRadio)
    {
        checkbox.radius = 50;
        
        if ([self.selectedRadioValue isEqualToString:optionValueId]) {
            [checkbox setCheckState:M13CheckboxStateChecked];
        } else {
            [checkbox setCheckState:M13CheckboxStateUnchecked];
        }
    }
    else
    {
        if ([self.selectedCheckboxValues containsObject:optionValueId]) {
            [checkbox setCheckState:M13CheckboxStateChecked];
        } else {
            [checkbox setCheckState:M13CheckboxStateUnchecked];
        }
    }
    
    [cell addSubview:checkbox];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCheckboxLabelHeight:(int)indexPath.row];
}

- (void)checkStatusChanged:(M13Checkbox *)sender
{
    if (self.isRadio)
    {
        NSDictionary *select = [self.selects objectAtIndex:sender.tag];
        self.selectedRadioValue = [NSString stringWithFormat:@"%@", select[STAFF_RATING_OPTION_VALUE_ID]];
    }
    else
    {
        NSDictionary *select = [self.selects objectAtIndex:sender.tag];
        NSString *value = [NSString stringWithFormat:@"%@", select[STAFF_RATING_OPTION_VALUE_ID]];
        if ([self.selectedCheckboxValues containsObject:value]) {
            [self.selectedCheckboxValues removeObject:value];
        } else {
            [self.selectedCheckboxValues addObject:value];
        }
    }
    
    [self.tableView reloadData];
}

@end

