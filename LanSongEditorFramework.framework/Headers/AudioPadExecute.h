//
//  AudioPadExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/8/24.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface AudioPadExecute : NSObject

/**
 给视频或音频 增加其他音频;

 srcInput: 如果是音频,处理后返回的是音频/ 如是视频,则返回的视频
 @param srcInput 音频或视频源
 @param volume 和其他声音混合时的音量
 */
-(id)initWithPath:(NSURL *)srcInput volume:(CGFloat)volume;

/**
 增加音频
可多次调用
 @param audio 音频路径.或带有音频的视频路径
 @param volume 混合时的音量
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio volume:(CGFloat)volume;


/**
 增加音频, 把音频的哪部分 增加到主视频的指定位置上;
 可多次调用

 @param audio 音频路径.或带有音频的视频路径
 @param start 开始
 @param pos  把这个音频 增加到 主音频的那个位置,比如从5秒钟开始增加这个音频
 @param volume 混合时的音量
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio start:(CGFloat)start pos:(CGFloat)pos volume:(CGFloat)volume;
/**
 增加音频
 可多次调用
 @param audio 音频路径.或带有音频的视频路径
 @param start 音频的开始时间段
 @param end 音频的结束时间段
 @param pos 把这个音频 增加到 主音频的那个位置,比如从5秒钟开始增加这个音频
 @param volume 混合时的音量
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio start:(CGFloat)start end:(CGFloat)end pos:(CGFloat)pos volume:(CGFloat)volume;

/**
 开始
 @return 成功,返回YES, 失败返回NO;
 */
-(BOOL)start;

/**
 取消
 */
-(void)cancel;


/**
 进度回调,
 此进度回调, 在 编码完一帧后,没有任意queue判断,直接调用这个block;
 比如在:assetWriterPixelBufferInput appendPixelBuffer执行后,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^progressBlock)(CGFloat progess);


/**
 编码完成回调, 完成后返回生成的视频路径;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *dstPath);


/*  *************************举例如下************************************
 
 NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"dy_xialu1" withExtension:@"mp4"];
 AudioPadExecute *audioPad=[[AudioPadExecute alloc] initWithPath:videoURL volume:0];
 
 [audioPad setProgressBlock:^(CGFloat progess) {
 dispatch_async(dispatch_get_main_queue(), ^{
 NSLog(@"progress  dispatch_get_main_queue  is :%f",progess);
 });
 }];
 
 [audioPad setCompletionBlock:^(NSString *dstPath) {
 
 dispatch_async(dispatch_get_main_queue(), ^{
 NSLog(@"medaiInfo is:%@",[MediaInfo checkFile:dstPath]);
 });
 }];
 
 //增加声音
 NSURL *audioURL2 = [[NSBundle mainBundle] URLForResource:@"hongdou" withExtension:@"mp3"];
 [audioPad addAudio:audioURL2 volume:0.1];
 [audioPad start];
*/
@end
