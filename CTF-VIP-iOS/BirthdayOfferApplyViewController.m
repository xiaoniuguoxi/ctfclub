//
//  BirthdayOfferApplyViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 2/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "BirthdayOfferApplyViewController.h"
#import "ActionSheetStringPicker.h"
#import "M13Checkbox.h"

@interface BirthdayOfferApplyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneZoneValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *collectLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UILabel *shopZoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopZoneValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopAddressLabel;
@property (weak, nonatomic) IBOutlet UITableView *shopAddressTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopAddressTableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *giftLabel;
@property (weak, nonatomic) IBOutlet UIView *giftView;
@property (weak, nonatomic) IBOutlet UILabel *giftValueLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UIView *byPostView;
@property (weak, nonatomic) IBOutlet UIView *byPickupView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *byPostHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *byPickupHeight;
@property (nonatomic, assign) int defaultByPostHeight;
@property (nonatomic, assign) int defaultByPickupHeight;

@property (nonatomic, strong) NSArray *phoneZoneArray;
@property (nonatomic, assign) NSInteger phoneZonePosition;

@property (nonatomic, strong) NSArray *collectTitleArray;
@property (nonatomic, assign) NSInteger collectPosition;

@property (nonatomic, strong) NSArray *shopZoneArray;
@property (nonatomic, strong) NSMutableArray *shopZoneTitleArray;
@property (nonatomic, assign) NSInteger shopZonePosition;

@property (nonatomic, strong) NSArray *shopAddressArray;
@property (nonatomic, strong) NSMutableArray *shopAddressTitleArray;
@property (nonatomic, assign) NSInteger shopAddressPosition;

@property (nonatomic, strong) NSArray *selectedGiftArray;
@property (nonatomic, strong) NSMutableArray *giftTitleArray;
@property (nonatomic, assign) NSInteger giftPosition;

@property (nonatomic, strong) UIAlertView *resultAlert;

@property (nonatomic, copy) NSString *toAddress;

@end

@implementation BirthdayOfferApplyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.defaultByPostHeight = self.byPostHeight.constant;
    self.defaultByPickupHeight = self.byPickupHeight.constant;
    
    self.navBarTitleKey = @"birthday_apply_title";
    self.collectTitleArray = [NSArray arrayWithObjects:AMLocalizedString(@"select", nil), AMLocalizedString(@"birthday_apply_by_post", nil), AMLocalizedString(@"birthday_apply_by_pickup", nil), nil];
    
    // Get shop zone
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_SHOP_ZONE] parameters:nil tag:ROUTE_GET_SHOP_ZONE];
    
    // Get login detail
    if ([LoginUtil getInstance].detail == nil && [LoginUtil getCardNumber] && [LoginUtil getPassword]) {
        [self.communicator startIndicator];
        
        // Prepare API request
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setValue:[LoginUtil getCardNumber] forKey:CARD_NUMBER];
        [parameters setValue:[LoginUtil getPassword] forKey:HASH];
        
        [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_LOGIN_CHECK] isPost:YES parameters:parameters tag:ROUTE_LOGIN_CHECK];
    } else {
        [self initFormWithDetail];
    }
}

