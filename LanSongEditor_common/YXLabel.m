//
//  YXLabel.m
//
//  Created by YouXianMing on 14-8-23.
//  Copyright (c) 2014年 YouXianMing. All rights reserved.
//

#import "YXLabel.h"

@interface YXLabel ()

@property (nonatomic, strong) UILabel  *backedLabel;
@property (nonatomic, strong) UILabel  *colorLabel;

@end

@implementation YXLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _backedLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _colorLabel  = [[UILabel alloc] initWithFrame:self.bounds];
        
        // 初始时的alpha值为0
        _backedLabel.alpha = 0;
        _colorLabel.alpha  = 0;
        
        // 文本居中
        _backedLabel.textAlignment = NSTextAlignmentCenter;
        _colorLabel.textAlignment  = NSTextAlignmentCenter;
        
        [self addSubview:_backedLabel];
        [self addSubview:_colorLabel];
    }
    return self;
}

- (void)startAnimation
{
    // 判断endScale的值
    if (_endScale == 0) {
        _endScale = 2.f;
    }
    
    // 开始第一次动画
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:7
          initialSpringVelocity:4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // 恢复正常尺寸
                         _backedLabel.alpha     = 1.f;
                         _backedLabel.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
                         
                         _colorLabel.alpha      = 1.f;
                         _colorLabel.transform  = CGAffineTransformMake(1, 0, 0, 1, 0, 0);;
                     }
                     completion:^(BOOL finished) {
                         
                         // 开始第二次动画
                         [UIView animateWithDuration:2
                                               delay:0.5
                              usingSpringWithDamping:7
                               initialSpringVelocity:4
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              _colorLabel.alpha     = 0.f;
                                              _colorLabel.transform = CGAffineTransformMake(_endScale, 0, 0, _endScale, 0, 0);
                                          }
                                          completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}


#pragma mark - 重写setter方法
@synthesize text = _text;
- (void)setText:(NSString *)text
{
    _text             = text;
    _backedLabel.text = text;
    _colorLabel.text  = text;
}
- (NSString *)text
{
    return _text;
}

@synthesize startScale = _startScale;
- (void)setStartScale:(CGFloat)startScale
{
    _startScale = startScale;
    _backedLabel.transform = CGAffineTransformMake(startScale, 0, 0, startScale, 0, 0);
    _colorLabel.transform  = CGAffineTransformMake(startScale, 0, 0, startScale, 0, 0);
}
- (CGFloat)startScale
{
    return _startScale;
}

@synthesize font = _font;
- (void)setFont:(UIFont *)font
{
    _font = font;
    _backedLabel.font = font;
    _colorLabel.font  = font;
}
- (UIFont *)font
{
    return _font;
}

@synthesize backedLabelColor = _backedLabelColor;
- (void)setBackedLabelColor:(UIColor *)backedLabelColor
{
    _backedLabelColor = backedLabelColor;
    _backedLabel.textColor = backedLabelColor;
}

@synthesize colorLabelColor = _colorLabelColor;
- (void)setColorLabelColor:(UIColor *)colorLabelColor
{
    _colorLabelColor = colorLabelColor;
    _colorLabel.textColor = colorLabelColor;
}

@end
