//
//  MembershipCardViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 2/12/2015.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "MembershipCardViewController.h"

@interface MembershipCardViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;

@property (nonatomic, strong) MWPhoto *cardImagePhoto;

@end

@implementation MembershipCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([LoginUtil getCardNumber] && [LoginUtil getPassword]) {
        [self.communicator startIndicator];
        
        // Prepare API request
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setValue:[LoginUtil getCardNumber] forKey:CARD_NUMBER];
        [parameters setValue:[LoginUtil getPassword] forKey:HASH];
        
        [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_CARD_IMAGE] isPost:YES parameters:parameters tag:ROUTE_GET_CARD_IMAGE];
    }
}

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    NSString *tag = jsonObject[TAG];
    
    if ([tag isEqualToString:ROUTE_GET_CARD_IMAGE]) {
        NSString *base64String = jsonObject[IMAGE];
        
        NSData *imageData = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:imageData];
        
        self.cardImageView.image = image;
        self.cardImagePhoto = [MWPhoto photoWithImage:image];
    }
}

- (IBAction)openPhotoViewer:(id)sender
{
    if  (self.cardImagePhoto == nil) {
        return;
    }
    
    // Create browser (must be done each time photo browser is
    // displayed. Photo browser objects cannot be re-used)
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = NO; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = YES; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = NO; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:0];
    
    // Present
    [self.parentViewController.navigationController.parentViewController.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return self.cardImagePhoto;
}

@end
