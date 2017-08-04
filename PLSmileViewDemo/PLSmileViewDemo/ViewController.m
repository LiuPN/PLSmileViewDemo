//
//  ViewController.m
//  PLSmileViewDemo
//
//  Created by lpn on 2017/8/4.
//  Copyright © 2017年 刘攀妞. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Frame.h"
#import "PLBackView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 大背景
    UIImageView *bgIV = [[UIImageView alloc] init];
    bgIV.image = [UIImage imageNamed:@"background"];
    bgIV.width = self.view.width - 20;
    bgIV.height = bgIV.width * bgIV.image.size.height / bgIV.image.size.width;
    bgIV.centerX = self.view.centerX;
    bgIV.y = 50;
    [self.view addSubview:bgIV];
    
    // 添加视图
    PLBackView *backView = [PLBackView backViewWithDislikeCount:24 likeCount: 75];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    backView.frame = self.view.bounds;
    [self.view addSubview:backView];
    
    
    
    // 添加uitextFieled
    UITextField *tf = [[UITextField alloc] init];
    tf.width = backView.width * 0.5;
    tf.height = 35;
    tf.y = CGRectGetMaxY(bgIV.frame) + 20;
    tf.x = 20;
    tf.backgroundColor = [UIColor whiteColor];
    tf.placeholder = @"评价一下我的作品吧";
    tf.font = [UIFont systemFontOfSize:13.0];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:tf];
    
    
    // 传入“无感”视图的frame  30是tf与“无感”的间距  20是大图片与“无感”的x方向间距
    backView.disLikeFrame = CGRectMake(CGRectGetMaxX(tf.frame) + 30, CGRectGetMaxY(bgIV.frame) + 20, 0, 0);
    
    // 传入“喜欢”视图的frame  30是“无感”与“喜欢”之间间距 20是大图片与“喜欢”的x方向间距
    backView.likeFrame = CGRectMake(CGRectGetMaxX(backView.disLikeFrame)+ 30, CGRectGetMaxY(bgIV.frame) + 20, 0, 0);
    
}


@end
