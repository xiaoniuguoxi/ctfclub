//
//  CTFMenuVC.m
//  CTF-VIP-iOS
//
//  Created by HughChiu on 2019/7/12.
//  Copyright © 2019 ctf. All rights reserved.
//

#import "CTFMenuVC.h"
#import "CTFDefine.h"
#import "CTFSliderVC.h"
#import "UIView+Frame.h"
#import "CTFMenuHead.h"
#import "CTFNavC.h"
#import "NewsPromotionsViewController.h"
#import "ServiceProductInquiryViewController.h"
#import "CTFNewsVC.h"
#import "CTFWebVC.h"

@interface CTFMenuVC () <UITableViewDelegate, UITableViewDataSource, FoldSectionHeaderViewDelegate>
{
    UITableView *menuTable;
    UILabel *goldPriceLab;
    UILabel *stockCodeLab;
    NSArray *menuArray;
    NSArray *menuDetailArray;
    NSMutableDictionary *foldInfoDic;
    NSDictionary *topInfoDic;
}
@end

@implementation CTFMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.communicator = [CommunicationProtocol new];
    self.communicator.delegate = self;
    
    menuArray = @[@"最新消息及推广优惠", @"生日礼遇", @"精彩活动", @"关于我们", @"海外购物专区", @"网站助手"];
    
    NSArray *first = @[@"推广优惠", @"最新消息", @"会员专区"];
    NSArray *second = @[@"A WORLD OF REWARDS", @"生日礼遇", @"礼宾司服务"];
    NSArray *third = @[@"活动推介", @"活动花絮"];
    NSArray *forth = @[@"About CTF Club", @"Membership Tier"];
    NSArray *fifth = @[@"港澳会员登记购物单据", @"中国会员登记购物单据", @"台湾会员登记购物单据", @"新会员注册"];
    NSArray *sixth = @[@"常见问题解答", @"联络我们"];
    
    menuDetailArray = @[first, second, third, forth, fifth, sixth];
    
    foldInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                   @"0":@"0",
                                                                   @"1":@"0",
                                                                   @"2":@"0",
                                                                   @"3":@"0",
                                                                   @"4":@"0",
                                                                   @"5":@"0"
                                                                   }];
    
    UIImageView *leftBgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.width * 0.2, SCREEN.height)];
    leftBgIV.image = [UIImage imageNamed:@"ctf_menu_left_bg.jpg"];
    [self.view addSubview:leftBgIV];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, kApplicationStatusBarHeight + 15, 30, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"ctf_btn_popup_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    UIImageView *rightTopView = [[UIImageView alloc] initWithFrame:CGRectMake(leftBgIV.maxX, 0, SCREEN.width - leftBgIV.maxX, kApplicationStatusBarHeight + 200)];
    rightTopView.image = [UIImage imageNamed:@"ctf_menu_right_top_bg.jpg"];
    [self.view addSubview:rightTopView];
    
    goldPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(rightTopView.minX + 10, kApplicationStatusBarHeight + 60, rightTopView.width - 20, 40)];
    goldPriceLab.textColor = [UIColor whiteColor];
    goldPriceLab.font = [UIFont systemFontOfSize:15];
    goldPriceLab.numberOfLines = 0;
    [self.view addSubview:goldPriceLab];
    
    stockCodeLab = [[UILabel alloc] initWithFrame:CGRectMake(rightTopView.minX + 10, goldPriceLab.maxY + 10, rightTopView.width - 20, 40)];
    stockCodeLab.textColor = [UIColor whiteColor];
    stockCodeLab.font = [UIFont systemFontOfSize:15];
    stockCodeLab.numberOfLines = 0;
    [self.view addSubview:stockCodeLab];
    
    menuTable = [[UITableView alloc] initWithFrame:CGRectMake(leftBgIV.maxX, rightTopView.maxY, rightTopView.width, SCREEN.height - rightTopView.maxY)];
    menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    menuTable.delegate = self;
    menuTable.dataSource = self;
    [self.view addSubview:menuTable];
    
    [self reloadTopInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    foldInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                  @"0":@"0",
                                                                  @"1":@"0",
                                                                  @"2":@"0",
                                                                  @"3":@"0",
                                                                  @"4":@"0",
                                                                  @"5":@"0"
                                                                  }];
    [menuTable reloadData];
}

- (void)reloadTopInfo
{
    // Prepare API request
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_MENU_TOP] parameters:nil tag:ROUTE_GET_MENU_TOP];
}

- (void)closeAction:(UIButton *)sender {
    [[CTFSliderVC sharedSliderController] closeSideBar:nil];
}

