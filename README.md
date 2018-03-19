# PLSmileViewDemo

#gif动图演示如下：

![实例演示](http://upload-images.jianshu.io/upload_images/1698345-a0daa19c317cf174.gif)



#评价控件自定义   两步

1、在控制器视图添加：就按例子所说，计算比例之前就先知道无感人数 \ 喜欢人数 \ 总人数(无感 + 喜欢)。DislikeCount:无感人数 likeCount:喜欢人数，比例值在内部计算。[[UIColor blackColor] colorWithAlphaComponent:0] 背景透明，而子视图不透明。
     
      // 添加视图  24是无感的人数  75是喜欢的人数
      PLBackView *backView = [PLBackView backViewWithDislikeCount:24 likeCount: 75];
      backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
      backView.frame = self.view.bounds;
      [self.view addSubview:backView];

2、设置属性：因为backView.frame = self.view.bounds;所以，相对于控制器view的frame值，就是在backView中真正位置。tf: 是添加在控制器view上的文本框disLikeFrame：“无感”frame  likeFrame:  “喜欢”frame

      // 传入“无感”视图的frame  30是tf与“无感”的间距  20是大图片与“无感”的x方向间距
      backView.disLikeFrame = CGRectMake(CGRectGetMaxX(tf.frame) + 30, CGRectGetMaxY(bgIV.frame) + 20, 0, 0);
    
      // 传入“喜欢”视图的frame  30是“无感”与“喜欢”之间间距 20是大图片与“喜欢”的x方向间距
      backView.likeFrame = CGRectMake(CGRectGetMaxX(backView.disLikeFrame)+ 30, CGRectGetMaxY(bgIV.frame) + 20, 0, 0);
      


