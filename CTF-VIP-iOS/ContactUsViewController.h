//
//  ContactUsViewController.h
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 26/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "CommonViewController.h"

@interface ContactUsViewController : CommonViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *formNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *formTitleValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *formNameValueTextField;
@property (weak, nonatomic) IBOutlet UILabel *formEmailLabel;
@property (weak, nonatomic) IBOutlet UITextField *formEmailValueTextField;
@property (weak, nonatomic) IBOutlet UILabel *formEnquiryLabel;
@property (weak, nonatomic) IBOutlet UITextView *formEnquiryValueTextView;

@property (weak, nonatomic) IBOutlet UILabel *formImageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (nonatomic, strong) NSArray *nameTitleArray;
@property (nonatomic, assign) NSInteger nameTitlePosition;

@property (nonatomic, assign) bool isImageSelected;

- (BOOL)validateForm;

- (void)checkCamera;

- (IBAction)selectReset:(id)sender;

@end
