//
//  VCFFmpegCompositeLoading.m
//  VCore
//
//  Created by mac on 2019/1/25.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "VCFFmpegCompositeLoading.h"

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#undef  RGBACOLOR
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

@interface VCFFmpegCompositeLoading ()
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@end

@implementation VCFFmpegCompositeLoading

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:CGRectMake((kDeviceWidth-150)/2, (kDeviceHeight-140)/2, 150, 120)];
    if (self) {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        UIView *circleBg = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-50)/2, 15, 50, 50)];
        circleBg.layer.borderColor = RGBACOLOR(255, 255, 255, 0.4).CGColor;
        circleBg.layer.borderWidth = 2;
        circleBg.layer.cornerRadius = 25;
        [self addSubview:circleBg];
        
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(circleBg.frame.size.width/2, circleBg.frame.size.width/2) radius:circleBg.frame.size.width/2-1 startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.path = circlePath.CGPath;
        circleLayer.strokeColor = [UIColor whiteColor].CGColor;
        circleLayer.fillColor = [UIColor clearColor].CGColor;
        circleLayer.strokeStart = 0.0;
        circleLayer.strokeEnd = 0.0;
        circleLayer.lineWidth = 2;
        [circleBg.layer addSublayer:circleLayer];
        self.circleLayer = circleLayer;
        
        UILabel *tipLbale = [[UILabel alloc] initWithFrame:CGRectMake(0, circleBg.frame.origin.y+circleBg.frame.size.height+15, self.frame.size.width, 20)];
        tipLbale.text = @"视频正在合成中...";
        tipLbale.textColor = [UIColor whiteColor];
        tipLbale.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        tipLbale.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tipLbale];
    }
    return self;
}

- (void)show{
    self.hidden = YES;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
}

- (void)configProgress:(CGFloat)progress{
    self.hidden = NO;
    self.circleLayer.strokeEnd = progress;
    
}

- (void)dismiss{
    
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
