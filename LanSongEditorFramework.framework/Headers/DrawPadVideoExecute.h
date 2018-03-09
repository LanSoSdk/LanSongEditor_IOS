//
//  DrawPadVideoExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 23/01/2018.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LanSongFilter.h"
#import "MediaInfo.h"
#import "BitmapPen.h"
#import "VideoPen.h"
#import "BitmapPen.h"
#import "CALayerPen.h"
#import "ViewPen.h"
#import "MVPen.h"

@interface DrawPadVideoExecute : NSObject

/**
init

@param path 要缩放的视频完整路径
@param size 缩放到的大小,
@param dstPath 缩放后保存到的视频路径, 后缀是mp4
@return
*/
-(id)initWithPath:(NSString *)path drawpadSize:(CGSize)size dstPath:(NSString *)dstPath;


/**
 给init时输入的视频 设置
 
 @param path 要缩放的视频完整路径
 @param size 缩放到的大小,
 @param bitrate 缩放到的码率.
 @param dstPath 缩放后保存到的视频路径, 后缀是mp4
 @return
 */
-(id)initWithPath:(NSString *)path drawpadSize:(CGSize)size bitrate:(int)bitrate dstPath:(NSString *)dstPath;
/**
 在开始之前,给init时输入的视频 设置多个滤镜.
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
 这个时间戳是视频中即将处理的这一帧的时间戳.
 
 
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

@property  CGSize drawpadSize;

@property   MediaInfo *videoInfo;

/**
 增加图片图层;
 */
-(BitmapPen *)addBitmapPen:(UIImage *)inputImage;

@end
