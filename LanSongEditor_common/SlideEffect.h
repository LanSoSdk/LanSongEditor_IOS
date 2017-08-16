//
//  SlideEffect.h
//  LanSongEditor_all
//
//  Created by sno on 2017/8/15.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanSongUtils.h"

@interface SlideEffect : NSObject

-(id)initWithPen:(Pen *)pen FPs:(int)fps startTime:(CGFloat)start  endTime:(CGFloat)end release:(BOOL)needRelease;
-(void)run:(CGFloat)currentTimeS;

@end
