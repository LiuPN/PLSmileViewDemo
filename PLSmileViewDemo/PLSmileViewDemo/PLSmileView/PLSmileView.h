//
//  PLSmileView.h
//  PLSmileView
//
//  Created by lpn on 2017/7/28.
//  Copyright © 2017年 刘攀妞. All rights reserved.
//  "评价 笑脸自定义视图"

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PLSmileViewDislikeType,  // 不喜欢类型
    PLSmileViewLikeType,     // 喜欢类型
} PLSmileViewType;

@class PLSmileView;
@protocol PLSmileViewDelegate <NSObject>

/// 告诉PLBackView 没选中的view也要down了
@required
- (void)downViewSmileView:(PLSmileView *)smileView;
// 告诉PLBackView 出现星星的时间到了duration 动画时长
- (void)smileView:(PLSmileView *)smileView appearStarWithDuration:(CGFloat)duration currentRect:(CGRect)rect;

@end

@interface PLSmileView : UIView
/**
  传入likeScale代表喜欢的百分数占比
 */
+ (instancetype)smileView;

@property(nonatomic, strong) NSString *imageName;

// 最开始的高度 不喜欢的 == 喜欢的
@property(nonatomic, assign) CGFloat originalH;

// 最开始的Y值 不喜欢的 == 喜欢的
@property(nonatomic, assign) CGFloat originalY;
// 类型
@property(nonatomic, assign) PLSmileViewType type;

// 在scale不断变化过程中  对于本self最大的比例值 规定值（为了上升到最高点  做动画）
@property(nonatomic, assign) CGFloat maxScaleValue;

// 不断改变的scale
@property(nonatomic, assign) CGFloat scale;

// 当前self的fill颜色 白色  与 黄色
@property(nonatomic, assign, getter=isFillYellowColor) BOOL fillYellowColor;


@property(nonatomic, assign) id<PLSmileViewDelegate> downDelegate;
@end
