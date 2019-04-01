//
//  FFmpegManager.h
//  ZJHVideoProcessing
//
//  Created by ZhangJingHao2345 on 2018/1/29.
//  Copyright © 2018年 ZhangJingHao2345. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface LSOFFmpegManager : NSObject

+ (LSOFFmpegManager *)sharedManager;

/**
 默认命令处理
 
 @param orderStr 处理命令
 */

- (void)defaultHandleFFmpegOrder:(NSString *)orderStr
                       totalTime:(CGFloat)totalTime
                   InitTotalTime:(BOOL)ishasTime
                    processBlock:(void (^)(float process))processBlock
                 completionBlock:(void (^)(NSError *error))completionBlock;


// 设置总时长
+ (void)setDuration:(long long)time;

// 设置当前时间
+ (void)setCurrentTime:(long long)time;

// 转换停止
+ (void)stopRuning;
// 停止
+ (void)stopRuningWithError:(NSString *)errorStr;

@end
