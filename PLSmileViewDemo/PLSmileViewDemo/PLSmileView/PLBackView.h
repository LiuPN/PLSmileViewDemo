//
//  PLBackView.h
//  PLSmileView
//
//  Created by liupanniu on 2017/8/2.
//  Copyright © 2017年 刘攀妞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLBackView : UIView
+ (instancetype)backViewWithDislikeCount:(NSUInteger)disLikeCount likeCount: (NSUInteger)likeCount;

@property(nonatomic, assign) CGRect disLikeFrame; // “不喜欢”的frame
@property(nonatomic, assign) CGRect likeFrame; // “喜欢”的frame

@end
