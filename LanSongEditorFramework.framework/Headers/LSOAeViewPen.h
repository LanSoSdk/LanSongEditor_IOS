//
//  LSOAeViewPen.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/10/30.
//  Copyright © 2019 sno. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "LSOPen.h"
#import "LSOAeView.h"


@interface LSOAeViewPen : LSOPen



/**
 动画的播放速度; 如果你在容器中设置了时间段,并且时间段小于动画总时长;
 默认速度是1.0;
 则默认会调试播放速度, 以便让动画显示完毕;
 建议范围在0.1--4.0之间;
 */
@property (readwrite, assign) CGFloat playSpeed;

/******************一下是内部使用******************************/
- (id)initWithAeView:(LSOAeView *)inputView drawpadSize:(CGSize)size drawpadTarget:(id<LanSongInput>)target;
@property BOOL isFromUI;
@property BOOL isFastModeWhenAe;
@end
