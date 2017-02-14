//
//  YXLabel.h
//
//  Created by YouXianMing on 14-8-23.
//  Copyright (c) 2014年 YouXianMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLabel : UIView

@property (nonatomic, strong) NSString *text;       // 文本的文字
@property (nonatomic, strong) UIFont   *font;       // 文本的字体

@property (nonatomic, assign) CGFloat   startScale; // 最初处于alpha = 0状态时的scale值
@property (nonatomic, assign) CGFloat   endScale;   // 最后处于alpha = 0状态时的scale值

@property (nonatomic, strong) UIColor  *backedLabelColor; // 不会消失的那个label的颜色
@property (nonatomic, strong) UIColor  *colorLabelColor;  // 最终会消失的那个label的颜色

- (void)startAnimation;

//    YXLabel *label   = [[YXLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
//    label.text       = @"蓝松科技, 短视频处理";
//    label.startScale = 0.3f;
//    label.endScale   = 2.f;
//    label.backedLabelColor = [UIColor whiteColor];
//    label.colorLabelColor  = [UIColor cyanColor];
//    label.font=[UIFont systemFontOfSize:30];
//    label.center      = self.view.center;
//    [self.view addSubview:label];
//
//
//    [label startAnimation];
@end
