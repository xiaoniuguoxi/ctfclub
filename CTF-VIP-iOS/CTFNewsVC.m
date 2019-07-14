//
//  CTFNewsVC.m
//  CTF-VIP-iOS
//
//  Created by Beeba on 2019/7/13.
//  Copyright © 2019年 ctf. All rights reserved.
//

#import "CTFNewsVC.h"
#import "CTFDefine.h"
#import "UIView+Frame.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CTFDetailVC.h"

@interface CTFNewsVC () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIScrollViewDelegate>
{
    UIScrollView *mainSV;
    UIWebView *webV;
    NSString *webUrl;
    UILabel *newTypeLab;
    
    NSArray *newsesArray;
    NSArray *newsCategoriesArray;
    
    NSMutableArray *newsIVArray;
    NSMutableArray *newsTitleLabArray;
    NSMutableArray *newsMoreBtnArray;
    
    UITableView *typesTable;
    
    int categoryID;
    
    
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

@implementation CTFNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.requestType == 0) {
        ROUTECategory = ROUTE_GET_NEWS_CATEGORY;
        ROUTEContent = ROUTE_GET_NEWSES;
        paramIdKey = CATEGORY_ID;
        categoriesKey = @"news_categories";
        categoryIdKey = @"news_category_id";
        categoryNameKey = @"name";
        contentKey = @"newses";
        contentIdKey = @"newses_id";
        
        topTitleText = @"消息及推广";
        topSubText = @"想知道周大福会员计划的最新资讯？请选择以下其中一项讯息了解更多。";
        topImgName = @"ctf_background_promotion.jpg";
        
    }else if (self.requestType == 2) {
        ROUTECategory = ROUTE_GET_EVENT_CATEGORY;
        ROUTEContent = ROUTE_GET_EVENTS;
        paramIdKey = CATEGORY_ID;
        categoriesKey = @"events_categories";
        categoryIdKey = @"events_category_id";
        categoryNameKey = @"name";
        contentKey = @"eventes";
        contentIdKey = @"events_id";
        
        topTitleText = @"精彩活动";
        topSubText = @"周大福会员计划有什么新鲜事？点击新闻报道了解。";
        topImgName = @"ctf_background_event.jpg";
        
    }else if (self.requestType == 3) {
        ROUTECategory = ROUTE_GET_INFORMATION_CATEGORY;
        ROUTEContent = ROUTE_GET_INFORMATION;
        paramIdKey = INFORMATION_ID;
        categoriesKey = @"";
        categoryIdKey = @"infor_category_id";
        categoryNameKey = @"name";
        contentKey = @"eventes";
        contentIdKey = @"events_id";
        
        topTitleText = @"关于周大福会员计划";
        topSubText = @"";
        topImgName = @"ctf_background_about_ctf_club.jpg";
        
    }else if (self.requestType == 1) {
        ROUTECategory = ROUTE_GET_BIRTHDAY_OFFERS_CATEGORY;
        ROUTEContent = ROUTE_GET_BIRTHDAY_OFFERS;
        paramIdKey = MEMBER_LEVEL_ID;
        categoriesKey = MEMBER_LEVEL;
        categoryIdKey = @"member_level_id";
        categoryNameKey = @"title";
        contentKey = @"birthdayes";
        contentIdKey = @"gift_id";
        
        
        topTitleText = @"生日礼遇";
        topSubText = @"";
        topImgName = @"ctf_background_birthday.jpg";
    }
    
    self.communicator = [CommunicationProtocol new];
    self.communicator.delegate = self;
    
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
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(20, subTitleLab.maxY, SCREEN.width - 40, 40)];
    btnView.backgroundColor = [UIColor purpleColor];
    [mainSV addSubview:btnView];
    
    UIButton *typeBtn = [[UIButton alloc] initWithFrame:CGRectMake(1, 1, btnView.width - 2, btnView.height - 2)];
    typeBtn.backgroundColor = [UIColor whiteColor];
    [typeBtn addTarget:self action:@selector(selectTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:typeBtn];
    
    newTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, btnView.height)];
    newTypeLab.backgroundColor = [UIColor clearColor];
    newTypeLab.textColor = [UIColor purpleColor];
    newTypeLab.font = [UIFont systemFontOfSize:15];
    newTypeLab.text = @"";
    [btnView addSubview:newTypeLab];
    
    typesTable = [[UITableView alloc] initWithFrame:CGRectMake(btnView.minX + 2, btnView.maxY, btnView.width - 4, 150)];
    typesTable.backgroundColor = UIColorFromRGBandAlpha(0xad8587, 1.0);
    typesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    typesTable.delegate = self;
    typesTable.dataSource = self;
    typesTable.hidden = YES;
    [mainSV addSubview:typesTable];
    
    
    
    [self reloadCategories];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    typesTable.hidden = YES;
    mainSV.scrollEnabled = YES;
}

