//
//  PLBackView.m
//  PLSmileView
//
//  Created by liupanniu on 2017/8/2.
//  Copyright © 2017年 刘攀妞. All rights reserved.
//

#import "PLBackView.h"
#import "PLSmileView.h"
#import "UIView+Frame.h"

#define MAXHEIGHT 100  // 比例是100%的最大高度
// 星星对角线的长度
#define starWidth 10
#define starHeight 20


@interface PLBackView ()<PLSmileViewDelegate>
// 不喜欢的人数  喜欢的人数--记录最初值
@property(nonatomic, assign) NSUInteger disLikeCount;
@property(nonatomic, assign) NSUInteger likeCount;

// 点击之后  是否加1的个数变量--记录点击加1之后的值  用于计算新的占比
@property(nonatomic, assign) NSUInteger disLikeCountMut;
@property(nonatomic, assign) NSUInteger likeCountMut;

// 不喜欢笑脸dislikeIV 喜欢笑脸likeIV
@property(nonatomic, weak) PLSmileView *dislikeIV;
@property(nonatomic, weak) PLSmileView *likeIV;

// 占得总比例
@property(nonatomic, assign) CGFloat disLikeScale;
@property(nonatomic, assign) CGFloat likeScale;

// 每次升高下降的幅度 占比高的幅度大  占比低的幅度小  动画时间是一样的
@property(nonatomic, assign) CGFloat addOffsetMax;
@property(nonatomic, assign) CGFloat addOffsetMin;

// 画星星的标识 传来之后drawRect用
@property(nonatomic, assign) BOOL appearStar;
// 显示星星的时候“喜欢”当前的frame
@property(nonatomic, assign) CGRect currentFrame;

// 记录星星在变化时候的对角线宽高
@property(nonatomic, assign) CGFloat starW;
@property(nonatomic, assign) CGFloat starH;

// 笑脸上方文字的透明度
@property(nonatomic, assign) CGFloat fontAlpha;

// 上升 \ 下降 的总次数
@property(nonatomic, assign) NSUInteger count;

// 动画进行中不可再点击的标记
@property(nonatomic, assign) BOOL clickEnable;

@end

@implementation PLBackView

+ (instancetype)backViewWithDislikeCount:(NSUInteger)disLikeCount likeCount:(NSUInteger)likeCount
{
    
    PLBackView *bv = [[[NSBundle mainBundle] loadNibNamed:@"PLBackView" owner:nil options:nil] lastObject];
    bv.disLikeCount = disLikeCount;
    bv.likeCount = likeCount;
    bv.clickEnable = YES;
    
    return bv;
}

/// 设置“不喜欢”的frame
- (void)setDisLikeFrame:(CGRect)disLikeFrame
{
    _disLikeFrame = disLikeFrame;
    
    PLSmileView *dislikeIV = [PLSmileView smileView];
    UIImage *image = [UIImage imageNamed:@"dislike_1"];
    dislikeIV.frame = disLikeFrame;
    dislikeIV.width = image.size.width + 5;
    dislikeIV.height = image.size.height + 5;
    
    _disLikeFrame = dislikeIV.frame; // 为了喜欢的frame设置
    
    dislikeIV.imageName = @"dislike_normal";
    dislikeIV.downDelegate = self;
    
    _dislikeIV = dislikeIV;
    dislikeIV.type = PLSmileViewDislikeType;
    [self addSubview:dislikeIV];
    dislikeIV.originalY = dislikeIV.y;
    dislikeIV.originalH = image.size.height +5;
    
    // 注册点击事件
    UIGestureRecognizer *recognizer01 = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(smileViewDidClick:)];
    [dislikeIV addGestureRecognizer:recognizer01];
    
}

/// 设置“喜欢”的frame
- (void)setLikeFrame:(CGRect)likeFrame
{
    _likeFrame = likeFrame;
    PLSmileView *likeIV = [PLSmileView smileView];
    UIImage *image = [UIImage imageNamed:@"dislike_1"];
    likeIV.frame = likeFrame;
    likeIV.width = image.size.width + 5;
    likeIV.height = image.size.height + 5;
    likeIV.imageName = @"like_normal";
    likeIV.downDelegate = self;
    
    _likeIV = likeIV;
    likeIV.type = PLSmileViewLikeType;
    [self addSubview:likeIV];
    likeIV.originalY = likeIV.y;
    likeIV.originalH = image.size.height + 5;
    
    
    // 3 笑脸之间的分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    line.height = image.size.height * 0.5;
    line.width = 2;
    line.centerY = likeIV.centerY;
    line.centerX = CGRectGetMaxX(_disLikeFrame) +(likeIV.x - CGRectGetMaxX(_disLikeFrame)) * 0.5;
    [self addSubview:line];
    
    UIGestureRecognizer *recognizer02 = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(smileViewDidClick:)];
    [likeIV addGestureRecognizer:recognizer02];
    
    
}

