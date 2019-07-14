//
//  MembershipBarcodeViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 7/12/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "MembershipBarcodeViewController.h"

@interface MembershipBarcodeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@end

@implementation MembershipBarcodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *cardNumber = [LoginUtil getCardNumber];
    if (cardNumber) {
        self.barcodeLabel.text = [NSString stringWithFormat:@"*%@*", cardNumber];
        self.cardNumberLabel.text = cardNumber;
        self.timestampLabel.text = nil;
    }
    
    [self updateTimestampLabel];
    
    // init timer for changing top banner every 1 second
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimestampLabel) userInfo:nil repeats:YES];
}

- (void)updateTimestampLabel
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    self.timestampLabel.text = dateString;
}

@end
