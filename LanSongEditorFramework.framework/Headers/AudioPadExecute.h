//
//  AudioPadExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/8/24.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LanSongLog.h"
#import "LSOObject.h"
/**
 音频容器
 用处1:给视频各种声音.
 用处2:先设置声音总长度, 然后增加各种其他声音,最后合成声音;
 */
@interface AudioPadExecute : LSOObject



/// <#Description#>
/// @param srcInput <#srcInput description#>
/// @param cutDurationS <#cutDurationS description#>
/// @param volume <#volume description#>
-(id)initWithURL:(NSURL *)srcInput duration:(CGFloat)cutDurationS volume:(CGFloat)volume;
/**
 给视频或音频 增加其他音频;

 srcInput: 如果是音频,处理后返回的是音频/ 如是视频,则返回的视频
 @param srcInput 音频或视频源
 @param volume 和其他声音混合时的音量; 如不要主视频的声音,则这里等于0;
 */
-(id)initWithURL:(NSURL *)srcInput volume:(CGFloat)volume;


/**
 音频容器(定义一个时长)
定义容器的总长度, 然后依次增加声音.
 
 @param durationS 定义容器的总长度
 */
-(id)initWithDuration:(CGFloat)durationS;


-(id)initWithURL:(NSURL *)srcInput volume:(CGFloat)volume onlyAudio:(BOOL)only;
/**
 增加音频
可多次调用
 @param audio 音频路径.或带有音频的视频路径
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio volume:(CGFloat)volume;

/**
 增加音频
 可多次调用
 
 @param audio 音频路径.或带有音频的视频路径
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @param isLoop 是否循环
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio volume:(CGFloat)volume loop:(BOOL)isLoop;


/**
 增加音频, 把音频的哪部分 增加到主视频的指定位置上;
 可多次调用

 @param audio 音频路径.或带有音频的视频路径
 @param start 开始
 @param pos  把这个音频 增加到 音频容器的哪个位置,比如从5秒钟开始增加这个音频
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio start:(CGFloat)start pos:(CGFloat)pos volume:(CGFloat)volume;
/**
 增加音频
 可多次调用
 @param audio 音频路径.或带有音频的视频路径
 @param start 音频的开始时间段
 @param end 音频的结束时间段 如果增加到结尾, 则可以输入-1
 @param pos 把这个音频 增加到容器的什么位置,比如从5秒钟开始增加这个音频
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
 等待异步执行完毕;
 @return 执行完毕,返回结果字符串;
 */
-(NSString *)waitForCompleted;
/**
 取消
 */
-(void)cancel;

/**
 开始(阻塞执行)
 只有执行完毕后,才返回;
 使用在比如15s左右的音频,处理很快,可以不异步工作,直接等待执行完毕既可.
 */
-(NSString *)startExecute;
/**
 进度回调,
 返回的百分比. 0.0---1.0
 此进度回调, 在 编码完一帧后,没有任意queue判断,直接调用这个block;
 比如在:assetWriterPixelBufferInput appendPixelBuffer执行后,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^progressBlock)(CGFloat percent);


/**
 编码完成回调, 完成后返回生成的视频路径;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *dstPath);

//----------一下方法, 内部使用---------------------------
-(id)initWithAudioURL:(NSURL *)srcInput startTimeS:(CGFloat)startS endS:(CGFloat)endS volume:(CGFloat)volume;


/*  *************************举例如下************************************
 
 举例1.
 -(void)testAudioPad
 {
 NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"dy_xialu2" withExtension:@"mp4"];
 AudioPadExecute *audioPad=[[AudioPadExecute alloc] initWithURL:videoURL volume:0.5f onlyAudio:YES];
 
 [audioPad setProgressBlock:^(CGFloat progess) {
 dispatch_async(dispatch_get_main_queue(), ^{
 LSOLog(@"progress  dispatch_get_main_queue  is :%f",progess);
 });
 }];
 
 [audioPad setCompletionBlock:^(NSString *dstPath) {
 
 dispatch_async(dispatch_get_main_queue(), ^{
 [MediaInfo checkFile:dstPath];
 });
 }];
 
 //增加声音
 NSURL *audioURL2 = [[NSBundle mainBundle] URLForResource:@"hongdou10s" withExtension:@"mp3"];
 [audioPad addAudio:audioURL2 volume:0.1];
 [audioPad start];
 }
 
 举例2:
 -(void)testAudioPad
 {
     NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"dy_xialu2" withExtension:@"mp4"];
     NSString *srcVideo=[LSOFileUtil urlToFileString:videoURL];
 
     NSURL *url=[LSOFileUtil filePathToURL:srcVideo];
     AudioPadExecute *audioPad=[[AudioPadExecute alloc] initWithURL:url volume:0];
 
     [audioPad setProgressBlock:^(CGFloat progess) {
     dispatch_async(dispatch_get_main_queue(), ^{
     LSOLog(@"progress  dispatch_get_main_queue  is :%f",progess);
     });
     }];
 
     [audioPad setCompletionBlock:^(NSString *dstPath) {
 
     dispatch_async(dispatch_get_main_queue(), ^{
     LSOLog(@"medaiInfo is:%@",[MediaInfo checkFile:dstPath]);
     });
     }];
     //增加声音
     //    NSURL *audioURL2 = [[NSBundle mainBundle] URLForResource:@"honor30s2" withExtension:@"m4a"];
     //    [audioPad addAudio:audioURL2 volume:0.1];
     [audioPad start];
 }
*/
@end
