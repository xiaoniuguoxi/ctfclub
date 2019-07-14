//
//  NewslettersViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 1/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "NewslettersViewController.h"
#import "ActionSheetStringPicker.h"
#import "SVModalWebViewController.h"

@interface NewslettersViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) int page;

@property (nonatomic, strong) NSMutableArray *itemTitleArray;
@property (nonatomic, assign) NSInteger currentItemPosition;

@end

@implementation NewslettersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarTitleKey = @"title_newsletter";
    self.showLoginButton = YES;
    self.showLogoutButton = NO;
    
    self.scrollView.hidden = YES;
    
    // Prepare load items
    self.currentItemPosition = -1;
    self.page = 1;
    self.items = [NSMutableArray new];
    self.itemTitleArray = [NSMutableArray new];
    [self reloadItems];
}

- (void)reloadItems
{
    [self.communicator startIndicator];
    
    // Prepare API request
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:[@(self.page) stringValue] forKey:PAGE];
    
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_NEWSLETTERS] parameters:parameters tag:nil];
}

- (void)selectItem:(NSInteger)position
{
    self.filterLabel.text = [self.itemTitleArray objectAtIndex:position];
    self.currentItemPosition = position;
    
    if (position < [self.items count]) {
        NSDictionary *item = [self.items objectAtIndex:position];
        if (item[TITLE] != nil && item[TITLE] != [NSNull null]) {
            self.titleLabel.text = [HtmlUtil decodeHTML:item[TITLE]];
        }
        
        if (item[IMAGE] != nil && item[IMAGE] != [NSNull null]) {
            [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:[item[IMAGE] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl)
             {
                 // Resize the thunbmail to content height
                 CGFloat width = image.size.width;
                 CGFloat height = image.size.height;
                 self.heightConstraint.constant = self.thumbnailImageView.frame.size.width / width * height;
             }];
        } else {
            self.thumbnailImageView.image = nil;
        }
    }
}

- (IBAction)selectFilter:(id)sender
{
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:self.itemTitleArray
                                initialSelection:self.currentItemPosition
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [self selectItem:selectedIndex];
                                       }
                                     cancelBlock:nil
                                          origin:self.filterLabel];
}

- (IBAction)openInAppBrowser:(id)sender
{
    NSDictionary *item = [self.items objectAtIndex:self.currentItemPosition];
    
    NSString *link = item[LINK];
    if (link == nil || link == NULL || link.length == 0) {
        if (item[IMAGE] != nil && item[IMAGE] != [NSNull null]) {
            link = [item[IMAGE] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    
//    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:link];
//    [webViewController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self presentViewController:webViewController animated:YES completion:NULL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

#pragma mark - CommunicatorProtocolDelegate

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [super handleResponse:jsonObject];
    
    NSArray *items = jsonObject[NEWSLETTERS];
    for (NSDictionary *item in items) {
        [self.items addObject:item];
        
        // prepare string array for filter
        int monthNumber = [item[MONTH] intValue];
        NSArray *monthTranslationKey = [NSArray arrayWithObjects:@"jan", @"feb", @"mar", @"apr", @"may", @"jun", @"jul", @"aug", @"sep", @"oct", @"nov", @"dec", nil];
        NSString *monthStr = AMLocalizedString([monthTranslationKey objectAtIndex:monthNumber - 1], nil);
        NSString *yearMonthStr = [NSString stringWithFormat:@"%@%@ %@", item[YEAR], AMLocalizedString(@"year", nil), monthStr];
        
        [self.itemTitleArray addObject:yearMonthStr];
    }
    
    if (self.items.count > 0) {
        self.scrollView.hidden = NO;
    }
    
    if (self.currentItemPosition == -1) {
        // show the first item as default
        [self selectItem:0];
    }
    
    // load more if there are remaining pages
    if (self.page < [jsonObject[PAGE_TOTAL] intValue]) {
        self.page++;
        [self reloadItems];
    }
}

@end