/**
  点击笑脸上升动画
 */
- (void)smileViewDidClick:(UIGestureRecognizer *)recognizer
{
    
    if (!self.clickEnable) {
        return;
    }
    
    // 点击之后不能再点击了
    self.clickEnable = NO;
    // 比例清空  从懒加载中  获取最新的比例，防止 来回点击喜欢与不喜欢 视图时候，占比发生相应的变化
    self.disLikeScale = 0.0;
    self.likeScale = 0.0;
    
    // 1、背景变暗
    [UIView animateWithDuration:1.0 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

    }];
    
    // 2、选中颜色变为黄色  没有选中的图片还原
    PLSmileView *smileView = (PLSmileView *)[recognizer view];
    
    smileView.fillYellowColor = YES;
    if (smileView.type == PLSmileViewDislikeType) {
        _likeIV.fillYellowColor = NO;
        // 点击的是“不喜欢”  人数加1
        self.disLikeCountMut = self.disLikeCount+1;
        self.likeCountMut = self.likeCount;
        _dislikeIV.maxScaleValue = self.disLikeScale; // 最大值
        // 另一个图片 还原最初的图片
        _likeIV.imageName = @"like_normal";
        
    }else
    {
        _dislikeIV.fillYellowColor = NO;
        // 点击的是“喜欢”人数加1
        self.likeCountMut = self.likeCount+1;
        self.disLikeCountMut = self.disLikeCount;
        _likeIV.maxScaleValue = self.likeScale; // 最大值
        _dislikeIV.imageName = @"dislike_normal";
    }
    
    
    // 3、找出高低各自对应的幅度值
    CGFloat addOffsetMin = 0.01;
    CGFloat addOffsetMax = 0.0;
    // 循环次数
    NSUInteger count = 0;

    CGFloat minScale = MIN(self.disLikeScale, self.likeScale);
    count = minScale / addOffsetMin;
    addOffsetMax = (1 - minScale) / count;
    self.count = count;
    self.addOffsetMax = addOffsetMax;
    self.addOffsetMin = addOffsetMin;
    // 4、开始上升 传scale
    __block CGFloat disLikeScale0 = 0.0;
    __block CGFloat likeScale0 = 0.0;
    [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if (self.disLikeScale < self.likeScale) {  // 喜欢较高 addOffsetMax属于喜欢
            
            disLikeScale0 += addOffsetMin;
            likeScale0 += addOffsetMax;
        }else{         // 不喜欢较高 addOffsetMax属于不喜欢
            
            disLikeScale0 += addOffsetMax;
            likeScale0 += addOffsetMin;
        }
        
        // 传递比例  不断上升
        _dislikeIV.scale = disLikeScale0;
        _likeIV.scale = likeScale0;
        
        
        // 字体的alpha变化
        self.fontAlpha += (CGFloat)1/count;
        // 不断上升的过程中  比例字数位置 也在不断上升
        [self setNeedsDisplay];
        
        
        // 上升到最高点就停止计时器
        if (disLikeScale0 >= _disLikeScale && [timer isValid]) {
            [timer invalidate];
            timer = nil;
            
            
        }
      
        
    }];
    
    
   
    
  
    
}
#pragma mark - PLSmileViewDelegate
- (void)downViewSmileView:(PLSmileView *)smileView
{
    NSLog(@"smileview down");
    // 父视图大背景背景变亮
    [UIView animateWithDuration:1.0 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }];
    
    // 下降动画
    __block CGFloat disLikeScale0 = self.disLikeScale;
    __block CGFloat likeScale0 = self.likeScale;
    [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if (self.disLikeScale < self.likeScale) {  // 喜欢较高 addOffsetMax属于喜欢
            
            disLikeScale0 -= self.addOffsetMin;
            likeScale0 -= self.addOffsetMax;
        }else{         // 不喜欢较高 addOffsetMax属于不喜欢
            
            disLikeScale0 -= self.addOffsetMax;
            likeScale0 -= self.addOffsetMin;
        }
        
        // 传递比例  不断上升
        _dislikeIV.scale = disLikeScale0;
        _likeIV.scale = likeScale0;
        
        // 字体的alpha变化
        self.fontAlpha -= (CGFloat)1/self.count;
        // 不断下降的过程中  比例字数 也在不断上升
        [self setNeedsDisplay];
        
        // 下降到最低点就停止计时器
        if (disLikeScale0 <= 0.0 && [timer isValid]) {
            [timer invalidate];
            timer = nil;
            
            // 动画结束之后  方可再点击
            self.clickEnable = YES;
            
            
        }

        
    }];
}

