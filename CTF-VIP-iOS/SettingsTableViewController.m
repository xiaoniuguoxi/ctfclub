//
//  SettingsTableViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 24/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "UserDefaultsUtil.h"
#import "SettingsViewController.h"
#import "LanguageViewController.h"
#import "InformationViewController.h"
#import "SimpleWebViewController.h"

@interface SettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *languageCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *termsOfUseCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *privacyPolicyCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *programmeTermsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *helpCell;

@property (weak, nonatomic) IBOutlet UILabel *preferenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *manualLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *termsOfUseLabel;
@property (weak, nonatomic) IBOutlet UILabel *privacyPolicyLabel;
@property (weak, nonatomic) IBOutlet UILabel *programmeTermsLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadLocalization];
    [self reloadLanguageSelection];
}

- (void)reloadLocalization
{
    self.preferenceLabel.text = AMLocalizedString(@"settings_preference", nil);
    self.languageLabel.text = AMLocalizedString(@"settings_language", nil);
    self.manualLabel.text = AMLocalizedString(@"settings_manual", nil);
    self.termsOfUseLabel.text = AMLocalizedString(@"settings_terms_of_use", nil);
    self.privacyPolicyLabel.text = AMLocalizedString(@"settings_privacy_policy", nil);
    self.programmeTermsLabel.text = AMLocalizedString(@"settings_programme_terms", nil);
    self.helpLabel.text = AMLocalizedString(@"settings_help", nil);
}

- (void)reloadLanguageSelection
{
    id language = [UserDefaultsUtil getLanguageCode];
    NSString *languageValue = nil;
    if ([language isEqualToString:LANG_EN]) {
        languageValue = LANG_EN_TEXT;
    } else if ([language isEqualToString:LANG_ZH_HK]) {
        languageValue = LANG_ZH_HK_TEXT;
    } else if ([language isEqualToString:LANG_ZH_CN]) {
        languageValue = LANG_ZH_CN_TEXT;
    }
    self.languageValueLabel.text = languageValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsViewController *parentVC = (SettingsViewController *)self.parentViewController;
    
    UITableViewCell *cellSelected = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cellSelected == self.languageCell) {
        LanguageViewController *languageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LanguageViewController"];
        [parentVC.navigationController pushViewController:languageVC animated:YES];
    } else if (cellSelected == self.termsOfUseCell) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserDefaultsUtil getTermsUrl]]];
    } else if (cellSelected == self.privacyPolicyCell) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserDefaultsUtil getPrivacyUrl]]];
    } else if (cellSelected == self.programmeTermsCell) {
//        SimpleWebViewController *vc = [[SimpleWebViewController alloc] initWithAddress:[UserDefaultsUtil getProgrammeTermsUrl] withTitleKey:@"settings_programme_terms"];
//        vc.pushedWithNavBar = YES;
//        [parentVC.navigationController pushViewController:vc animated:YES];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserDefaultsUtil getProgrammeTermsUrl]]];
    } else if (cellSelected == self.helpCell) {
        [self openInformationVC:HELP_INFORMATION_ID];
    }
}

- (void)openInformationVC:(int)informationId
{
    SettingsViewController *parentVC = (SettingsViewController *)self.parentViewController;
    
    InformationViewController *informationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InformationViewController"];
    informationVC.informationId = informationId;
    [parentVC.navigationController pushViewController:informationVC animated:YES];
}

@end
