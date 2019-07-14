//
//  AdViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 7/1/2016.
//  Copyright © 2016 ctf. All rights reserved.
//

#import "AdViewController.h"

@interface AdViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

@end

@implementation AdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.imageUrl != nil && self.imageUrl.length > 0) {
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:[self.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
}

- (IBAction)selectAdImageView:(id)sender
{
    if (self.linkUrl != nil && self.linkUrl.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkUrl]];
    }
}

- (IBAction)selectClose:(id)sender
{
    [self popBack];
}

@end
