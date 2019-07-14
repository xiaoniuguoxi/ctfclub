//
//  MembershipCardQRCodeViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 2/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "MembershipCardQRCodeViewController.h"
#import "UIImage+MDQRCode.h"

@interface MembershipCardQRCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@end

@implementation MembershipCardQRCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *cardNumber = [LoginUtil getCardNumber];
    if (cardNumber) {
        self.qrCodeImageView.image = [UIImage mdQRCodeForString:cardNumber size:self.qrCodeImageView.bounds.size.width fillColor:[UIColor darkGrayColor]];
    }
}

@end
