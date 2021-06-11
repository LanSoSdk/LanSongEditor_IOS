//
//  AudioConcatExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/1/19.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LanSongLog.h"



/**
 多个音频拼接.
 拼接后, 输出m4a格式的音频文件.
 音频的采样率以第一个音频的采样率为准;
 */
@interface AudioConcatExecute : NSObject


/**
 增加一个声音
 [多次调用,先调用的音频放在前面拼接.]
 @param audio 音频文件或含有音频的视频文件
 @return
 */
-(BOOL)addAudio:(NSURL *)audio;
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
 开始(阻塞执行)
 只有执行完毕后,才返回;
 使用在比如15s左右的音频,处理很快,可以不异步工作,直接等待执行完毕既可.
 */
-(NSString *)startExecute;
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
  NSURL *inputVideo1 = [[NSBundle mainBundle] URLForResource:@"dy_xialu2" withExtension:@"mp4"];
 NSURL *inputVideo2 = [[NSBundle mainBundle] URLForResource:@"aobama" withExtension:@"mp4"];
 
 audioConcat=[[AudioConcatExecute alloc] init];
 [audioConcat addAudio:inputVideo1];
 [audioConcat addAudio:inputVideo2];
 NSString *path=[audioConcat startExecute];
 [MediaInfo checkFile:path];
 */
@end
