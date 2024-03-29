//
//  UIView+Frame.m
//  CTF-VIP-iOS
//
//  Created by HughChiu on 2019/7/11.
//  Copyright © 2019 ctf. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
/**
 *  获得当前屏幕的宽度
 */
+ (CGFloat)screenWidth {
    
    return [UIScreen mainScreen].bounds.size.width;
}
/**
 *  获得当前屏幕的高度
 */
+ (CGFloat)screenHeight {
    
    return [UIScreen mainScreen].bounds.size.height;
}

/**
 *  设置x坐标
 */
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

/**
 *  获取x坐标
 */
- (CGFloat)x
{
    return self.frame.origin.x;
}

/**
 *  设置y坐标
 */
- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

/**
 *  获取y坐标
 */
- (CGFloat)y
{
    return self.frame.origin.y;
}

/**
 *  设置width
 */
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

/**
 *  获取width
 */
- (CGFloat)width
{
    return self.frame.size.width;
}

/**
 *  设置height
 */
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

/**
 *  获取height
 */
- (CGFloat)height
{
    return self.frame.size.height;
}

/**
 *  增加height
 */
- (void)increaseHeight:(CGFloat)height {
    [self setHeight:self.height + height];
}

/**
 *  减少height
 */
- (void)cutHeight:(CGFloat)height {
    [self setHeight:self.height - height];
}

/**
 *  增加width
 */
- (void)increaseWidth:(CGFloat)width {
    [self setWidth:self.width + width];
}

/**
 *  减少width
 */
- (void)cutWidth:(CGFloat)width {
    [self setWidth:self.width - width];
}

/**
 *  设置size
 */
- (void)setSize:(CGSize)size
{
    [self setWidth:size.width];
    [self setHeight:size.height];
}

/**
 *  获取size
 */
- (CGSize)size
{
    return self.frame.size;
}

/**
 *  设置origin
 */
- (void)setOrigin:(CGPoint)origin
{
    [self setX:origin.x];
    [self setY:origin.y];
}

/**
 *  获取origin
 */
- (CGPoint)origin
{
    return self.frame.origin;
}

/**
 *  获取最大的x
 *
 */
- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

/**
 *  获取最大的y
 *
 */
- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}
/**
 *  获取最小的x
 */
- (CGFloat)minX {
    
    return CGRectGetMinX(self.frame);
}
/**
 *  获取最小的y
 */
- (CGFloat)minY {
    
    return CGRectGetMinY(self.frame);
}
/**
 *  获取中间x值
 */
- (CGFloat)midX {
    
    return CGRectGetMidX(self.frame);
}
/**
 *  获取中间y值
 */
- (CGFloat)midY {
    
    return CGRectGetMidY(self.frame);
}
@end
