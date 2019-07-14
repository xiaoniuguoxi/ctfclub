//
//  CommonItemDetailViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "CommonItemDetailViewController.h"
#import "SwipeThumbnailImageView.h"
#import <MediaPlayer/MediaPlayer.h>

#define THUMBNAIL_WIDTH 120
#define THUMBNAIL_HEIGHT 80

@interface CommonItemDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *imageDescLabel;
@property (weak, nonatomic) IBOutlet SwipeView *thumbnailSwipeView;
@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) NSInteger currentImagePosition;
@property (nonatomic, copy) NSString *shareUrl;

@end

@implementation CommonItemDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"CommonItemDetailViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentView.hidden = YES;
    
    // Prepare right bar button
    self.navigationItem.rightBarButtonItem = [CommonUtil barButtonItemFromImageNamed:@"ic_nav_share"
                                                                          target:self
                                                                        selector:@selector(shareProduct)];
    
    // Set transparent to show the grey background
    [self.descriptionWebView setBackgroundColor:[UIColor clearColor]];
    [self.descriptionWebView setOpaque:NO];
    
    // Set webview delegate
    self.descriptionWebView.delegate = self;
    
    // Disable bounces
    self.descriptionWebView.scrollView.scrollEnabled = NO;
    self.descriptionWebView.scrollView.bounces = NO;
}

- (void)reloadLocalization
{
    [super reloadLocalization];
    
    if (self.upperButtonTranslationKey) {
        [self.upperButton setTitle:AMLocalizedString(self.upperButtonTranslationKey, nil) forState:UIControlStateNormal];
    } else {
        [self.upperButton removeFromSuperview];
    }
    
    if (self.lowerButtonTranslationKey) {
        [self.lowerButton setTitle:AMLocalizedString(self.lowerButtonTranslationKey, nil) forState:UIControlStateNormal];
    } else {
        [self.lowerButton removeFromSuperview];
    }
    
    self.messageLabel.text = nil;
}

- (void)selectImage:(NSInteger)position
{
    self.currentImagePosition = position;
    
    NSDictionary *image = [self.images objectAtIndex:self.currentImagePosition];
    [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:[image[THUMB] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    if (image[NAME] != nil && image[NAME] != [NSNull null]) {
        self.imageDescLabel.text = [HtmlUtil decodeHTML:image[NAME]];
    } else {
        self.imageDescLabel.text = nil;
    }
}

- (void)assignValues
{
    if (self.item) {
        if (self.item[TITLE] != nil && self.item[TITLE] != [NSNull null]) {
            self.titleLabel.text = [HtmlUtil decodeHTML:self.item[TITLE]];
        }
        
        self.images = self.item[IMAGES];
        if (self.images && [self.images count] > 0) {
            [self selectImage:0];
            
            self.photos = [NSMutableArray array];
            for (NSDictionary *image in self.images) {
                MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[image[IMAGE] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                if (image[NAME] != nil && image[NAME] != [NSNull null]) {
                    NSString *caption = [HtmlUtil decodeHTML:image[NAME]];
                    if (caption.length > 0) {
                        // imge description
                        photo.caption = caption;
                    }
                }
                [self.photos addObject:photo];
            }
        }
        
        // show the thumbnail list only if there is more then one image
        if (!self.images || [self.images count] < 2) {
            [self.thumbnailSwipeView removeFromSuperview];
        }
        
        [self.thumbnailSwipeView reloadData];
        
        NSString *textShowEnd = @"";
        if (self.item[TEXT_SHOW_END] != nil && self.item[TEXT_SHOW_END] != [NSNull null] && [self.item[TEXT_SHOW_END] intValue] == 1) {
            textShowEnd = [NSString stringWithFormat:@"<div>%@</div>", AMLocalizedString(@"event_end", nil)];
        }
        
        if (self.item[DESCRIPTION] != nil && self.item[DESCRIPTION] != [NSNull null]) {
            NSString *header = @"<html><head><style type=\"text/css\">body {font-family:Arial;}</style></head><body>";
            NSString *footer = @"</body></html>";
            NSString *description = [NSString stringWithFormat:@"%@%@%@%@", header, textShowEnd, self.item[DESCRIPTION], footer];
            
            [self.descriptionWebView loadHTMLString:description baseURL:nil];
        }
        
        NSString *tag = [UserDefaultsUtil getShareTag];
        if (self.item[tag] != nil && self.item[tag] != [NSNull null]) {
            self.shareUrl = self.item[tag];
        }
        
        self.contentView.hidden = NO;
    }
}

- (void)shareProduct
{
    NSString *textToShare = [self.titleLabel.text stringByAppendingFormat:@": %@", [HtmlUtil decodeHTML:self.shareUrl]];
    NSMutableArray *itemsToShare = [[NSMutableArray alloc] initWithObjects:textToShare, nil];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //Exclude whichever aren't relevant
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)openPhotoViewer:(id)sender
{
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
    [browser setCurrentPhotoIndex:self.currentImagePosition];
    
    // Present
    [self.navigationController.parentViewController.navigationController pushViewController:browser animated:YES];
}

- (IBAction)selectSubmit:(id)sender
{
    // implement in subclass
}

- (void)playVideo:(NSString *)videoUrl
{
    NSURL *url = [NSURL URLWithString:[videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    MPMoviePlayerViewController *movieViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    movieViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    
    // Self is the UIViewController you are presenting the movie player from.
    [self.navigationController.parentViewController.navigationController presentMoviePlayerViewControllerAnimated:movieViewController];
}

#pragma mark - UIWebViewDelegate

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    // auto resize the webview to fit the content
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    self.webViewHeightConstraint.constant = [result integerValue] + 20 /*buffer or margin*/;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark - SwipeViewDataSource

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.images ? [self.images count] : 0;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    SwipeThumbnailImageView *imageView = [[SwipeThumbnailImageView alloc] initWithFrame:CGRectMake(0, 0, THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)];
    
    NSDictionary *image = [self.images objectAtIndex:index];
    [imageView.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:[image[THUMB] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    return imageView;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT);
}

#pragma mark - SwipeViewDelegate

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    [self selectImage:index];
}

@end