- (void)reloadLocalization
{
    [super reloadLocalization];
    
    self.titleLabel.text = self.birthdayOffer[TITLE];
    
    self.selectedGiftArray = self.birthdayOffer[SELECTES];
    self.giftTitleArray = [NSMutableArray new];
    [self.giftTitleArray addObject:AMLocalizedString(@"select", nil)];
    for (NSDictionary *select in self.selectedGiftArray) {
        [self.giftTitleArray addObject:select[TITLE]];
    }
    
    if (self.selectedGiftArray.count == 0) {
        [self.giftValueLabel removeFromSuperview];
        [self.giftView removeFromSuperview];
    }
    
    self.nameLabel.text = AMLocalizedString(@"birthday_apply_name", nil);
    self.phoneLabel.text = AMLocalizedString(@"birthday_apply_telephone", nil);
    self.emailLabel.text = AMLocalizedString(@"birthday_apply_email", nil);
    self.collectLabel.text = AMLocalizedString(@"birthday_apply_collect", nil);
    self.addressLabel.text = AMLocalizedString(@"birthday_apply_address", nil);
    self.shopZoneLabel.text = AMLocalizedString(@"birthday_apply_shop_zone", nil);
    self.shopAddressLabel.text = AMLocalizedString(@"birthday_apply_shop_address", nil);
    self.giftLabel.text = AMLocalizedString(@"birthday_apply_option", nil);
    
    [self.submitButton setTitle:AMLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    
    // Prepare filter
    self.phoneZoneArray = [NSArray arrayWithObjects:AMLocalizedString(@"852", nil), AMLocalizedString(@"86", nil), AMLocalizedString(@"853", nil), nil];
    
    // Set default
    [self selectPhoneZone:0];
    [self selectCollect:0];
    [self selectGift:0];
}

- (void)initFormWithDetail
{
    NSDictionary *detail = [LoginUtil getInstance].detail;
    NSString *name = [LoginUtil getName];
    NSString *phone = detail[TEL1];
    
    self.nameTextField.text = name;
    self.nameTextField.enabled = NO;
    self.phoneTextField.text = phone;
}

- (void)selectPhoneZone:(NSInteger)position
{
    self.phoneZonePosition = position;
    self.phoneZoneValueLabel.text = [self.phoneZoneArray objectAtIndex:position];
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
            self.byPickupHeight.constant = self.defaultByPickupHeight;
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

- (void)selectShopZone:(NSInteger)position
{
    if (position < self.shopZoneTitleArray.count) {
        self.shopZonePosition = position;
        self.shopZoneValueLabel.text = [self.shopZoneTitleArray objectAtIndex:position];
    }
    
    if (position - 1 < self.shopZoneArray.count) {
        NSDictionary *shopZone = [self.shopZoneArray objectAtIndex:position - 1];//not include 0 - "select"
        
        // Get shop
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setValue:shopZone[SHOP_ZONE_ID] forKey:SHOP_ZONE_ID];
        [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_SHOP_ZONE] parameters:parameters tag:ROUTE_GET_SHOP_ZONE];
        
    }
    
    self.shopAddressArray = nil;
    self.shopAddressTitleArray = nil;
    self.shopAddressPosition = -1;
    [self.shopAddressTableView reloadData];
    if (self.byPickupHeight.constant > 0) {
        self.byPickupHeight.constant = self.shopAddressTableView.frame.origin.y + self.shopAddressTableViewHeight.constant + 20/* margin */;
    }
}

- (void)selectGift:(NSInteger)position
{
    if (position < self.giftTitleArray.count) {
        self.giftPosition = position;
        self.giftValueLabel.text = [self.giftTitleArray objectAtIndex:position];
    }
}

- (IBAction)selectPhoneZonePicker:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.phoneZoneArray
                                initialSelection:self.phoneZonePosition
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [self selectPhoneZone:selectedIndex];
                                       }
                                     cancelBlock:nil
                                          origin:self.phoneZoneValueLabel];
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

- (IBAction)selectShopZonePicker:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.shopZoneTitleArray
                                initialSelection:self.shopZonePosition
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [self selectShopZone:selectedIndex];
                                       }
                                     cancelBlock:nil
                                          origin:self.shopZoneValueLabel];
}

- (IBAction)selectGiftPicker:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.giftTitleArray
                                initialSelection:self.giftPosition
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [self selectGift:selectedIndex];
                                       }
                                     cancelBlock:nil
                                          origin:self.giftValueLabel];
}

