//
//  StaffRatingViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 28/10/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "StaffRatingViewController.h"
#import "ActionSheetStringPicker.h"

#define PARAM @"param"
#define MANDATORY @"mandatory"

@interface StaffRatingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mandatoryLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *headerQuestions;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSMutableArray *footerQuestions;

@property (nonatomic, assign) int phoneZonePosition;

@property (nonatomic, strong) NSMutableArray *shopZoneArray;
@property (nonatomic, strong) NSMutableArray *shopArray;
@property (nonatomic, assign) int shopIndexRow;

@property (nonatomic, strong) NSMutableDictionary *cells;

@property (nonatomic, strong) UIAlertView *resultAlert;

@end

@implementation StaffRatingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBarTitleKey = @"title_staff_rating";
    self.showLoginButton = YES;
    self.showLogoutButton = NO;
    
    self.tableView.hidden = YES;
    
    // Get shop zone
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_SHOP_ZONE] parameters:nil tag:ROUTE_GET_SHOP_ZONE];
    
    // Get questions
    [self reloadItems];
    
    // Get login detail
    if ([LoginUtil getInstance].detail == nil && [LoginUtil getCardNumber] && [LoginUtil getPassword]) {
        [self.communicator startIndicator];
        
        // Prepare API request
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setValue:[LoginUtil getCardNumber] forKey:CARD_NUMBER];
        [parameters setValue:[LoginUtil getPassword] forKey:HASH];
        
        [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_LOGIN_CHECK] isPost:YES parameters:parameters tag:ROUTE_LOGIN_CHECK];
    }
}

- (void)reloadItems
{
    [self.communicator startIndicator];
    
    // Prepare API request
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_STAFF_RATING_OPTION] parameters:nil tag:ROUTE_GET_STAFF_RATING_OPTION];
}

- (void)reloadLocalization
{
    [super reloadLocalization];
    
    self.mandatoryLabel.text = AMLocalizedString(@"staff_rating_mandatory", nil);
    
    self.cells = [NSMutableDictionary new];
    
    // default header and footer questions
    self.headerQuestions = [NSMutableArray new];
    self.footerQuestions = [NSMutableArray new];
    
    NSMutableDictionary *question = nil;
    
    if ([LoginUtil getCardNumber] == nil)
    {
        question = [NSMutableDictionary new];
        question[TITLE] = AMLocalizedString(@"staff_rating_name", nil);
        question[TYPE] = @"text";
        question[PARAM] = @"name";
        question[MANDATORY] = @"yes";
        [self.headerQuestions addObject:question];
        
        question = [NSMutableDictionary new];
        question[TITLE] = AMLocalizedString(@"staff_rating_telephone", nil);
        question[TYPE] = @"telephone";
        question[PARAM] = @"telephone";
        question[MANDATORY] = @"yes";
        [self.headerQuestions addObject:question];
        
        question = [NSMutableDictionary new];
        question[TITLE] = AMLocalizedString(@"staff_rating_gender", nil);
        question[TYPE] = @"radio";
        question[PARAM] = @"gender";
        question[MANDATORY] = @"yes";
        NSMutableDictionary *value1 = [NSMutableDictionary new];
        value1[VALUE] = AMLocalizedString(@"male", nil);
        value1[STAFF_RATING_OPTION_VALUE_ID] = @"0";
        NSMutableDictionary *value2 = [NSMutableDictionary new];
        value2[VALUE] = AMLocalizedString(@"female", nil);
        value2[STAFF_RATING_OPTION_VALUE_ID] = @"1";
        question[VALUE] = [NSArray arrayWithObjects:value1, value2, nil];
        [self.headerQuestions addObject:question];
    }
    
    question = [NSMutableDictionary new];
    question[TITLE] = AMLocalizedString(@"staff_rating_invoice_no", nil);
    question[TYPE] = @"text";
    question[PARAM] = @"invoice_no";
    question[MANDATORY] = @"no";
    [self.headerQuestions addObject:question];
    
    question = [NSMutableDictionary new];
    question[TITLE] = AMLocalizedString(@"staff_rating_shop_zone", nil);
    question[TYPE] = @"select";
    question[PARAM] = @"shop_zone_id";
    question[MANDATORY] = @"yes";
    [self.headerQuestions addObject:question];
    
    question = [NSMutableDictionary new];
    question[TITLE] = AMLocalizedString(@"staff_rating_shop", nil);
    question[TYPE] = @"radio";
    question[PARAM] = @"shop_id";
    question[MANDATORY] = @"yes";
    self.shopIndexRow = (int)self.headerQuestions.count;//used when shop zone change
    [self.headerQuestions addObject:question];
    
    question = [NSMutableDictionary new];
    question[TITLE] = AMLocalizedString(@"staff_rating_staff_name", nil);
    question[TYPE] = @"text";
    question[PARAM] = @"saleman";
    question[MANDATORY] = @"yes";
    [self.headerQuestions addObject:question];
    
    question = [NSMutableDictionary new];
    question[TITLE] = AMLocalizedString(@"staff_rating_staff_number", nil);
    question[TYPE] = @"text";
    question[PARAM] = @"saleman_number";
    question[MANDATORY] = @"no";
    [self.headerQuestions addObject:question];
    
    question = [NSMutableDictionary new];
    question[TITLE] = AMLocalizedString(@"staff_rating_opinion", nil);
    question[TYPE] = @"text";
    question[PARAM] = @"opinion";
    question[MANDATORY] = @"no";
    [self.footerQuestions addObject:question];
    
    [self.tableView reloadData];
}

