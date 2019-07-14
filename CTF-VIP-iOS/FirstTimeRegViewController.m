//
//  FirstTimeRegViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 2/12/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "FirstTimeRegViewController.h"
#import "ActionSheetStringPicker.h"
#import "M13Checkbox.h"

@interface FirstTimeRegViewController ()

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UILabel *collectLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UILabel *shopAddressLabel;
@property (weak, nonatomic) IBOutlet UITableView *shopAddressTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopAddressTableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthDayValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthMonthValueLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (weak, nonatomic) IBOutlet UIView *byPostView;
@property (weak, nonatomic) IBOutlet UIView *byPickupView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *byPostHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *byPickupHeight;
@property (nonatomic, assign) int defaultByPostHeight;
@property (nonatomic, assign) int defaultByPickupHeight;

@property (nonatomic, strong) NSArray *collectTitleArray;
@property (nonatomic, assign) NSInteger collectPosition;

@property (nonatomic, strong) NSArray *shopAddressArray;
@property (nonatomic, strong) NSMutableArray *shopAddressBranchCodeArray;
@property (nonatomic, strong) NSMutableArray *shopAddressTitleArray;
@property (nonatomic, assign) NSInteger shopAddressPosition;

@property (nonatomic, strong) NSMutableArray *dayTitleArray;
@property (nonatomic, strong) NSMutableArray *monthTitleArray;
@property (nonatomic, assign) NSInteger birthDayPosition;
@property (nonatomic, assign) NSInteger birthMonthPosition;

@property (nonatomic, strong) UIAlertView *resultAlert;

@property (nonatomic, copy) NSString *toAddress;

@end

@implementation FirstTimeRegViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.defaultByPostHeight = self.byPostHeight.constant;
    self.defaultByPickupHeight = self.byPickupHeight.constant;
    
    self.collectTitleArray = [NSArray arrayWithObjects:AMLocalizedString(@"select", nil), AMLocalizedString(@"first_time_reg_by_post", nil), AMLocalizedString(@"first_time_reg_by_pickup", nil), nil];
    
    // Get store addresses
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_STORE_ADDRESSES] parameters:nil tag:ROUTE_STORE_ADDRESSES];
}

- (void)reloadLocalization
{
    [super reloadLocalization];
    
    self.headerLabel.text = AMLocalizedString(@"first_time_reg_title", nil);
    self.collectLabel.text = AMLocalizedString(@"first_time_reg_collect", nil);
    self.addressLabel.text = AMLocalizedString(@"first_time_reg_address", nil);
    self.shopAddressLabel.text = AMLocalizedString(@"first_time_reg_shop_address", nil);
    self.dateOfBirthLabel.text = AMLocalizedString(@"first_time_reg_date_of_birth", nil);
    
    [self.submitButton setTitle:AMLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    [self.logoutButton setTitle:AMLocalizedString(@"logout", nil) forState:UIControlStateNormal];
    
    NSArray *monthTranslationKey = [NSArray arrayWithObjects:@"jan", @"feb", @"mar", @"apr", @"may", @"jun", @"jul", @"aug", @"sep", @"oct", @"nov", @"dec", nil];
    self.monthTitleArray = [NSMutableArray new];
    [self.monthTitleArray addObject:AMLocalizedString(@"select", nil)];
    for (NSString *key in monthTranslationKey) {
        [self.monthTitleArray addObject:AMLocalizedString(key, nil)];
    }
    
    self.dayTitleArray = [NSMutableArray new];
    [self.dayTitleArray addObject:AMLocalizedString(@"select", nil)];
    for (int count = 1; count <= 31; count++) {
        [self.dayTitleArray addObject:[NSString stringWithFormat:@"%d", count]];
    }
    
    // Set default
    [self selectCollect:0];
    self.shopAddressPosition = -1;
    [self selectBirthDay:0];
    [self selectBirthMonth:0];
}

- (void)selectCollect:(NSInteger)position
{
    if (position < self.collectTitleArray.count) {
        self.collectPosition = position;
        self.collectValueLabel.text = [self.collectTitleArray objectAtIndex:position];
        
        if (position == 1) {
            self.byPostHeight.constant = self.defaultByPostHeight;
            self.byPickupHeight.constant = 0;
            self.byPostView.hidden = NO;
            self.byPickupView.hidden = YES;
        } else if (position == 2) {
            self.byPostHeight.constant = 0;
            self.byPickupHeight.constant = self.shopAddressTableView.frame.origin.y + self.shopAddressTableViewHeight.constant + 20/* margin */;
            self.byPostView.hidden = YES;
            self.byPickupView.hidden = NO;
        } else {
            self.byPostHeight.constant = 0;
            self.byPickupHeight.constant = 0;
            self.byPostView.hidden = YES;
            self.byPickupView.hidden = YES;
        }
    }
}

- (void)selectBirthDay:(NSInteger)position
{
    if (position < self.dayTitleArray.count) {
        self.birthDayPosition = position;
        self.birthDayValueLabel.text = [self.dayTitleArray objectAtIndex:position];
    }
}

- (void)selectBirthMonth:(NSInteger)position
{
    if (position < self.monthTitleArray.count) {
        self.birthMonthPosition = position;
        self.birthMonthValueLabel.text = [self.monthTitleArray objectAtIndex:position];
    }
}

- (IBAction)selectCollectPicker:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.collectTitleArray
                                initialSelection:self.collectPosition
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [self selectCollect:selectedIndex];
                                       }
                                     cancelBlock:nil
                                          origin:self.collectValueLabel];
}