/// 出现星星
- (void)smileView:(PLSmileView *)smileView appearStarWithDuration:(CGFloat)duration currentRect:(CGRect)rect
{
    NSLog(@"出现星星");
    _appearStar = YES; // 星星显示
    _currentFrame = rect;
    _starW = 0;
    _starH = 0;
    CGFloat step = 2;
    /// 循环的次数
    NSUInteger count = starWidth / step;
    
        // 增大
        [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            _starH += starHeight/count;
            _starW += step;
            [self setNeedsDisplay];
            
            if (_starW >= starWidth && [timer isValid]) {
                [timer invalidate];
                timer = nil;
                
                
                // 缩小
                [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
                    
                    _starH -= starHeight/count;
                    _starW-= step;
                    [self setNeedsDisplay];
                    
                    if (_starW <= 0 && [timer isValid]) {
                        [timer invalidate];
                        timer = nil;
                    }
                    
                }];
                
            }
      }];
    

    
    
    
}

- (void)drawRect:(CGRect)rect {
  // 先调用  layoutSubviews
    
    
    // 点击之后  再绘制  点击之后  人数+1 比例就会变化
    if(self.clickEnable)  return; // 说明还没有开始点击
    
    // 画比例字样 始终画到PLSmileView的上部 距离是10像素
    NSString *disLikeValue = [NSString stringWithFormat:@"%tu%%",(NSUInteger)(self.disLikeScale * 100)];
    NSString *likeValue = [NSString stringWithFormat:@"%tu%%",(NSUInteger)(self.likeScale * 100)];
    
    //
    CGRect disLikeValueRect = CGRectMake(_dislikeIV.x, _dislikeIV.y - 35, _dislikeIV.width, 15);
    CGRect likeValueRect = CGRectMake(_likeIV.x, _likeIV.y - 35, _likeIV.width, 15);
    
    CGRect disLikeRect = CGRectMake(_dislikeIV.x, _dislikeIV.y - 20, _dislikeIV.width, 15);
    CGRect likeRect = CGRectMake(_likeIV.x, _likeIV.y - 20, _likeIV.width, 15);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:12.0];
    dict[NSForegroundColorAttributeName] = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:self.fontAlpha]; // 小星星 不消失
    
    // 文本居中
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    dict[NSParagraphStyleAttributeName] = style;
    
    [disLikeValue drawInRect:disLikeValueRect withAttributes:dict];
    [likeValue drawInRect:likeValueRect withAttributes:dict];
    [@"无感" drawInRect:disLikeRect withAttributes:dict];
    [@"喜欢" drawInRect:likeRect withAttributes:dict];
    
    
    if (!_appearStar) {
        return;  // 到达一定高度  再绘制星星
    }
    CGFloat liveIVCenterY = _currentFrame.origin.y + _likeIV.originalH * 0.5;
    CGPoint a = CGPointMake(CGRectGetMaxX(_currentFrame), liveIVCenterY - _starH/2 -2);
    CGPoint b = CGPointMake(CGRectGetMaxX(_currentFrame) - _starW/2, liveIVCenterY-2);
    CGPoint c = CGPointMake(CGRectGetMaxX(_currentFrame), liveIVCenterY + _starH/2-2);
    CGPoint d = CGPointMake(CGRectGetMaxX(_currentFrame) + _starW/2, liveIVCenterY-2);
    
    
    UIBezierPath *pathDiamond = [UIBezierPath bezierPath];
    [pathDiamond moveToPoint:a];
    [pathDiamond addLineToPoint:b];
    [pathDiamond addLineToPoint:c];
    [pathDiamond addLineToPoint:d];
    [pathDiamond closePath];
    pathDiamond.lineWidth = 2;
    [[UIColor whiteColor] setFill];
    [pathDiamond fill];
    [pathDiamond stroke];
}


#pragma - lazy
- (CGFloat)disLikeScale
{
    if (!_disLikeScale) {
        _disLikeScale = ((CGFloat)_disLikeCountMut / (_disLikeCountMut + _likeCountMut))+0.005; // 0.2475 约等于 0.25
    }
    return _disLikeScale;
}
- (CGFloat)likeScale
{
    if (!_likeScale) {
        _likeScale = ((CGFloat)_likeCountMut / (_disLikeCountMut + _likeCountMut))+0.005;  // 0.2475 约等于 0.25
    }
    return _likeScale;
}


@end