#pragma mark - -----UITableView Delegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return menuArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [NSString stringWithFormat:@"%d", (int)section];
    BOOL folded = [[foldInfoDic objectForKey:key] boolValue];
    NSArray *arr = menuDetailArray[section];
    return folded ? arr.count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CTFMenuHead *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[CTFMenuHead alloc] initWithReuseIdentifier:@"header"];
    }
    
    [headerView setFoldSectionHeaderViewWithTitle:menuArray[section] detail:@"" type: HerderStyleTotal section:section canFold:YES];
    headerView.delegate = self;
    NSString *key = [NSString stringWithFormat:@"%d", (int)section];
    BOOL folded = [[foldInfoDic valueForKey:key] boolValue];
    headerView.fold = folded;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.contentView.backgroundColor = UIColorFromRGBandAlpha(0xad8587, 1.0);
    NSArray *arr = menuDetailArray[indexPath.section];
    cell.textLabel.text = arr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        CTFNewsVC *newsVC = [[CTFNewsVC alloc] init];
        newsVC.requestType = 0;
        CTFNavC *nav = [[CTFNavC alloc] initWithRootViewController:newsVC];
        [[CTFSliderVC sharedSliderController] showMainVC:nav];
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            CTFWebVC *newsVC = [[CTFWebVC alloc] init];
            newsVC.webUrl = @"https://club.samprasdev.com/index.php?route=ctf/news/AWorld&mobile=1&language=zh-CN";
            CTFNavC *nav = [[CTFNavC alloc] initWithRootViewController:newsVC];
            [[CTFSliderVC sharedSliderController] showMainVC:nav];
        }else if (indexPath.row == 1) {
            CTFNewsVC *newsVC = [[CTFNewsVC alloc] init];
            newsVC.requestType = 1;
            CTFNavC *nav = [[CTFNavC alloc] initWithRootViewController:newsVC];
            [[CTFSliderVC sharedSliderController] showMainVC:nav];
        }else if (indexPath.row == 2) {
            CTFWebVC *newsVC = [[CTFWebVC alloc] init];
            newsVC.webUrl = @"https://club.samprasdev.com/index.php?route=information/concierge&mobile=1&language=zh-CN";
            newsVC.shouldFit = YES;
            CTFNavC *nav = [[CTFNavC alloc] initWithRootViewController:newsVC];
            [[CTFSliderVC sharedSliderController] showMainVC:nav];
        }
        
    }else if (indexPath.section == 2) {
        CTFNewsVC *newsVC = [[CTFNewsVC alloc] init];
        newsVC.requestType = 2;
        CTFNavC *nav = [[CTFNavC alloc] initWithRootViewController:newsVC];
        [[CTFSliderVC sharedSliderController] showMainVC:nav];
    }else if (indexPath.section == 3) {
        CTFNewsVC *newsVC = [[CTFNewsVC alloc] init];
        newsVC.requestType = 3;
        CTFNavC *nav = [[CTFNavC alloc] initWithRootViewController:newsVC];
        [[CTFSliderVC sharedSliderController] showMainVC:nav];
    }else if (indexPath.section == 4) {
        CTFWebVC *newsVC = [[CTFWebVC alloc] init];
        newsVC.shouldFit = YES;
        if (indexPath.row == 0) {
            newsVC.webUrl = @"https://club.samprasdev.com/login1?mobile=1&language=zh-CN";
        }else if (indexPath.row == 1) {
            newsVC.webUrl = @"https://club.samprasdev.com/sms?flag2=2&flag3=0&mobile=1&language=zh-CN";
        }else if (indexPath.row == 2) {
            newsVC.webUrl = @"https://club.samprasdev.com/sms?flag2=2&flag3=1&mobile=1&language=zh-CN";
        }else if (indexPath.row == 3) {
            newsVC.webUrl = @"https://club.samprasdev.com/sms?flag2=3&mobile=1&language=zh-CN";
        }
        CTFNavC *nav = [[CTFNavC alloc] initWithRootViewController:newsVC];
        [[CTFSliderVC sharedSliderController] showMainVC:nav];
    }else if (indexPath.section == 5) {
        CTFWebVC *newsVC = [[CTFWebVC alloc] init];
        
        if (indexPath.row == 0) {
            newsVC.webUrl = @"https://club.samprasdev.com/index.php?route=information/faq&mobile=1&language=zh-CN";
        }else if (indexPath.row == 1) {
            newsVC.webUrl = @"https://club.samprasdev.com/contact?mobile=1&language=zh-CN";
        }
        CTFNavC *nav = [[CTFNavC alloc] initWithRootViewController:newsVC];
        [[CTFSliderVC sharedSliderController] showMainVC:nav];
    }
    
    

}

#pragma mark - -----FoldHeader Delegate-----
- (void)foldHeaderInSection:(NSInteger)SectionHeader {
    NSString *key = [NSString stringWithFormat:@"%d",(int)SectionHeader];
    BOOL folded = [[foldInfoDic objectForKey:key] boolValue];
    NSString *fold = folded ? @"0" : @"1";
    [foldInfoDic setValue:fold forKey:key];
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndex:SectionHeader];
    [menuTable reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - CommunicatorProtocolDelegate
- (void)handleError:(NSDictionary *)jsonObject {
    
}

- (void)handleResponse:(NSDictionary *)jsonObject {
    [self.communicator stopIndicator];
//    NSLog(@"jsonObject:%@", jsonObject);
    topInfoDic = jsonObject;

    [self refreshUI];
}

- (void)refreshUI {
    goldPriceLab.text = topInfoDic[@"gold_price"];
    stockCodeLab.text = topInfoDic[@"stock_code"];
}

@end
