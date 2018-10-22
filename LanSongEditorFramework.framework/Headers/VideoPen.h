//
//  MyDecoder.h
//  LanSongEditorFramework
//
//  Created by sno on 16/12/21.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Pen.h"
#import "MediaInfo.h"




/**
 * Source object for filtering movies
 * 解码传递过来的文件路径. 解码
 */
@interface VideoPen : Pen



@property(readonly, nonatomic)MediaInfo *mediaInfo;
/**
 当前视频图层的即将显示的进度.
 */
@property(nonatomic, copy) void(^onVideoPenCurrentPostionBlock)(CGFloat);


/**
 用在前台预览,
 当前播放走到文件尾部的回调. 如果你设置了循环播放,则会再次循环;
 */
@property(nonatomic, copy) void(^onAVPlayerToEndBlock)();

/**
 当使用DrawPadPreview前台预览处理的时候, 用系统自带的AVPlayer作为播放器
 您可以拿到这个播放器对象, 进行seek, rate等操作.
 */
@property(nonatomic) AVPlayer *avplayer;


/**
 当前视频的时长;
 */
@property(nonatomic) CGFloat duration;


/**
 定位到指定时间;

 @param timeS 单位秒
 */
-(void)seekToTime:(CGFloat)timeS;


/**
 定位 到 百分比; 比如 percent=0.1--0.5--1.0;
 
 */
-(void)seekToPercent:(CGFloat)percent;

/**
 定位后 暂停;
 @param timeS 单位秒
 */
-(void)seekToTimePause:(CGFloat)timeS;


/**
 设置avplayer的播放速度, 范围从0.0--2.0;
 内部等于_avplayer.rate=rate;
 */
@property (nonatomic) float rate;
/**
 设置视频图层在是视频处理完毕后, 是否要循环处理.
 */
@property(nonatomic,getter=isLoop) BOOL loopPlay;

/**
 * 内部使用.
 */
- (id)initWithURL:(NSURL *)url drawpadSize:(CGSize)size drawpadTarget:(id<LanSongInput>)target;

@end
