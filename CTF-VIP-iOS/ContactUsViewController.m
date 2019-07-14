//
//  ContactUsViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 26/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "ContactUsViewController.h"
#import "ActionSheetStringPicker.h"

#define CONTACT_HOTLINE @"(+852) 2138 3399"
#define CONTACT_EMAIL @"ctfclub@chowtaifook.com"

@interface ContactUsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotlineValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, strong) UIAlertView *resultAlert;

@end

@implementation ContactUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarTitleKey = @"title_contact_us";
    self.showLoginButton = YES;
    self.showLogoutButton = NO;
    
    [self checkCamera];
    self.isImageSelected = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Get login detail
    if ([LoginUtil getInstance].detail == nil) {
        if ([LoginUtil getCardNumber] && [LoginUtil getPassword]) {
            [self.communicator startIndicator];
            
            // Prepare API request
            NSMutableDictionary *parameters = [NSMutableDictionary new];
            [parameters setValue:[LoginUtil getCardNumber] forKey:CARD_NUMBER];
            [parameters setValue:[LoginUtil getPassword] forKey:HASH];
            
            [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_LOGIN_CHECK] isPost:YES parameters:parameters tag:ROUTE_LOGIN_CHECK];
        }
    } else {
        [self initFormWithDetail];
    }
}

- (void)reloadLocalization
{
    [super reloadLocalization];
    
    self.titleLabel.text = AMLocalizedString(@"contact_us_header", nil);
    self.hotlineLabel.text = AMLocalizedString(@"contact_us_ctf_hotline", nil);
    self.hotlineValueLabel.text = CONTACT_HOTLINE;
    self.emailLabel.text = AMLocalizedString(@"contact_us_ctf_email", nil);
    self.emailValueLabel.text = CONTACT_EMAIL;
    self.addressLabel.text = AMLocalizedString(@"contact_us_ctf_address", nil);
    self.addressValueLabel.text = AMLocalizedString(@"contact_us_ctf_address_value", nil);
    self.descriptionLabel.text = AMLocalizedString(@"contact_us_ctf_description", nil);
    
    self.formNameLabel.text = AMLocalizedString(@"contact_us_form_name", nil);
    self.formEmailLabel.text = AMLocalizedString(@"contact_us_form_email_address", nil);
    self.formEnquiryLabel.text = AMLocalizedString(@"contact_us_form_enquiry", nil);
    self.formImageLabel.text = AMLocalizedString(@"contact_us_form_image", nil);
    
    [self.cameraButton setTitle:AMLocalizedString(@"take_photo", nil) forState:UIControlStateNormal];
    [self.galleryButton setTitle:AMLocalizedString(@"select_from_gallery", nil) forState:UIControlStateNormal];
    
    [self.submitButton setTitle:AMLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    [self.resetButton setTitle:AMLocalizedString(@"reset", nil) forState:UIControlStateNormal];
    
    // Prepare filter
    self.nameTitleArray = [NSArray arrayWithObjects:AMLocalizedString(@"mr", nil), AMLocalizedString(@"ms", nil), AMLocalizedString(@"mrs", nil), nil];
    
    [self selectTitle:0];
}

- (void)initFormWithDetail
{
    NSDictionary *detail = [LoginUtil getInstance].detail;
    if (detail != nil) {
        NSString *titleDesc = [detail[Customer_Title_Desc_Eng] lowercaseString];
        NSString *name = [LoginUtil getName];
        
        if ([titleDesc containsString:@"mrs"]) {
            [self selectTitle:2];
        } else if ([titleDesc containsString:@"ms"]) {
            [self selectTitle:1];
        } else {
            [self selectTitle:0];
        }
        
        self.formNameValueTextField.text = name;
    }
}

- (void)selectTitle:(NSInteger)position
{
    self.nameTitlePosition = position;
    self.formTitleValueLabel.text = [self.nameTitleArray objectAtIndex:position];
}

- (IBAction)selectTitlePicker:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.nameTitleArray
                                initialSelection:self.nameTitlePosition
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [self selectTitle:selectedIndex];
                                       }
                                     cancelBlock:nil
                                          origin:self.formTitleValueLabel];
}

- (BOOL)validateForm
{
    NSString *errorMessage = @"";
    
    if (self.formNameValueTextField.text.length < 3 || self.formNameValueTextField.text.length > 32) {
        errorMessage = [errorMessage stringByAppendingString:AMLocalizedString(@"error_name", nil)];
    }
    
    if (![LoginUtil isValidEmail:self.formEmailValueTextField.text]) {
        errorMessage = [errorMessage stringByAppendingString:AMLocalizedString(@"error_email", nil)];
    }
    
    if (self.formEnquiryValueTextView.text.length < 10 || self.formEnquiryValueTextView.text.length > 3000) {
        errorMessage = [errorMessage stringByAppendingString:AMLocalizedString(@"error_enquiry", nil)];
    }
    
    if (errorMessage.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"error", nil)
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:AMLocalizedString(@"ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
        return false;
    }
    
    return true;
}

- (IBAction)selectSubmit:(id)sender
{
    if ([self validateForm])
    {
        [self.communicator startIndicator];
        
        // Prepare API request
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setValue:[@(self.nameTitlePosition) stringValue] forKey:GENDER];
        [parameters setValue:self.formNameValueTextField.text forKey:NAME];
        [parameters setValue:self.formEmailValueTextField.text forKey:EMAIL];
        [parameters setValue:self.formEnquiryValueTextView.text forKey:ENQUIRY];
        
        if (self.isImageSelected) {
            NSString *imageBase64Binary = [UIImageJPEGRepresentation(self.previewImageView.image, 0.8) base64Encoding];
            [parameters setValue:imageBase64Binary forKey:IMAGE];
        }
        
        [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_CONTACT_US] isPost:YES parameters:parameters tag:ROUTE_CONTACT_US];
    }
}

- (IBAction)selectReset:(id)sender
{
    [self selectTitle:0];
    [self.formNameValueTextField setText:nil];
    [self.formEmailValueTextField setText:nil];
    [self.formEnquiryValueTextView setText:nil];
    
    self.previewImageView.image = [UIImage imageNamed:@"ic_camera"];
    self.isImageSelected = NO;
    
    [self initFormWithDetail];
}

- (void)checkCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.cameraButton removeFromSuperview];
    }
}

- (IBAction)takePhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    float scale = chosenImage.size.width / chosenImage.size.height;
    self.previewImageView.image = [self imageWithImage:chosenImage scaledToSize:CGSizeMake(400*scale, 400)];
    self.isImageSelected = YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    NSString *tag = jsonObject[TAG];
    
    if ([tag isEqualToString:ROUTE_CONTACT_US] || [tag isEqualToString:ROUTE_INQUIRY] ) {
        self.resultAlert = [[UIAlertView alloc] initWithTitle:nil
                                                      message:AMLocalizedString(@"enquiry_thank_you", nil)
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
        [self selectReset:nil];
    }
}

@end