- (void)selectTypeAction:(UIButton *)sender {
    typesTable.hidden = NO;
    mainSV.scrollEnabled = NO;
    [mainSV bringSubviewToFront:typesTable];
}

- (void)refreshNewsUI {
    if (webUrl.length > 0) {
        if (webV == nil) {
            webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, typesTable.minY + 20, SCREEN.width, 200)];
            webV.scrollView.scrollEnabled = NO;
            //这个属性不加,webview会显示很大.
//            webV.scalesPageToFit = YES;
//            webV.opaque = NO;
            [mainSV addSubview:webV];
            
            [webV.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        }
        webV.hidden = NO;
        NSURL *url = [NSURL URLWithString:webUrl];
        NSURLRequest *webRequest = [[NSURLRequest alloc] initWithURL:url];
        [webV loadRequest:webRequest];
    }else {
        webV.hidden = YES;
    }
    
    if (newsIVArray == nil) {
        newsIVArray = [[NSMutableArray alloc] init];
    }
    if (newsTitleLabArray == nil) {
        newsTitleLabArray = [[NSMutableArray alloc] init];
    }

    if (newsMoreBtnArray == nil) {
        newsMoreBtnArray = [[NSMutableArray alloc] init];
    }
    for (UIImageView *aIV in newsIVArray) {
        [aIV removeFromSuperview];
    }
    for (UILabel *aLab in newsTitleLabArray) {
        [aLab removeFromSuperview];
    }

    for (UIButton *aBtn in newsMoreBtnArray) {
        [aBtn removeFromSuperview];
    }
    [newsIVArray removeAllObjects];
    [newsTitleLabArray removeAllObjects];
    [newsMoreBtnArray removeAllObjects];
    
    for (int i = 0; i < newsesArray.count; i++) {
        UIImageView *infoIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 300 + 50 + 650 * i, SCREEN.width, 400)];
        infoIV.userInteractionEnabled = YES;
        infoIV.contentMode = UIViewContentModeScaleAspectFill;
        infoIV.clipsToBounds = YES;
        NSDictionary *dic = newsesArray[i];
        NSString *image = [dic valueForKey:@"image"];
        NSString *encodeUrl = [image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:encodeUrl];
        [infoIV sd_setImageWithURL:url];
//        UITapGestureRecognizer *signalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnRecommend:)];
//        [infoIV addGestureRecognizer:signalTap];
        [mainSV addSubview:infoIV];
        
        [newsIVArray addObject:infoIV];
        
        UIButton *infoIVBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, infoIV.width, infoIV.height)];
        infoIVBtn.tag = i;
        [infoIVBtn addTarget:self action:@selector(imageClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [infoIV addSubview:infoIVBtn];
        
        UILabel *infoTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, infoIV.maxY + 50, 300, 60)];
        infoTitleLab.text = [dic valueForKey:@"title"];
        infoTitleLab.numberOfLines = 0;
        infoTitleLab.textColor = [UIColor blackColor];
        infoTitleLab.font = [UIFont systemFontOfSize:20];
        [mainSV addSubview:infoTitleLab];
        
        [newsTitleLabArray addObject:infoTitleLab];
        
        UIButton *infoMoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, infoTitleLab.maxY + 20, 60, 20)];
        [infoMoreBtn setTitle:@"更多>" forState:UIControlStateNormal];
        infoMoreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [infoMoreBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [mainSV addSubview:infoMoreBtn];
        
        [newsMoreBtnArray addObject:infoMoreBtn];
    }
    
    [mainSV setContentSize:CGSizeMake(mainSV.width, 300 + 50 + 450 * newsesArray.count)];
}

