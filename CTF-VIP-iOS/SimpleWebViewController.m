//
//  SimpleWebViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 29/12/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "SimpleWebViewController.h"

@interface SimpleWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, copy) NSString *urlString;

@end

@implementation SimpleWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"SimpleWebViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithAddress:(NSString*)urlString withTitleKey:(NSString *)navBarTitleKey
{
    self = [super init];
    if (self) {
        self.urlString = urlString;
        self.navBarTitleKey = navBarTitleKey;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.webView setScalesPageToFit:YES];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

@end
