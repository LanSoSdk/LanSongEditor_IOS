//
//  LSOVideoLayout.h
//
//  Created by sno on 2019/5/23.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOLayoutParam.h"

NS_ASSUME_NONNULL_BEGIN

/**
 多个视频或图片, 拼图
 可以给每个图片或视频设置位置, 设置缩放大小.
 比如您设置最终生成的视频大小是720x720; 上面放3个视频, 第一个视频放在0,0
 */
@interface LSOVideoLayout : NSObject

/**
 进度回调,
 
 percent 百分比, 是一个整数.
 此进度回调, 没有任意queue判断,直接调用这个block;
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });

 */
@property(nonatomic, copy) void(^progressBlock)(int percent);
/**
 编码完成回调, 完成后返回生成的视频路径;
 工作在其他线程, 执行成功返回视频路径, 失败返回nil;
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy,nullable) void(^completionBlock)(NSString *dstPath);
/**
 两个图像的叠加

 @param outW 输出视频的宽度
 @param outH 输出视频的宽度
 @param p1 第一个图像的参数
 @param p2 第二个图像的参数
 @return 开始执行返回YES;
 */
-(BOOL)startLayout2Video:(int)outW height:(int)outH params1:(LSOLayoutParam *)p1 params2:(LSOLayoutParam *)p2;

/**
 3个图像叠加
 */
-(BOOL)startLayout3Video:(int)outW height:(int)outH params1:(LSOLayoutParam *)p1 params2:(LSOLayoutParam *)p2 params3:(LSOLayoutParam *)p3;
/**
 4个图像叠加
 */
-(BOOL)startLayout4Video:(int)outW height:(int)outH params1:(LSOLayoutParam *)p1 params2:(LSOLayoutParam *)p2 params3:(LSOLayoutParam *)p3 params4:(LSOLayoutParam *)p4;
/**
 5个图像叠加
 */
-(BOOL)startLayout5Video:(int)outW height:(int)outH params1:(LSOLayoutParam *)p1 params2:(LSOLayoutParam *)p2 params3:(LSOLayoutParam *)p3 params4:(LSOLayoutParam *)p4
                 params5:(LSOLayoutParam *)p5;

/**
 6个图像叠加
 */
-(BOOL)startLayout6Video:(int)outW height:(int)outH params1:(LSOLayoutParam *)p1 params2:(LSOLayoutParam *)p2 params3:(LSOLayoutParam *)p3 params4:(LSOLayoutParam *)p4
                 params5:(LSOLayoutParam *)p5 params6:(LSOLayoutParam *)p6;

@end

NS_ASSUME_NONNULL_END
/*
 代码举例(demo)
 
 
 LSOVideoLayout *videolayout=[[LSOVideoLayout alloc] init];
 
 LSOLayoutParam *param1=[[LSOLayoutParam alloc] initWithURL:[LSOXFFmpegFileUtil URLForResource:@"d2" withExtension:@"jpg"]];
 param1.scaleW=1080;
 param1.scaleH=1920;
 
 param1.x=0;
 param1.y=0;
 
 LSOLayoutParam *param2=[[LSOLayoutParam alloc] initWithURL:[LSOXFFmpegFileUtil URLForResource:@"h4OnePlus" withExtension:@"mp4"]];
 param2.scaleH=480;
 param2.scaleW=540;
 param2.x=0;
 param2.y=480;
 
 
 LSOLayoutParam *param3=[[LSOLayoutParam alloc] initWithURL:[LSOXFFmpegFileUtil URLForResource:@"iphoneX1080P" withExtension:@"mov"]];
 param3.x=500;
 param3.y=500;
 
 
 
 [videolayout setProgressBlock:^(int percent) {
 LSOLog(@"----percent is :%d",percent);
 }];
 WS(weakSelf)
 [videolayout setCompletionBlock:^(NSString *dstPath) {
 dispatch_async(dispatch_get_main_queue(), ^{
    [DemoUtils startVideoPlayerVC:weakSelf.navigationController dstPath:dstPath];
 });
 }];
 [videolayout startLayout3Video:720 height:1280 params1:param1 params2:param2 params3:param3];
 */
