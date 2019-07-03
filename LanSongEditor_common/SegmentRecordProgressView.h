//
//  SegmentRecordProgressView.h
//  LanSongEditor_all
//
//  Created by sno on 2017/9/26.
//  Copyright © 2017年 sno. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DemoUtils.h"

@interface SegmentRecordProgressView : UIView

+ (SegmentRecordProgressView *)getInstance;


/**
 设置view的最长时间.
 即要分段录制的最大长度.
 */
@property  CGFloat maxDuration;


- (void)start;
- (void)stop;


/**
 设置最后一段的实时时间戳,也可以理解为进度.

 @param pts
 */
- (void)setLastSegmentPts:(CGFloat)pts;
/**
 新增加一个view,
 */
- (void)addNewSegment;

- (void)setNormalMode;

- (void)setWillDeleteMode;

- (void)deleteLastSegment;

@end
