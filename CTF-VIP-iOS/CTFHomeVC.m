//
//  CTFHomeVC.m
//  CTF-VIP-iOS
//
//  Created by Beeba on 2019/7/11.
//  Copyright © 2019年 ctf. All rights reserved.
//

#import "CTFHomeVC.h"
#import "UIView+Frame.h"
#import "CTFDefine.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CTFHomeVC ()
{
    NSArray *infomationArray;
    NSArray *newsArray;
    NSArray *bannersArray;
    
    UIScrollView *mainSV;
    UIScrollView *bannerSV;
    NSMutableArray *bannerIVArray;
    
    UIScrollView *newsSV;
    NSMutableArray *newsIVArray;
    NSMutableArray *newsLabArray;
    
    NSMutableArray *infoIVArray;
    NSMutableArray *infoTitleLabArray;
    NSMutableArray *infoSubTitleLabArray;
    NSMutableArray *infoMoreBtnArray;
}
@end

@implementation CTFHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.communicator = [CommunicationProtocol new];
    self.communicator.delegate = self;
    
    [self reloadHomePage];
}

- (void)refreshUI {
    if (mainSV == nil) {
        mainSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.width, SCREEN.height - 64 - kApplicationStatusBarHeight)];
        [self.view addSubview:mainSV];
    }
    if (bannerSV == nil) {
        bannerSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.width, 200)];
        bannerSV.pagingEnabled = YES;
        [mainSV addSubview:bannerSV];
    }
    if (bannerIVArray == nil) {
        bannerIVArray = [[NSMutableArray alloc] init];
    }
    for (UIImageView *aIV in bannerIVArray) {
        [aIV removeFromSuperview];
    }
    [bannerIVArray removeAllObjects];
    
    for (int i = 0; i < bannersArray.count; i++) {
        UIImageView *bannerIV = [[UIImageView alloc] initWithFrame:CGRectMake(bannerSV.width * i, 0, SCREEN.width, bannerSV.height)];
        bannerIV.contentMode = UIViewContentModeScaleAspectFill;
        bannerIV.clipsToBounds = YES;
        NSDictionary *dic = bannersArray[i];
        NSString *image = [dic valueForKey:@"image"];
        NSURL *url = [NSURL URLWithString:image];
        [bannerIV sd_setImageWithURL:url];
        [bannerSV addSubview:bannerIV];
        
        [bannerIVArray addObject:bannerIV];
    }
    [bannerSV setContentSize:CGSizeMake(bannerSV.width * bannerIVArray.count, bannerSV.height)];
    
    UILabel *newsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    newsTitle.center = CGPointMake(SCREEN.width / 2, bannerSV.maxY + 28);
    newsTitle.text = @"最新消息";
    newsTitle.font = [UIFont systemFontOfSize:20];
    newsTitle.textColor = [UIColor purpleColor];
    newsTitle.textAlignment = NSTextAlignmentCenter;
    [mainSV addSubview:newsTitle];
    
    if (newsSV == nil) {
        newsSV = [[UIScrollView alloc] initWithFrame:CGRectMake(10, newsTitle.maxY + 8, SCREEN.width - 20, 210)];
        newsSV.pagingEnabled = YES;
        [mainSV addSubview:newsSV];
    }
    if (newsIVArray == nil) {
        newsIVArray = [[NSMutableArray alloc] init];
    }
    if (newsLabArray == nil) {
        newsLabArray = [[NSMutableArray alloc] init];
    }
    for (UIImageView *aIV in newsIVArray) {
        [aIV removeFromSuperview];
    }
    for (UILabel *aLab in newsLabArray) {
        [aLab removeFromSuperview];
    }
    [newsIVArray removeAllObjects];
    [newsLabArray removeAllObjects];
    
    for (int i = 0; i < newsArray.count; i++) {
        UIImageView *newsIV = [[UIImageView alloc] initWithFrame:CGRectMake(160 * i, 0, 150, 150)];
        newsIV.contentMode = UIViewContentModeScaleAspectFill;
        newsIV.clipsToBounds = YES;
        NSDictionary *dic = newsArray[i];
        NSString *image = [dic valueForKey:@"image"];
        NSURL *url = [NSURL URLWithString:image];
        [newsIV sd_setImageWithURL:url];
        [newsSV addSubview:newsIV];
        
        [newsIVArray addObject:newsIV];
        
        UILabel *newSubTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(160 * i, newsIV.maxY, newsIV.width, 60)];
        newSubTitleLab.text = [dic valueForKey:@"title"];
        newSubTitleLab.numberOfLines = 0;
        newSubTitleLab.textColor = [UIColor blackColor];
        newSubTitleLab.font = [UIFont systemFontOfSize:13];
        [newsSV addSubview:newSubTitleLab];
        
        [newsLabArray addObject:newSubTitleLab];
    }
    [newsSV setContentSize:CGSizeMake(160 * newsArray.count, newsSV.height)];
    
    
    if (infoIVArray == nil) {
        infoIVArray = [[NSMutableArray alloc] init];
    }
    if (infoTitleLabArray == nil) {
        infoTitleLabArray = [[NSMutableArray alloc] init];
    }
    if (infoSubTitleLabArray == nil) {
        infoSubTitleLabArray = [[NSMutableArray alloc] init];
    }
    if (infoMoreBtnArray == nil) {
        infoMoreBtnArray = [[NSMutableArray alloc] init];
    }
    for (UIImageView *aIV in infoIVArray) {
        [aIV removeFromSuperview];
    }
    for (UILabel *aLab in infoTitleLabArray) {
        [aLab removeFromSuperview];
    }
    for (UILabel *aLab in infoSubTitleLabArray) {
        [aLab removeFromSuperview];
    }
    for (UIButton *aBtn in infoMoreBtnArray) {
        [aBtn removeFromSuperview];
    }
    [infoIVArray removeAllObjects];
    [infoTitleLabArray removeAllObjects];
    [infoSubTitleLabArray removeAllObjects];
    [infoMoreBtnArray removeAllObjects];
    
    for (int i = 0; i < infomationArray.count; i++) {
        UIImageView *infoIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, newsSV.maxY + 50 + 470 * i, SCREEN.width, 200)];
        infoIV.contentMode = UIViewContentModeScaleAspectFill;
        infoIV.clipsToBounds = YES;
        NSDictionary *dic = infomationArray[i];
        NSString *image = [dic valueForKey:@"image"];
        NSURL *url = [NSURL URLWithString:image];
        [infoIV sd_setImageWithURL:url];
        [mainSV addSubview:infoIV];
        
        [infoIVArray addObject:infoIV];
        
        UILabel *infoTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, infoIV.maxY + 50, 200, 40)];
        infoTitleLab.text = [dic valueForKey:@"title"];
        infoTitleLab.numberOfLines = 0;
        infoTitleLab.textColor = [UIColor purpleColor];
        infoTitleLab.font = [UIFont systemFontOfSize:20];
        [mainSV addSubview:infoTitleLab];
        
        [infoTitleLabArray addObject:infoTitleLab];
        
        UILabel *infoSubTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, infoTitleLab.maxY + 20, SCREEN.width - 40, 60)];
        infoSubTitleLab.text = [dic valueForKey:@"description"];
        infoSubTitleLab.numberOfLines = 0;
        infoSubTitleLab.textColor = [UIColor blackColor];
        infoSubTitleLab.font = [UIFont systemFontOfSize:13];
        [mainSV addSubview:infoSubTitleLab];
        
        [infoSubTitleLabArray addObject:infoSubTitleLab];
        
        UIButton *infoMoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, infoSubTitleLab.maxY + 20, 200, 60)];
        [infoMoreBtn setBackgroundImage:[UIImage imageNamed:@"ctf_home_btn_more1"] forState:UIControlStateNormal];
        [infoMoreBtn setTitle:@"更多" forState:UIControlStateNormal];
        infoMoreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [infoMoreBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [mainSV addSubview:infoMoreBtn];
        
        [infoMoreBtnArray addObject:infoMoreBtn];
    }
    
    [mainSV setContentSize:CGSizeMake(mainSV.width, newsSV.maxY + 50 + 470 * infomationArray.count)];
}

- (void)reloadHomePage
{
    // Prepare API request
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_GET_HOME_PAGE] parameters:nil tag:ROUTE_GET_HOME_PAGE];
}

#pragma mark - CommunicatorProtocolDelegate
- (void)handleError:(NSDictionary *)jsonObject {
    
}

- (void)handleResponse:(NSDictionary *)jsonObject {
    [self.communicator stopIndicator];
    NSLog(@"jsonObject:%@", jsonObject);
    
    infomationArray = jsonObject[@"information"];
    newsArray = jsonObject[@"newses"];
    bannersArray = jsonObject[@"banners"];
    
    [self refreshUI];
}

@end
