//
//  LSOVideoOption.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/11/13.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"


NS_ASSUME_NONNULL_BEGIN


@interface LSOVideoOption : LSOObject


+ (instancetype)optionWithCutTime:(CGFloat)startS endS:(CGFloat)endS;


-(id)init;

/// 时长裁剪的开始时间点
@property (nonatomic, assign) CGFloat cutStartS;


///时长裁剪的结束时间点
@property (nonatomic, assign) CGFloat cutEndS;


/// 是否禁止声音;
@property (nonatomic, assign) BOOL isDisableAudio;

/// 音量大小,默认是1.0; 大于1.0是放大, 小于1.0是减小, 等于0则无声;
@property (nonatomic, assign) CGFloat audioVolume;

/**
  视频是否循环. 仅用在DrawPadAllExecute中;
 默认不循环;
 */
@property (nonatomic,assign)BOOL  looping;


/**
 是否保持第一帧;
 用在DrawPadAllExecute中
 */
@property (nonatomic, assign) BOOL holdFirstFrame;

/**
 是否保持最后一帧;
 用在DrawPadAllExecute中
 */
@property (nonatomic, assign) BOOL holdLastFrame;


@end

NS_ASSUME_NONNULL_END
