//
//  LSOExtractFrame.h
//  LanSongEditorFramework
//
//  Created by sno on 2017/9/16.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanSongFilter.h"

#import "LSOFileUtil.h"
#import "LSOObject.h"


/**
 提取视频帧;
 */
@interface LSOExtractFrame : LSOObject

/**
 构造函数

 @param videoPath 要解码的视频
 @return 视频正常,则返回当前对象, 其他返回nil
 */
- (id)initWithPath:(NSString *)videoPath;


/**
 开始提取
 内部开启另一个线程, 在另一个queue中执行
 */
- (void)start;

/**
 开始提取, 指定之间
 内部开启另一个线程, 在另一个queue中执行

 @param seektime 指定的时间
 */
- (void)startWithSeek:(CMTime)seektime;

/**
 停止当前操作
 */
- (void)stop;


/**
 每一帧的进度回调.
 UIImage:  当前帧的图片;
 CMTime:  当前帧的时间戳;
 
 注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....XXXXXX....
 });
 */
@property(nonatomic, copy) void(^extractProcessBlock)(UIImage*, CMTime);

/**
 提取完, 工作在内部线程
 注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....XXXXXX....
 });
 */
@property(nonatomic, copy) void(^extractCompletedBlock)(LSOExtractFrame *v);


/**
 一下是测试用例.
 
 LSOExtractFrame *extractFrame;
 int frameCount=0;
 -(void)testFile2
 {
 NSString *assetPath = [[NSBundle mainBundle] pathForResource:@"dy_xialu2" ofType:@"mp4"];
 extractFrame=[[LSOExtractFrame alloc] initWithPath:assetPath];
 if(extractFrame!=nil){
 [extractFrame setExtractProcessBlock:^(UIImage *img, CMTime frameTime) {
 if(img==nil){
 }else{
 }
 LSLog(@"-----time   is :%f",CMTimeGetSeconds(frameTime))
 frameCount++;
 if(frameCount>=50){  //时间到后, 停止;
 dispatch_async(dispatch_get_main_queue(), ^{
 LSLog(@"----停止....")
 [extractFrame stop];
 });
 }
 }];
 [extractFrame setExtractCompletedBlock:^(LSOExtractFrame *v){
 LSOLog(@"执行完成");
 }];
 [extractFrame startWithSeek:CMTimeMake(2, 1)];  //从6秒开始;
 }
 }
 
 */
@end
