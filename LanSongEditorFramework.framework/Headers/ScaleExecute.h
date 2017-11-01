//
//  ScaleExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 29/10/2017.
//  Copyright © 2017 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LanSongFilter.h"
#import "MediaInfo.h"

@interface ScaleExecute : NSObject



/**
 init

 @param path 要缩放的视频完整路径
 @param size 缩放到的大小,
 @param dstPath 缩放后保存到的视频路径, 后缀是mp4或mov
 @return
 */
-(id)initWithPath:(NSString *)path scaleSize:(CGSize)size dstPath:(NSString *)dstPath;


/**
 在开始之前, 可以设置滤镜
 */
-(void)switchFilter:(LanSongFilter *)filter;
/**
 开始执行, 内部会开启VideoProgressQueue. 不可和DrawPad线程同时使用.

 @return 开启成功返回YES, 失败返回NO;
 */
-(BOOL)start;

/**
 TODO 暂时没有测试.
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

@property  CGSize scaleSize;

@property   MediaInfo *videoInfo;
@end

//-----------一下是测试代码.
//ScaleExecute *scale;
//-(void)testScaleExecute
//{
//    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"ping20s" withExtension:@"mp4"];
//    NSString *dstPath=[SDKFileUtil genTmpMp4Path];
//    
//    scale=[[ScaleExecute alloc] initWithPath:[SDKFileUtil urlToFileString:sampleURL]
//                                   scaleSize:CGSizeMake(480, 480) dstPath:dstPath];
//    
//    [scale setVideoProgressBlock:^(CGFloat time){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"当前缩放进度是:%f,百分比是:%f",time,time/scale.videoInfo.vDuration);
//        });
//    }];
//    
//    [scale setCompletionBlock:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"缩放完成..");
//            scale=nil;  //完毕后, 等于nil, 释放内存.
//        });
//    }];
//    [scale start];
//}