- (IBAction)selectBirthDayPicker:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.dayTitleArray
                                initialSelection:self.birthDayPosition
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [self selectBirthDay:selectedIndex];
                                       }
                                     cancelBlock:nil
                                          origin:self.birthDayValueLabel];
}

- (IBAction)selectBirthMonthPicker:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.monthTitleArray
                                initialSelection:self.birthMonthPosition
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [self selectBirthMonth:selectedIndex];
                                       }
                                     cancelBlock:nil
                                          origin:self.birthMonthValueLabel];
}

- (IBAction)selectSubmit:(id)sender
{
    NSString *errorMessage = @"";
    
    if (self.collectPosition == 0) {
        errorMessage = [errorMessage stringByAppendingString:AMLocalizedString(@"first_time_reg_error_collect", nil)];
    }
    
    if (self.collectPosition == 1/*1表示郵寄掛號*/ && self.addressTextField.text.length == 0) {
        errorMessage = [errorMessage stringByAppendingString:AMLocalizedString(@"error_address", nil)];
    }
    
    if (self.collectPosition == 2/*2表示商店自取*/ && self.shopAddressPosition == -1) {
        errorMessage = [errorMessage stringByAppendingString:AMLocalizedString(@"first_time_reg_error_shop_address", nil)];
    }
    
    if (self.birthMonthPosition == 0 || self.birthDayPosition == 0) {
        errorMessage = [errorMessage stringByAppendingString:AMLocalizedString(@"first_time_reg_error_date_of_birth", nil)];
    }
    
    if (errorMessage.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"error", nil)
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:AMLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self.communicator startIndicator];
    
    // Prepare API request
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:[LoginUtil getCardNumber] forKey:CARD_NUMBER];
    [parameters setValue:[LoginUtil getPassword] forKey:HASH];
    
    //取值有1和2；1表示郵寄掛號，2表示商店自取
    if (self.collectPosition == 1)
    {
        //如果是 邮寄挂号则 address 为必选项，邮寄地址
        [parameters setValue:MAIL forKey:GETCARD];
        [parameters setValue:self.addressTextField.text forKey:ADDRESS];
        self.toAddress = self.addressTextField.text;
    }
    else if (self.collectPosition == 2)
    {
        //如果是 商店自取则 shop_id为必选项，表示商店 ID
        if (self.shopAddressPosition < self.shopAddressBranchCodeArray.count) {
            NSDictionary *branchCode = [self.shopAddressBranchCodeArray objectAtIndex:self.shopAddressPosition];
            NSString *shopAddressTitle = [self.shopAddressTitleArray objectAtIndex:self.shopAddressPosition];
            
            [parameters setValue:BRANCH forKey:GETCARD];
            [parameters setValue:branchCode forKey:BRANCH];
            self.toAddress = shopAddressTitle;
        }
    }
    
    [parameters setValue:[@(self.birthMonthPosition) stringValue] forKey:MON];
    [parameters setValue:[@(self.birthDayPosition) stringValue] forKey:DAY];
    
    [self.communicator startIndicator];
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_FINISH] isPost:YES parameters:parameters tag:ROUTE_FINISH];
}