- (void)logoutAndClear
{
    [super logoutAndClear];
    
    // reload the form
    [self reloadLocalization];
}

- (void)openSelector:(id)sender
{
    if ([sender isKindOfClass:[OptionSelectTableViewCell class]]) {
        OptionSelectTableViewCell *cell = sender;
        
        if ([cell.param isEqualToString:SHOP_ZONE_ID]) {
            cell.selectTitleArray = [NSMutableArray new];
            [cell.selectTitleArray addObject:AMLocalizedString(@"select", nil)];
            
            for (NSDictionary *shopZone in self.shopZoneArray) {
                if (shopZone[NAME]) {
                    [cell.selectTitleArray addObject:[HtmlUtil decodeHTML:shopZone[NAME]]];
                }
            }
        }
        
        [ActionSheetStringPicker showPickerWithTitle:@""
                                                rows:cell.selectTitleArray
                                    initialSelection:cell.selectedPosition
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               [cell selectItem:selectedIndex];
                                           }
                                         cancelBlock:nil
                                              origin:self.tableView];
    } else if ([sender isKindOfClass:[OptionPhoneTableViewCell class]]) {
        OptionPhoneTableViewCell *cell = sender;
        
        [ActionSheetStringPicker showPickerWithTitle:@""
                                                rows:cell.phoneZoneArray
                                    initialSelection:self.phoneZonePosition
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               self.phoneZonePosition = (int)selectedIndex;
                                               [cell selectItem:selectedIndex];
                                           }
                                         cancelBlock:nil
                                              origin:self.tableView];
    }
}

- (void)getShopsAtZonePosition:(NSInteger)position
{
    NSDictionary *shopZone = [self.shopZoneArray objectAtIndex:position];
    
    // Get shops
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:shopZone[SHOP_ZONE_ID] forKey:SHOP_ZONE_ID];
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_SHOP_ZONE] parameters:parameters tag:ROUTE_GET_SHOP_ZONE];
}

