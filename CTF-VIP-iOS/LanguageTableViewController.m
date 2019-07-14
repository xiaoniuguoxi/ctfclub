//
//  LanguageTableViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "LanguageTableViewController.h"
#import "UserDefaultsUtil.h"
#import "LocalizationSystem.h"
#import "LanguageViewController.h"
#import "TabViewController.h"

@interface LanguageTableViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *enCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *zhhkCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *zhcnCell;

@property (weak, nonatomic) IBOutlet UIImageView *enTickImageView;
@property (weak, nonatomic) IBOutlet UIImageView *zhhkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *zhcnImageView;

@end

@implementation LanguageTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadLanguageSelection];
}

- (void)reloadLanguageSelection
{
    id language = [UserDefaultsUtil getLanguageCode];
    self.enTickImageView.hidden = ([language isEqualToString:LANG_EN] == false);
    self.zhhkImageView.hidden = ([language isEqualToString:LANG_ZH_HK] == false);
    self.zhcnImageView.hidden = ([language isEqualToString:LANG_ZH_CN] == false);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellSelected = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cellSelected == self.enCell) {
        [UserDefaultsUtil setLanguageCode:LANG_EN];
    } else if (cellSelected == self.zhhkCell) {
        [UserDefaultsUtil setLanguageCode:LANG_ZH_HK];
    } else if (cellSelected == self.zhcnCell) {
        [UserDefaultsUtil setLanguageCode:LANG_ZH_CN];
    } else {
        return;
    }
    
    // Make localization effective
    LocalizationSetLanguage([UserDefaultsUtil getLocaleCode]);
    
    // Clear the member detail cache
    [LoginUtil getInstance].detail = nil;
    
    // Reload tick images
    [self reloadLanguageSelection];
    
    // Reload VC nav title
    LanguageViewController *parentVC = (LanguageViewController *)self.parentViewController;
    [parentVC reloadLocalization];
    
    // Reload tab menu
    TabViewController *tabVC = (TabViewController *)parentVC.parentViewController.parentViewController;
    [tabVC.tabbarSwipeView reloadData];
}

@end