- (IBAction)selectLogout:(id)sender
{
    [self logoutAndClear];
    [self popBack];
    
    if (self.tabViewController != nil && self.tabViewController.currentTabIndex == 0) {
        [self.tabViewController restartCurrentVC];
    }
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleError:(NSDictionary *)jsonObject
{
    [self.communicator stopIndicator];
    
    NSString *message = ERROR;
    if (jsonObject[MESSAGE] != nil && jsonObject[MESSAGE] != [NSNull null]) {
        message = jsonObject[MESSAGE];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"error", nil)
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:AMLocalizedString(@"ok", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    NSString *tag = jsonObject[TAG];
    
    if ([tag isEqualToString:ROUTE_STORE_ADDRESSES]) {
        self.shopAddressArray = jsonObject[ADDRESSES];
        self.shopAddressBranchCodeArray = [NSMutableArray new];
        self.shopAddressTitleArray = [NSMutableArray new];
        for (NSDictionary *shop in self.shopAddressArray) {
            NSString *branchCode = @"";
            NSString *name = @"";
            NSString *district = @"";
            NSString *address = @"";
            
            if (shop[BRANCH_CODE] != nil && shop[BRANCH_CODE] != [NSNull null]) {
                branchCode = [NSString stringWithFormat:@"%@", shop[BRANCH_CODE]];
            }
            
            if (shop[BRANCH_LONG] != nil && shop[BRANCH_LONG] != [NSNull null]) {
                name = shop[BRANCH_LONG];
            }
            
            if (shop[DISTRICT_DESC] != nil && shop[DISTRICT_DESC] != [NSNull null]) {
                district = shop[DISTRICT_DESC];
            }
            
            if (shop[BRIEF_ADDRESS] != nil && shop[BRIEF_ADDRESS] != [NSNull null]) {
                address = shop[BRIEF_ADDRESS];
            }
            
            NSString *shopAddressString = [NSString stringWithFormat:@"%@ - %@%@", name, district, address];
            
            if (branchCode.length > 0) {
                [self.shopAddressBranchCodeArray addObject:branchCode];
                [self.shopAddressTitleArray addObject:[HtmlUtil decodeHTML:shopAddressString]];
            }
        }
        [self.shopAddressTableView reloadData];
    } else if ([tag isEqualToString:ROUTE_FINISH]) {
        NSString *message = SUCCESS;
        if (jsonObject[MESSAGE] != nil && jsonObject[MESSAGE] != [NSNull null]) {
            message = jsonObject[MESSAGE];
        } else if (jsonObject[STATUS] != nil && jsonObject[STATUS] != [NSNull null]) {
            message = jsonObject[STATUS];
        }
        
        self.resultAlert = [[UIAlertView alloc] initWithTitle:nil
                                                      message:message
                                                     delegate:self
                                            cancelButtonTitle:AMLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil];
        [self.resultAlert show];
    }
}

- (CGFloat)getTableHeight
{
    CGFloat calHeight = 0;
    NSUInteger count = self.shopAddressTitleArray ? self.shopAddressTitleArray.count : 0;
    for (int rowNumber = 0; rowNumber < count; rowNumber++) {
        calHeight += [self getCheckboxLabelHeight:rowNumber];
    }
    return MAX(calHeight, 46);
}

- (CGFloat)getCheckboxLabelHeight:(int)rowNumber
{
    NSString *title = [self.shopAddressTitleArray objectAtIndex:rowNumber];
    
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
    self.shopAddressTableViewHeight.constant = [self getTableHeight];
    if (self.byPickupHeight.constant > 0) {
        self.byPickupHeight.constant = self.shopAddressTableView.frame.origin.y + self.shopAddressTableViewHeight.constant + 20/* margin */;
    }
    return self.shopAddressTitleArray ? self.shopAddressTitleArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [self.shopAddressTitleArray objectAtIndex:indexPath.row];;
    
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
    checkbox.radius = 50;
    [checkbox addTarget:self action:@selector(checkStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.shopAddressPosition == indexPath.row) {
        [checkbox setCheckState:M13CheckboxStateChecked];
    } else {
        [checkbox setCheckState:M13CheckboxStateUnchecked];
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
    self.shopAddressPosition = sender.tag;
    [self.shopAddressTableView reloadData];
}

@end
