//
//  ProcessBar.h
//
//  Created by Pandara on 14-8-13.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoUtils.h"


typedef enum {
    ProgressBarProgressStyleNormal,
    ProgressBarProgressStyleDelete,
} ProgressBarProgressStyle;

@interface ProgressBar : UIView

+ (ProgressBar *)getInstance;

- (void)setLastProgressToStyle:(ProgressBarProgressStyle)style;
- (void)setLastProgressToWidth:(CGFloat)width;

- (void)deleteLastProgress;
- (void)addProgressView;

- (void)stopShining;
- (void)startShining;

@end
