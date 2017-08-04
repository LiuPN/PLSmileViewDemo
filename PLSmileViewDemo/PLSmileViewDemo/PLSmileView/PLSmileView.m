//
//  PLSmileView.m
//  PLSmileView
//
//  Created by lpn on 2017/7/28.
//  Copyright © 2017年 刘攀妞. All rights reserved.
//  两个重叠的笑脸

#import "PLSmileView.h"
#import "UIView+Frame.h"
#import "UIView+category.h"
#define MAXHEIGHT 100  // 比例是100%的最大高度


@interface PLSmileView ()

// 笑脸imageView
@property(nonatomic, strong) UIImageView *imageIv;

// 当前self的fill颜色 白色  与 黄色
@property(nonatomic, strong) UIColor *color;

@end

@implementation PLSmileView


+ (instancetype)smileView
{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"PLSmileView" owner:nil options:nil] lastObject];
}
- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    self.imageIv.image = [UIImage imageNamed:imageName];
}

/// 不断改变的比例
- (void)setScale:(CGFloat)scale
{
    _scale  = scale;
    
    
    
    // 高度 y值随着变化
    self.height = (scale <= 0?_originalH:_originalH + MAXHEIGHT * scale);
    self.y = _originalY - MAXHEIGHT * scale;
    // 绘制
    [self setNeedsDisplay];
    
    
    
}
- (void)setFillYellowColor:(BOOL)fillYellowColor
{
    _fillYellowColor = fillYellowColor;
    if (fillYellowColor) {
        self.color = [UIColor yellowColor];
    }else
    {
        self.color = [UIColor whiteColor];
    }
}


- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawRect"); // 方法3
    
    if (_scale == 0) {
        self.color = [UIColor whiteColor];
    }
    
    // 画实心背景 圆角边框
    UIBezierPath *borderB = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.width * 0.5];
    borderB.lineWidth = 5;  // 边框宽度
    [self.color setFill];
    [[UIColor greenColor] setStroke];
    [borderB fill];
    [borderB stroke];
    
    // 始终在顶端
    self.imageIv.centerX = self.width * 0.5;
    self.imageIv.y = 2.5;
    
    
    /* 笑脸在上升到最高点再执行
    三个条件 1 属于不喜欢的视图  2  到达了最高点  3 不喜欢的视图被点击 缺一不可*/
    if (self.type == PLSmileViewDislikeType && _scale >= self.maxScaleValue && self.fillYellowColor) {
        
        
        NSLog(@"不喜欢的扭头");
        NSMutableArray *arrayImages = [NSMutableArray array];
        for (int i = 0; i < 9; i ++) {
            _imageName = [NSString stringWithFormat:@"dislike_%d", (i + 1)];
            UIImage *image = [UIImage imageNamed:_imageName];
            [arrayImages addObject:image];
            
        }
        self.imageIv.animationImages = arrayImages;
        self.imageIv.animationRepeatCount = 1;
        self.imageIv.animationDuration = arrayImages.count * 0.08;
        self.imageIv.image = [arrayImages lastObject];
        [self.imageIv startAnimating];
        
        
        // 左右来回旋转
        NSLog(@"左右来回移动");
        [UIView animateWithDuration:0.15 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            // 向左移动3像素
            self.imageIv.transform = CGAffineTransformMakeTranslation(-3, 0);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.30 animations:^{
                
                // 向右移动6像素
                self.imageIv.transform = CGAffineTransformTranslate(self.imageIv.transform, 6, 0);
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.15 animations:^{
                    // 回到原位置
                    self.imageIv.transform = CGAffineTransformIdentity;
                    
                } completion:^(BOOL finished) {
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        // 代理  告诉另一个view也down
                        if ([self.downDelegate respondsToSelector:@selector(downViewSmileView:)]) {
                            [self.downDelegate downViewSmileView:self];
                        }
                        
                    });
                    
                }];
                
            }];
            
           
            
            
        }];
        
    }else if(self.type == PLSmileViewLikeType && _scale >= self.maxScaleValue && self.fillYellowColor){
        
        // 笑脸的眨眼睛
        __block int i = 0;
        [NSTimer scheduledTimerWithTimeInterval:0.02 repeats:YES block:^(NSTimer * _Nonnull timer) {
            i++;
            self.imageIv.image = [UIImage imageNamed:[NSString stringWithFormat:@"like_%d", (i + 1)]];
            
            if (i+1 == 9) {
                if ([self.downDelegate respondsToSelector:@selector(smileView:appearStarWithDuration:currentRect:)]) {
                    // 第9 10 11张时间段显示星星
                    [self.downDelegate smileView:self appearStarWithDuration:3 * 0.02 currentRect:self.frame];
                }

                
            }
            
            if ((i+1 == 27) && [timer isValid]) {  // NStimer停止
                [timer invalidate];
                timer = nil;
            }
        }];
        
        
        // 下降
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.downDelegate respondsToSelector:@selector(downViewSmileView:)]) {
                [self.downDelegate downViewSmileView:self];
            }
            
        });
        

        
    }
    

    
}





#pragma - lazy
- (UIImageView *)imageIv
{
    if (!_imageIv) {
        _imageIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_imageName]];
        
        [self addSubview:_imageIv];
    }
    return _imageIv;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整self为圆形
     [UIView makeCircleFromView:self storkColor:nil borderWidth:0 cornerRadius:self.width * 0.5];
    
   
    
}

@end