- (IBAction)selectSubmit:(id)sender
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if ([LoginUtil getCardNumber]) {
        [parameters setValue:[LoginUtil getCardNumber] forKey:MEMBER_CARD_NUMBER];
    } else {
        NSString *phoneZone = (self.phoneZonePosition == 0) ? @"852" : (self.phoneZonePosition == 1) ? @"86" : @"853";
        [parameters setValue:phoneZone forKey:TELEPHONE_ZONE];
    }
    
    NSMutableDictionary *optionValues = [NSMutableDictionary new];
    
    for (int indexRow = 0; indexRow < self.cells.count; indexRow++) {
        CommonOptionTableViewCell *cell = (CommonOptionTableViewCell *) [self.cells objectForKey:[NSString stringWithFormat:@"row%d", indexRow]];
        
        if (cell.param)
        {
            NSString *value;
            if ([cell.param isEqualToString:SHOP_ZONE_ID]) {
                OptionSelectTableViewCell *selectCell = (OptionSelectTableViewCell *) cell;
                if (selectCell.selectedPosition > 0) {
                    NSDictionary *shopZone = [self.shopZoneArray objectAtIndex:selectCell.selectedPosition - 1];
                    value = shopZone[SHOP_ZONE_ID];
                }
            } else {
                value = [cell getValue];
            }
            
            if (value) {
                [parameters setValue:value forKey:cell.param];
            }
        }
        else if (cell.optionId)
        {
            id value = [cell getValue];
            if (value) {
                [optionValues setValue:value forKey:cell.optionId];
            }
        }
    }
    [parameters setValue:optionValues forKey:@"option_values"];
    
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_APPLY_STAFF_RATING] isPost:YES parameters:parameters tag:ROUTE_APPLY_STAFF_RATING];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (alertView == self.resultAlert) {
        // form submitted, reload (clear) the form
        self.cells = [NSMutableDictionary new];
        [self.tableView reloadData];
    }
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    NSString *tag = jsonObject[TAG];
    
    if ([tag isEqualToString:ROUTE_GET_STAFF_RATING_OPTION])
    {
        self.options = jsonObject[OPTIONES];
        
        if (self.options.count > 0) {
            self.tableView.hidden = NO;
        }
        
        [self.tableView reloadData];
    }
    else if ([tag isEqualToString:ROUTE_GET_SHOP_ZONE])
    {
        if (jsonObject[SHOP_ZONES])
        {
            self.shopZoneArray = jsonObject[SHOP_ZONES];
        }
        else if (jsonObject[SHOPS])
        {
            NSMutableArray *values = [NSMutableArray new];
            for (NSDictionary *shop in jsonObject[SHOPS])
            {
                NSString *name = shop[NAME];
                NSString *address = shop[ADDRESS];
                
                NSString *shopAddressString = @"";
                if (name != [NSNull class] && address != [NSNull class]) {
                    shopAddressString = [name stringByAppendingFormat:@" - %@", address];
                } else if (name != [NSNull class]) {
                    shopAddressString = name;
                } else if (address != [NSNull class]) {
                    shopAddressString = address;
                }
                
                NSMutableDictionary *value = [NSMutableDictionary new];
                value[VALUE] = shopAddressString;
                value[STAFF_RATING_OPTION_VALUE_ID] = shop[SHOP_ID];
                
                [values addObject:value];
            }
            NSMutableDictionary *question = [self.headerQuestions objectAtIndex:self.shopIndexRow];
            question[VALUE] = values;
            
            [self reloadCellForRow:self.shopIndexRow];
        }
    } else if ([tag isEqualToString:ROUTE_APPLY_STAFF_RATING]) {
        self.resultAlert = [[UIAlertView alloc] initWithTitle:nil
                                                      message:AMLocalizedString(@"rating_thank_you", nil)
                                                     delegate:self
                                            cancelButtonTitle:AMLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil];
        [self.resultAlert show];
    }
}

