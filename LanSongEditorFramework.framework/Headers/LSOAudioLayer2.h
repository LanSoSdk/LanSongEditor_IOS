//
//  LSOAudioLayer2.h
//  LanSongEditorFramework
//
//  Created by sno on 2021/4/12.
//  Copyright © 2021 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>
#import "LSOObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOAudioLayer2 : LSOObject


///  初始化
/// @param url 输入的声音url完整路径

/**
声音文件本身的时长;
 单位秒;
 */
@property (nonatomic, readonly) CGFloat originalDurationS;



/// 可显示的时长;(最大等于播放器时长)
@property (nonatomic, readonly) CGFloat displayDurationS;


/// 裁剪时长
/// @param startS 开始时间
/// @param duration 裁剪的时长;(等于结束时间 - 开始时间)
- (void)setCutDurationWithStart:(CGFloat)startS durationS:(CGFloat)duration;

/**
裁剪的开始时间;
 */
@property (nonatomic, readonly) CGFloat cutStartTimeS;

/**
 裁剪的结束时间;
 */
@property (nonatomic, readonly) CGFloat cutEndTimeS;

/**
 是否循环;
 */
@property (nonatomic, assign) BOOL looping;

/**
 调节视频中的音频音量.
 范围是0.0---2.0;
 1.0是原始音量; 大于1.0,是放大; 小于1.0是缩小;
 如果是0.0则无声,
 */
@property (nonatomic, assign)CGFloat audioVolume;














@property (nonatomic, strong)NSURL *audioURL;



@end

NS_ASSUME_NONNULL_END