- (void)imageClickAction:(UIButton *)sender {
    NSDictionary *dic = newsesArray[sender.tag];
    CTFDetailVC *detailVC = [[CTFDetailVC alloc] init];
    detailVC.requestType = self.requestType;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//- (void)handleTapOnRecommend:(UIGestureRecognizer*)ges {
//
//}

- (void)reloadCategories
{
    // Prepare API request
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTECategory] parameters:nil tag:ROUTECategory];
    
    if (self.requestType == 3) {
        NSDictionary *dic1 = @{
                               @"name": @"关于我们",
                               categoryIdKey: @INTRODUCTION_INFORMATION_ID
                               };
        NSDictionary *dic2 = @{
                               @"name": @"成为会员",
                               categoryIdKey: @INTRODUCTION_INFORMATION_ID
                               };
        newsCategoriesArray = [NSArray arrayWithObjects:dic1, dic2, nil];
        newTypeLab.text = @"关于我们";
        categoryID = INTRODUCTION_INFORMATION_ID;
        webUrl = @"https://club.samprasdev.com/about-ctf-club?mobile=1&language=zh-CN";
        [self refreshNewsUI];
//        [self loadItemsInCategoryId:categoryID atPage:0];
    }
}

- (void)loadItemsInCategoryId:(int)categoryId atPage:(int)page
{
    // Prepare API request
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:[@(categoryId) stringValue] forKey:paramIdKey];
    [parameters setValue:@"10" forKey:LIMIT];
    [parameters setValue:[@(page) stringValue] forKey:PAGE];
    
    [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTEContent] parameters:parameters tag:ROUTEContent];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"observeValueForKeyPath");
    NSLog(@"keyPath:%@", keyPath);
    if ([keyPath isEqualToString:@"contentSize"]) {
        NSLog(@"contentSize");
        CGRect frame = webV.frame;
        //通过webview的contentSize获取内容高度
        frame.size.height = webV.scrollView.contentSize.height;
        
        webV.frame = frame;
        
        [mainSV setContentSize:CGSizeMake(mainSV.width, webV.maxY + 10)];
    }
}

#pragma mark - CommunicatorProtocolDelegate
- (void)handleError:(NSDictionary *)jsonObject {
    NSLog(@"handleError jsonObject:%@", jsonObject);
    
}

- (void)handleResponse:(NSDictionary *)jsonObject
{
    [self.communicator stopIndicator];
    NSLog(@"jsonObject:%@", jsonObject);
    
    NSString *tag = jsonObject[TAG];
    
    if ([tag isEqualToString:ROUTECategory]) {
        // Category list
        newsCategoriesArray = jsonObject[categoriesKey];
        if (newsCategoriesArray.count > 0) {
            NSDictionary *dic = newsCategoriesArray[0];
            newTypeLab.text = dic[categoryNameKey];
            categoryID = [dic[categoryIdKey] intValue];
        }
        [typesTable reloadData];
        [self loadItemsInCategoryId:categoryID atPage:0];
        
    }else if ([tag isEqualToString:ROUTEContent]) {
        
        newsesArray = jsonObject[contentKey];
        
        [self refreshNewsUI];
    }
}

#pragma mark - -----UITableView Delegate-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return newsCategoriesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.contentView.backgroundColor = UIColorFromRGBandAlpha(0xad8587, 1.0);
    NSDictionary *dic = newsCategoriesArray[indexPath.row];
    cell.textLabel.text = dic[categoryNameKey];
    cell.textLabel.textColor = UIColorFromRGBandAlpha(0xf5f0ea, 1.0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    typesTable.hidden = YES;
    mainSV.scrollEnabled = YES;
    
    NSDictionary *dic = newsCategoriesArray[indexPath.row];
    newTypeLab.text = dic[categoryNameKey];
    categoryID = [dic[categoryIdKey] intValue];
    
    if (self.requestType == 0) {
        if (categoryID == 0) {
            newsesArray = nil;
            webUrl = @"https://club.samprasdev.com/newsletter&language=zh-CN&mobile=1";
            [self refreshNewsUI];
        }else {
            webUrl = @"";
            [self loadItemsInCategoryId:categoryID atPage:0];
        }
    }else if (self.requestType == 3) {
        if (indexPath.row == 0) {
            webUrl = @"https://club.samprasdev.com/about-ctf-club?mobile=1&language=zh-CN";
        }else if (indexPath.row == 1) {
            webUrl = @"https://club.samprasdev.com/index.php?route=information/information&information_id=21&mobile=1&language=zh-CN";
        }
        [self refreshNewsUI];
    }else {
        webUrl = @"";
        [self loadItemsInCategoryId:categoryID atPage:0];
    }
    
    
}


@end
