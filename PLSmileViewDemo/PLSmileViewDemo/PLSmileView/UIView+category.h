//
//  UIView+category.h
//  PLSmileView
//
//  Created by lpn on 2017/7/28.
//  Copyright © 2017年 刘攀妞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (category)

/**
  将一个视图，制作成圆形的分类
 */
+ (void)makeCircleFromView:(UIView *)view storkColor:(UIColor *)storkColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;
@end
