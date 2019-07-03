//
//  SegmentRecordProgressView.m
//  LanSongEditor_all
//
//  Created by sno on 2017/9/26.
//  Copyright © 2017年 sno. All rights reserved.
//

#import "SegmentRecordProgressView.h"
#import "DemoUtils.h"


//#define BAR_H 18
#define BAR_H 5
#define BAR_MARGIN 2

#define BAR_BLUE_COLOR color(68, 214, 254, 1)
#define BAR_RED_COLOR color(224, 66, 39, 1)
#define BAR_BG_COLOR color(38, 38, 38, 1)

#define BAR_MIN_W 80

#define BG_COLOR color(11, 11, 11, 1)

#define INDICATOR_W 16
#define INDICATOR_H 22

#define TIMER_INTERVAL 1.0f

@interface SegmentRecordProgressView ()
@property (strong, nonatomic) NSMutableArray *progressViewArray;

@property (strong, nonatomic) UIView *barView;
@property (strong, nonatomic) UIImageView *progressIndicator;

@property (strong, nonatomic) NSTimer *shiningTimer;

@end

@implementation SegmentRecordProgressView

@synthesize maxDuration=_maxDuration;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initalize];
    }
    return self;
}

- (void)initalize
{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = BG_COLOR;
    self.progressViewArray = [[NSMutableArray alloc] init];
    
    //barView
    self.barView = [[UIView alloc] initWithFrame:CGRectMake(0, BAR_MARGIN, self.frame.size.width, BAR_H)];
    _barView.backgroundColor = BAR_BG_COLOR;
    [self addSubview:_barView];
    
    //最短分割线
    UIView *intervalView = [[UIView alloc] initWithFrame:CGRectMake(BAR_MIN_W, 0, 1, BAR_H)];
    intervalView.backgroundColor = [UIColor blackColor];
    [_barView addSubview:intervalView];
    
    //indicator
    self.progressIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, INDICATOR_W, INDICATOR_H)];
    _progressIndicator.backgroundColor = [UIColor clearColor];
    _progressIndicator.image = [UIImage imageNamed:@"record_progressbar_front.png"];
    _progressIndicator.center = CGPointMake(0, self.frame.size.height / 2);
    [self addSubview:_progressIndicator];
}

- (UIView *)getProgressView
{
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, BAR_H)];
    progressView.backgroundColor = BAR_BLUE_COLOR;
    progressView.autoresizesSubviews = YES;
    
    return progressView;
}

- (void)refreshIndicatorPosition
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        _progressIndicator.center = CGPointMake(0, self.frame.size.height / 2);
        return;
    }
    
    _progressIndicator.center = CGPointMake(MIN(lastProgressView.frame.origin.x + lastProgressView.frame.size.width, self.frame.size.width - _progressIndicator.frame.size.width / 2 + 2), self.frame.size.height / 2);
}

- (void)onTimer:(NSTimer *)timer
{
    [UIView animateWithDuration:TIMER_INTERVAL / 2 animations:^{
        _progressIndicator.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:TIMER_INTERVAL / 2 animations:^{
            _progressIndicator.alpha = 1;
        }];
    }];
}

- (void)start
{
    self.shiningTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (void)stop
{
    [_shiningTimer invalidate];
    self.shiningTimer = nil;
    _progressIndicator.alpha = 1;
}

/**
 新增加一个view,
 */
- (void)addNewSegment
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    CGFloat newProgressX = 0.0f;
    
    if (lastProgressView) {
        CGRect frame = lastProgressView.frame;
        frame.size.width -= 1;
        lastProgressView.frame = frame;
        
        newProgressX = frame.origin.x + frame.size.width + 1;
    }
    
    UIView *newProgressView = [self getProgressView];
    [DemoUtils setView:newProgressView toOriginX:newProgressX];
    
    [_barView addSubview:newProgressView];
    
    [_progressViewArray addObject:newProgressView];
}

- (void)setLastSegmentPts:(CGFloat)pts
{
    if(self.maxDuration>0){
         [self setLastProgressToWidth:pts / self.maxDuration * self.frame.size.width];
    }
}
- (void)setLastProgressToWidth:(CGFloat)width
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    [DemoUtils setView:lastProgressView toSizeWidth:width];
    [self refreshIndicatorPosition];
}

/**
 找到最后一段的UIView
 
 @param style <#style description#>
 */
- (void)setNormalMode
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    
    lastProgressView.backgroundColor = BAR_BLUE_COLOR;
    _progressIndicator.hidden = NO;
}

- (void)setWillDeleteMode;
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    lastProgressView.backgroundColor = BAR_RED_COLOR;
    _progressIndicator.hidden = YES;
    
}

- (void)deleteLastSegment
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    [lastProgressView removeFromSuperview];
    [_progressViewArray removeLastObject];
    
    _progressIndicator.hidden = NO;
    
    [self refreshIndicatorPosition];
}

+ (SegmentRecordProgressView *)getInstance
{
    SegmentRecordProgressView *progressBar = [[SegmentRecordProgressView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, BAR_H + BAR_MARGIN * 2)];
    return progressBar;
}

@end

