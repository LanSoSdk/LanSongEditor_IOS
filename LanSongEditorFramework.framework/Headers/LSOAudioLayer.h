//
//  LSOAudioLayer.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/4/1.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOAudioLayer : LSOObject

/**
,
 */

///  初始化
/// @param url 输入的声音url完整路径
-(id)initWithURL:(NSURL *)url;

/**
声音文件本身的时长;
 单位秒;
 */
@property (nonatomic, readonly) CGFloat assetDurationS;

/**
你可以设置对声音做裁剪操作.

此为裁剪的开始时间;
比如你从声音的的第三秒裁剪; 则这里填入cutStartTimeS=3;
 */
@property (nonatomic, readwrite) CGFloat cutStartTimeS;

/**
 你可以设置对声音做裁剪操作.

 此为裁剪的结束时间;
 比如你从裁剪到第8秒 则这里填入cutEndTimeS=8.0;
 */
@property (nonatomic, readwrite) CGFloat cutEndTimeS;


/**
 
 当前在容器中的声音的有效时间;
 当你没有没有做裁剪操作, 则等于assetDurationS;
 当裁剪了,则等于cutEndTimeS - cutStartTimeS;
 
 还有一种情况: 比如你裁剪保留了3秒的时长, 但你想播放3遍, 则这里等于3*3=9.0;
 如果你设置了looping, 则这里是无限长
 */
@property (nonatomic, readwrite) CGFloat layerDurationS;

/**
 从容器的什么时间点开始增加声音;
 [可调节]
 */
@property (nonatomic, readwrite) CGFloat startTimeOfComp;

/**
 是否循环;
 */
@property (nonatomic, readwrite) BOOL looping;

/**
 调节视频中的音频音量.
 范围是0.0---8.0;
 1.0是原始音量; 大于1.0,是放大; 小于1.0是缩小;
 如果是0.0则无声,
 */
@property (nonatomic, assign)CGFloat audioVolume;

/**
 音量淡出时长设置/获取;
 默认是0.0,无淡出效果;
 最大为当前有效时长的1/3;
 LSTODO
 */
@property (readwrite, assign) CGFloat volumeFadeOutDurationS;

/**
 音量淡入时长设置/获取;
 默认是0.0; 无淡入效果;
 最大为当前有效时长的1/3;
 LSTODO 
 */
@property (readwrite, assign) CGFloat volumeFadeInDurationS;


@property (nonatomic, assign)CGFloat audioFadeInDurationS;
@property (nonatomic, assign)CGFloat audioFadeOutDurationS;
@property (nonatomic, readonly)CGFloat audioFade;














@end

NS_ASSUME_NONNULL_END
