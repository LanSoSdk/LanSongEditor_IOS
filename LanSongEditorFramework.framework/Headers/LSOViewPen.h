//
//  ViewPen.h
//  LanSongEditorFramework
//
//  Created by sno on 16/12/24.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOPen.h"


@interface LSOViewPen : LSOPen



/**
 内部使用 inner use
 */
@property BOOL isFromUI;

/**
 替换UIView
 view的大小要等于init输入的inputView大小.
 */
-(void)replaceUIView:(UIView *)view;

/**
 设置: 是否使用了核心动画
 默认不使用;
 请注意:使用核心动画,则绘制慢, 可以用renderCACoreFrameTime获取当前一帧绘制的时间.
 
 如 CAEmitterLayer 粒子发射器就是核心动画. 需要设置为YES;
 
 @param is
 */
-(void)setUsedCACoreAnimation:(BOOL)is;
-(CGFloat)renderCACoreFrameTime;

/******************一下是内部使用******************************/

- (id)initWithView:(UIView *)inputView drawpadSize:(CGSize)size drawpadTarget:(id<LanSongInput>)target;

@property BOOL isUsedForAE;

@property BOOL isFastModeWhenAe;
@end
