//
//  CTFMunuHead.m
//  CTF-VIP-iOS
//
//  Created by Beeba on 2019/7/12.
//  Copyright © 2019年 ctf. All rights reserved.
//

#import "CTFMenuHead.h"
#import "CTFDefine.h"

@implementation CTFMenuHead
{
    BOOL _created;/**< 是否创建过 */
    UILabel *_titleLabel;/**< 标题 */
    UILabel *_detailLabel;/**< 其他内容 */
    UIImageView *_imageView;/**< 图标 */
    UIButton *_btn;/**< 收起按钮 */
    BOOL _canFold;/**< 是否可展开 */
    
}

- (void)setFoldSectionHeaderViewWithTitle:(NSString *)title detail:(NSString *)detail type:(HerderStyle)type section:(NSInteger)section canFold:(BOOL)canFold {
    if (!_created) {
        [self creatUI];
    }
    _titleLabel.text = title;
    if (type == HerderStyleNone) {
        _detailLabel.hidden = YES;
    } else {
        _detailLabel.hidden = NO;
        _detailLabel.attributedText = [self attributeStringWith:detail];
    }
    _section = section;
    _canFold = canFold;
    if (canFold) {
        _imageView.hidden = NO;
    } else {
        _imageView.hidden = YES;
    }
}

- (NSMutableAttributedString *)attributeStringWith:(NSString *)money {
    NSString *str = [NSString stringWithFormat:@"应收合计:%@", money];
    NSMutableAttributedString *ats = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:money];
    [ats setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:range];
    return ats;
}

- (void)creatUI {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _created = YES;
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 30)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_titleLabel];
    
    //其他内容
//    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 5, 320-40, 30)];
//    _detailLabel.backgroundColor = [UIColor greenColor];
//    [self.contentView addSubview:_detailLabel];
    
    //按钮
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(0, 0, 320, 30);
    [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_btn];
    
    //图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN.width * 0.8 - 30, 15, 13, 7)];
    _imageView.image = [UIImage imageNamed:@"arrow_down_gray"];
    [self.contentView addSubview:_imageView];
    
//    //线
//    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
//    line.image = [UIImage imageNamed:@"line"];
//    [self.contentView addSubview:line];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, 320, 1)];
    line.backgroundColor = [UIColor brownColor];
    [self.contentView addSubview:line];
    
}

- (void)setFold:(BOOL)fold {
    _fold = fold;
    if (fold) {
        _imageView.image = [UIImage imageNamed:@"arrow_down_gray"];
    } else {
        _imageView.image = [UIImage imageNamed:@"arrow_up_gray"];
    }
}

#pragma mark = 按钮点击事件
- (void)btnClick:(UIButton *)btn {
    if (_canFold) {
        if ([self.delegate respondsToSelector:@selector(foldHeaderInSection:)]) {
            [self.delegate foldHeaderInSection:_section];
        }
    }
}

@end
