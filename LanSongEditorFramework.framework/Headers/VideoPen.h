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



@property (readwrite, retain) AVAsset *asset;

@property(readwrite, retain) NSURL *url;


@property(readwrite, nonatomic) BOOL playAtActualSpeed;


/**
 当前视频图层的即将显示的进度.
 */
@property(nonatomic, copy) void(^onVideoPenCurrentPostionBlock)(CGFloat);

/**
 当使用DrawPadPreview前台预览处理的时候, 用系统自带的AVPlayer作为播放器
 您可以拿到这个播放器对象, 进行seek, rate等操作.
 LSTODO 暂时无法测试!!!???
 比如我们的测试代码是:
 //总的时长.
 //循环播放
 //             sumPlayOperation = videoPen.avplayer.currentItem.duration.value/videoPen.avplayer.currentItem.duration.timescale;
 //            [videoPen.avplayer seekToTime: CMTimeMakeWithSeconds(sender.value*sumPlayOperation, videoPen.avplayer.currentItem.duration.timescale) completionHandler:^(BOOL finished) {
 //
 //            }];
 NSLog(@"sender.value  is>>>:%f",sender.value);
 videoPen.avplayer.rate=sender.value;  //调速
 */
@property(nonatomic) AVPlayer *avplayer;


/**
 设置视频图层在是视频处理完毕后, 是否要循环处理.
 
 暂时不支持后台模式. 只是在AVPlayer中使用.
 */
@property(nonatomic,getter=isLoop) BOOL loopPlay;

/**
 * 内部使用.
 *
 *  @param url    url路径
 *  @param size   容器的尺寸
 *  @param target 目标
 *
 *  @return
 */
- (id)initWithURL:(NSURL *)url drawpadSize:(CGSize)size drawpadTarget:(id<LanSongInput>)target;

@end
