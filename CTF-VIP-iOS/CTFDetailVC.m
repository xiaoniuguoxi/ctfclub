//
//  CTFDetailVC.m
//  CTF-VIP-iOS
//
//  Created by HughChiu on 2019/7/14.
//  Copyright © 2019 ctf. All rights reserved.
//

#import "CTFDetailVC.h"
#import "UIView+Frame.h"
#import "CTFDefine.h"

@interface CTFDetailVC ()
{
    UIScrollView *mainSV;
    
    NSString *ROUTECategory;
    NSString *ROUTEContent;
    NSString *topTitleText;
    NSString *topSubText;
    NSString *topImgName;
    
    NSString *categoriesKey;
    NSString *categoryIdKey;
    NSString *categoryNameKey;
    NSString *contentKey;
    NSString *contentIdKey;
    NSString *paramIdKey;
}
@end

@implementation CTFDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.communicator = [CommunicationProtocol new];
    self.communicator.delegate = self;
    
    if (self.requestType == 0) {
//        ROUTECategory = ROUTE_GET_NEWS_CATEGORY;
//        ROUTEContent = ROUTE_GET_NEWSES;
//        paramIdKey = CATEGORY_ID;
        categoriesKey = @"news_categories";
        categoryIdKey = @"news_category_id";
        categoryNameKey = @"name";
        contentKey = @"newses";
        contentIdKey = @"newses_id";
        
        topTitleText = @"消息及推广";
        topSubText = @"想知道周大福会员计划的最新资讯？请选择以下其中一项讯息了解更多。";
        topImgName = @"ctf_background_promotion.jpg";
        
    }else if (self.requestType == 2) {
//        ROUTECategory = ROUTE_GET_EVENT_CATEGORY;
//        ROUTEContent = ROUTE_GET_EVENTS;
//        paramIdKey = CATEGORY_ID;
        categoriesKey = @"events_categories";
        categoryIdKey = @"events_category_id";
        categoryNameKey = @"name";
        contentKey = @"eventes";
        contentIdKey = @"events_id";
        
        topTitleText = @"精彩活动";
        topSubText = @"周大福会员计划有什么新鲜事？点击新闻报道了解。";
        topImgName = @"ctf_background_event.jpg";
        
    }else if (self.requestType == 3) {
//        ROUTECategory = ROUTE_GET_INFORMATION_CATEGORY;
//        ROUTEContent = ROUTE_GET_INFORMATION;
//        paramIdKey = INFORMATION_ID;
        categoriesKey = @"";
        categoryIdKey = @"infor_category_id";
        categoryNameKey = @"name";
        contentKey = @"eventes";
        contentIdKey = @"events_id";
        
        topTitleText = @"关于周大福会员计划";
        topSubText = @"";
        topImgName = @"ctf_background_about_ctf_club.jpg";
        
    }else if (self.requestType == 1) {
//        ROUTECategory = ROUTE_GET_BIRTHDAY_OFFERS_CATEGORY;
//        ROUTEContent = ROUTE_GET_BIRTHDAY_OFFERS;
//        paramIdKey = MEMBER_LEVEL_ID;
//        categoriesKey = MEMBER_LEVEL;
        categoryIdKey = @"member_level_id";
        categoryNameKey = @"title";
        contentKey = @"birthdayes";
        contentIdKey = @"gift_id";
        
        
        topTitleText = @"生日礼遇";
        topSubText = @"";
        topImgName = @"ctf_background_birthday.jpg";
    }
    
    mainSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.width, SCREEN.height - 64 - kApplicationStatusBarHeight)];
    [self.view addSubview:mainSV];
    
    UIImageView *topIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.width, 210)];
    topIV.contentMode = UIViewContentModeScaleAspectFit;
    topIV.image = [UIImage imageNamed:topImgName];
    [mainSV addSubview:topIV];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    titleLab.center = CGPointMake(topIV.width / 2, topIV.height - 30);
    titleLab.text = topTitleText;
    titleLab.font = [UIFont systemFontOfSize:30];
    titleLab.textColor = [UIColor purpleColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [topIV addSubview:titleLab];
    
    UILabel *subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, topIV.maxY, SCREEN.width, 60)];
    subTitleLab.text = topSubText;
    subTitleLab.numberOfLines = 0;
    subTitleLab.font = [UIFont systemFontOfSize:15];
    subTitleLab.textColor = UIColorFromRGBandAlpha(0x333333, 1.0);
    subTitleLab.textAlignment = NSTextAlignmentCenter;
    [mainSV addSubview:subTitleLab];
}




#pragma mark - CommunicatorProtocolDelegate
- (void)handleError:(NSDictionary *)jsonObject {
    NSLog(@"handleError jsonObject:%@", jsonObject);
    
}

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [self.communicator stopIndicator];
    NSLog(@"jsonObject:%@", jsonObject);
}



@end
