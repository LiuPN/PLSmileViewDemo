//
//  UIView+category.m
//  PLSmileView
//
//  Created by lpn on 2017/7/28.
//  Copyright © 2017年 刘攀妞. All rights reserved.
//

#import "UIView+category.h"
#import "UIView+Frame.h"
#define padding 1 // 向内缩小的距离

@implementation UIView (category)

/**
 将一个视图，制作成圆形的分类
 */
+ (void)makeCircleFromView:(UIView *)view storkColor:(UIColor *)storkColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius
{
    // 相对于view画圆
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(padding, padding, view.width- 2*padding, view.height-2 * padding) cornerRadius:cornerRadius-padding];
    
    // 中间
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    
    
    // 边框
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = maskLayer.frame;
    borderLayer.lineWidth = borderWidth;
    borderLayer.strokeColor = storkColor.CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;// 显示图片内容
    borderLayer.path = path.CGPath;
    
    [view.layer insertSublayer:borderLayer atIndex:0];
    view.layer.mask = maskLayer;
    
}













































@end