- (IBAction)selectSubmit:(id)sender
{
    NSString *errorMessage = @"";
    
    if (self.emailTextField.text.length == 0 && self.phoneTextField.text.length == 0) {
        errorMessage = [errorMessage stringByAppendingString:AMLocalizedString(@"error_phone_or_email", nil)];
    }
    
    if (self.collectPosition == 0) {
        errorMessage = [errorMessage stringByAppendingString:AMLocalizedString(@"birthday_apply_error_collect", nil)];
    }
    
    if (self.collectPosition == 1/*1表示郵寄掛號*/ && self.addressTextField.text.length == 0) {
        errorMessage = [errorMessage stringByAppendingString:AMLocalizedString(@"error_address", nil)];
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
    [parameters setValue:[@(self.birthdayId) stringValue] forKey:BIRTHDAY_ID];
    [parameters setValue:[LoginUtil getCardNumber] forKey:MEMBER_CARD_NUMBER];
    
    NSString *phoneZone = (self.phoneZonePosition == 0) ? @"852" : (self.phoneZonePosition == 1) ? @"86" : @"853";
    [parameters setValue:phoneZone forKey:TELEPHONE_ZONE];
    [parameters setValue:self.phoneTextField.text forKey:TELEPHONE];
    
    //取值有1和2；1表示郵寄掛號，2表示商店自取
    [parameters setValue:[@(self.collectPosition) stringValue] forKey:COLLECT_TYPE];
    
    if (self.collectPosition == 1)
    {
        //如果是 邮寄挂号则 address 为必选项，邮寄地址
        [parameters setValue:self.addressTextField.text forKey:ADDRESS];
        self.toAddress = self.addressTextField.text;
    }
    else if (self.collectPosition == 2)
    {
        //如果是 商店自取则 shop_id为必选项，表示商店 ID
        if (self.shopAddressPosition < self.shopAddressArray.count) {
            NSDictionary *shopAddress = [self.shopAddressArray objectAtIndex:self.shopAddressPosition];
            NSString *shopAddressTitle = [self.shopAddressTitleArray objectAtIndex:self.shopAddressPosition];
            [parameters setValue:shopAddress[SHOP_ID] forKey:SHOP_ID];
            self.toAddress = shopAddressTitle;
        }
    }
    
    if (self.giftPosition - 1 < self.selectedGiftArray.count) {
        NSDictionary *selectedGift = [self.selectedGiftArray objectAtIndex:self.giftPosition - 1];//not include 0 - "select"
        [parameters setValue:selectedGift[GIFT_SELECT_ID] forKey:GIFT_SELECT_ID];
    }
    
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_APPLY_BIRTHDAY_OFFER] isPost:YES parameters:parameters tag:ROUTE_APPLY_BIRTHDAY_OFFER];
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    NSString *tag = jsonObject[TAG];
    
    if ([tag isEqualToString:ROUTE_GET_SHOP_ZONE]) {
        if (jsonObject[SHOP_ZONES]) {
            self.shopZoneArray = jsonObject[SHOP_ZONES];
            self.shopZoneTitleArray = [NSMutableArray new];
            [self.shopZoneTitleArray addObject:AMLocalizedString(@"select", nil)];
            for (NSDictionary *shopZone in self.shopZoneArray) {
                [self.shopZoneTitleArray addObject:shopZone[NAME]];
            }
            
            // Set default
            [self selectShopZone:0];
        } else if (jsonObject[SHOPS]) {
            self.shopAddressArray = jsonObject[SHOPS];
            self.shopAddressTitleArray = [NSMutableArray new];
            for (NSDictionary *shop in self.shopAddressArray) {
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
                
                [self.shopAddressTitleArray addObject:[HtmlUtil decodeHTML:shopAddressString]];
            }
            [self.shopAddressTableView reloadData];
        }
    } else if ([tag isEqualToString:ROUTE_APPLY_BIRTHDAY_OFFER]) {
        NSString *giftName = self.birthdayOffer[TITLE];
        NSString *message = [NSString stringWithFormat:AMLocalizedString(@"birthday_apply_success", nil), giftName, self.toAddress];
        self.resultAlert = [[UIAlertView alloc] initWithTitle:nil
                                                      message:message
                                                     delegate:self
                                            cancelButtonTitle:AMLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil];
        [self.resultAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (alertView == self.resultAlert) {
        [self popBack];
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
