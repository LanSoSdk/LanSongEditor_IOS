//
//  LanSongScaleExecute
//  LanSongEditorFramework
//
//  Created by sno on 2018/8/1.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import "MediaInfo.h"
#import "LanSongFilter.h"

@interface LanSongScaleExecute : NSObject

/**
 init
 @param path 要缩放的视频完整路径
 @param size 缩放到的大小,
 @param dstPath 缩放后保存到的视频路径, 后缀是mp4
 @return
 */
-(id)initWithPath:(NSString *)path scaleSize:(CGSize)size dstPath:(NSString *)dstPath;
/**
 init
 @param path 要缩放的视频完整路径
 @param size 缩放到的大小,
 @param bitrate 缩放到的码率.
 @param dstPath 缩放后保存到的视频路径, 后缀是mp4
 @return
 */
-(id)initWithPath:(NSString *)path scaleSize:(CGSize)size bitrate:(int)bitrate dstPath:(NSString *)dstPath;
/**
 在开始之前, 可以设置滤镜
 */
-(void)switchFilter:(LanSongFilter *)filter;

/**
 在开始之前,设置多个滤镜.
 */
-(void)switchFilterList:(NSArray*) filters;


/**
 开始执行, 内部会开启VideoProgressQueue. 不可和DrawPad线程同时使用.
 
 @return 开启成功返回YES, 失败返回NO;
 */
-(BOOL)start;

/**
 停止执行,
 */
-(void)stop;

/**
 *     执行过程中的进度对调, 返回的当前时间戳 单位是秒.
 
 注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....CODEC....
 });
 */
@property(nonatomic, copy) void(^videoProgressBlock)(CGFloat progess);
/**
 结束回调.
 
 */
@property(nonatomic, copy) void(^completionBlock)(void);

@property(nonatomic,readonly)  CGSize scaleSize;

@property   MediaInfo *videoInfo;

@end
