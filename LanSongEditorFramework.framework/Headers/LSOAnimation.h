//
//  LSOAnimation.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/11/10.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"
#import "LanSongFilter.h"

NS_ASSUME_NONNULL_BEGIN

//动画类型;
typedef NS_ENUM(NSUInteger, AnimationType) {
    kAnimationTypeNone,
    kAnimationTypeAE,
    kAnimationTypeMask,
    kAnimationTypeAdjust,
    kAnimationTypeMV
};


/// 所有动画的父类,不能直接创建对象;
@interface LSOAnimation : LSOObject





@property (nonatomic,assign) CGFloat durationS;

  

//*************************一下为内部使用,外界请勿使用***************************************
/**
 * 动画的开始时间,
 */
@property (nonatomic,assign) CGFloat startTimeFromPadS;
@property (nonatomic,assign) CGFloat endTimeFromPadS;

typedef void (^drawAnimationHandler)(LanSongFilter *filter, BOOL start);

/**
  * 是否保持最后一帧, 如果保持的话, 则只需要大于开始时间即可, 因为取动画的index有限制为最大为动画的最大;
  */
@property (nonatomic,assign) BOOL isHoldLastFrame;

@property  BOOL locked;


@property (nonatomic,assign) AnimationType animationType;

-(BOOL) isDisplay:(CGFloat)ptsS;
-(BOOL) getReachEnd;
-(void)resetGetIndex;
-(void)releaseOnTask;


@end

NS_ASSUME_NONNULL_END