- (void)reloadCellForRow:(int)rowNumber
{
    [self.cells removeObjectForKey:[NSString stringWithFormat:@"row%d", rowNumber]];
    
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNumber inSection:0];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options ? self.headerQuestions.count + self.options.count + self.footerQuestions.count + 1: 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the cached cell
    UITableViewCell *cachedCell = [self.cells objectForKey:[NSString stringWithFormat:@"row%d", (int)indexPath.row]];
    if (cachedCell != nil) {
        return cachedCell;
    }
    
    NSDictionary *option;
    NSInteger rowIndex = indexPath.row;
    if (rowIndex < self.headerQuestions.count) {
        option = [self.headerQuestions objectAtIndex:rowIndex];
    }
    
    rowIndex -= self.headerQuestions.count;
    if (rowIndex < self.options.count) {
        option = [self.options objectAtIndex:rowIndex];
    }
    
    rowIndex -= self.options.count;
    if (rowIndex < self.footerQuestions.count) {
        option = [self.footerQuestions objectAtIndex:rowIndex];
    }
    
    if (option == nil) {
        //Submit button
        static NSString *cellIdentifier = @"SubmitButtonTableViewCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        UIButton *submitButton = (UIButton *) [cell viewWithTag:1];
        [submitButton setTitle:AMLocalizedString(@"submit", nil) forState:UIControlStateNormal];
        
        return cell;
    }
    
    if ([option[TYPE] isEqualToString:@"image"])
    {
        static NSString *cellIdentifier = @"OptionImageTableViewCell";
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        OptionImageTableViewCell *cell = [nib objectAtIndex:0];
        
        if (cachedCell != nil) {
            cell = (OptionImageTableViewCell *) cachedCell;
        }
        
        cell.questionLabel.text = [HtmlUtil decodeHTML:option[TITLE]];
        cell.starLabel.text = (option[MANDATORY] && [option[MANDATORY] isEqualToString:@"no"]) ? nil : @"*";
        
        if (option[PARAM]) {
            cell.param = option[PARAM];
        }
        if (option[STAFF_RATING_OPTION_ID]) {
            cell.optionId = option[STAFF_RATING_OPTION_ID];
        }
        
        cell.images = option[VALUE];
        cell.selectedPosition = -1;
        
        // Cache the cell to prevent losing the data
        [self.cells setValue:cell forKey:[NSString stringWithFormat:@"row%d", (int)indexPath.row]];
        
        return cell;
    }
    else if ([option[TYPE] isEqualToString:@"select"])
    {
        static NSString *cellIdentifier = @"OptionSelectTableViewCell";
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        OptionSelectTableViewCell *cell = [nib objectAtIndex:0];
        
        cell.questionLabel.text = [HtmlUtil decodeHTML:option[TITLE]];
        cell.starLabel.text = (option[MANDATORY] && [option[MANDATORY] isEqualToString:@"no"]) ? nil : @"*";
        
        if (option[PARAM]) {
            cell.param = option[PARAM];
        }
        if (option[STAFF_RATING_OPTION_ID]) {
            cell.optionId = option[STAFF_RATING_OPTION_ID];
        }
        
        cell.selects = option[VALUE];
        cell.customDelegate = self;
        [cell selectItem:0];
        
        // Cache the cell to prevent losing the data
        [self.cells setValue:cell forKey:[NSString stringWithFormat:@"row%d", (int)indexPath.row]];
        
        return cell;
    }
    else if ([option[TYPE] isEqualToString:@"radio"] || [option[TYPE] isEqualToString:@"checkbox"])
    {
        static NSString *cellIdentifier = @"OptionCheckboxTableViewCell";
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        OptionCheckboxTableViewCell *cell = [nib objectAtIndex:0];
        
        cell.questionLabel.text = [HtmlUtil decodeHTML:option[TITLE]];
        cell.starLabel.text = (option[MANDATORY] && [option[MANDATORY] isEqualToString:@"no"]) ? nil : @"*";
        
        if (option[PARAM]) {
            cell.param = option[PARAM];
        }
        if (option[STAFF_RATING_OPTION_ID]) {
            cell.optionId = option[STAFF_RATING_OPTION_ID];
        }
        
        cell.selects = option[VALUE];
        cell.isRadio = [option[TYPE] isEqualToString:@"radio"];
        
        // Cache the cell to prevent losing the data
        [self.cells setValue:cell forKey:[NSString stringWithFormat:@"row%d", (int)indexPath.row]];
        
        return cell;
    }
    else if ([option[TYPE] isEqualToString:@"telephone"])
    {
        static NSString *cellIdentifier = @"OptionPhoneTableViewCell";
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        OptionPhoneTableViewCell *cell = [nib objectAtIndex:0];
        
        cell.questionLabel.text = [HtmlUtil decodeHTML:option[TITLE]];
        cell.starLabel.text = (option[MANDATORY] && [option[MANDATORY] isEqualToString:@"no"]) ? nil : @"*";
        
        if (option[PARAM]) {
            cell.param = option[PARAM];
            cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        cell.inputTextField.text = nil;
        cell.customDelegate = self;
        [cell selectItem:0];
        
        // Cache the cell to prevent losing the data
        [self.cells setValue:cell forKey:[NSString stringWithFormat:@"row%d", (int)indexPath.row]];
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"OptionTextTableViewCell";
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        OptionTextTableViewCell *cell = [nib objectAtIndex:0];
        
        cell.questionLabel.text = [HtmlUtil decodeHTML:option[TITLE]];
        cell.starLabel.text = (option[MANDATORY] && [option[MANDATORY] isEqualToString:@"no"]) ? nil : @"*";
        
        if (option[PARAM]) {
            cell.param = option[PARAM];
            
            if ([cell.param isEqualToString:@"telephone"]) {
                cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            }
        }
        if (option[STAFF_RATING_OPTION_ID]) {
            cell.optionId = option[STAFF_RATING_OPTION_ID];
        }
        
        cell.inputTextField.text = nil;
        
        // Cache the cell to prevent losing the data
        [self.cells setValue:cell forKey:[NSString stringWithFormat:@"row%d", (int)indexPath.row]];
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[CommonOptionTableViewCell class]]) {
        return [((CommonOptionTableViewCell *)cell) getCellHeight];
    } else {
        return 90;//submit button cell height
    }
}

@end
