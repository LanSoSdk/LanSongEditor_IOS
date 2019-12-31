//
//  FFmpegManager.h
//  ZJHVideoProcessing
//
//  Created by ZhangJingHao2345 on 2018/1/29.
//  Copyright © 2018年 ZhangJingHao2345. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 特定客户使用.
 请不要使用.
 */
@interface LSOFFmpegManager : NSObject

+ (LSOFFmpegManager *)sharedManager;

/**
 默认命令处理
 
 @param orderStr 处理命令
 */

- (void)defaultHandleFFmpegOrder:(NSString *)orderStr
                       totalTime:(CGFloat)totalTime
                   InitTotalTime:(BOOL)isHasTime
                    processBlock:(void (^)(float process))processBlock
                 completionBlock:(void (^)(NSError *error))completionBlock;

- (void)cancelFfmpegRun;
+ (void)cancelFfmpegRun;


// 设置总时长
+ (void)setDuration:(long long)time;

// 设置当前时间
+ (void)setCurrentTime:(long long)time;

// 转换停止
+ (void)stopRuning:(NSInteger)code errorString:(NSString *)errorString;

/**
 设置ffmpeg中的avlog日志的回调. avlog的日志输出级别见下面.
 */
@property (nonatomic, copy) void (^ffmpeglogOutBlock)(NSString *log);

/**
 设置ffmpeg的输出级别, 默认是24,
 ffmpeg中的定义是:

#define AV_LOG_PANIC     0
#define AV_LOG_FATAL     8
#define AV_LOG_ERROR    16
#define AV_LOG_WARNING  24
#define AV_LOG_INFO     32
#define AV_LOG_VERBOSE  40
#define AV_LOG_DEBUG    48
#define AV_LOG_TRACE    56

 @param level 级别, 比如填入24, 则 小于等于24的级别都输出.
 
 设置后, 会通过 ffmpeglogOutBlock 把ffmpeg的所有信息回调给你
 */
+ (void)setFFmpegLogOutLevel:(int)level;

@end
