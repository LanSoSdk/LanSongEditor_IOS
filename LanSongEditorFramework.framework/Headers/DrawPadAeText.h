//
//  DrawPadAeText.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/11/20.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOOneLineText.h"
#import "VideoPen.h"
#import "ViewPen.h"
#import "Pen.h"
#import "BitmapPen.h"
#import "MVPen.h"
#import "LanSong.h"
#import "LSOAeView.h"
#import "LanSongView2.h"

NS_ASSUME_NONNULL_BEGIN
/**
 */
@interface DrawPadAeText : NSObject


@property (readonly) CGFloat duration;

@property (nonatomic,readonly) CGSize drawpadSize;


/**
 获取当前支持的最大行数;
 */
@property (nonatomic,readonly) int  maxLine;

//总帧数.
@property (nonatomic,readonly) int  totalFrames;

-(id)initAsExecute;
-(id)initAsPreview;


/**
 预览的时候, 有效;
 */
-(void)addLanSongView2:(LanSongView2 *)view;
/**
 LSOOneLineText 类型的素组;
 */
@property (nonatomic,copy)NSArray *textArray;


/**
 每个图层的信息, 有开始帧和结束帧
 */
@property (nonatomic,readonly)NSArray *aeImageLayerArray;
/**
 开始执行
 */
-(BOOL)start;
/**
 取消
 */
-(void)cancel;


/**
 定位到哪一帧;
 */
-(void)seekToFrame:(int)frame;
/**
 播放速度.
 从0.1 到10;
 0.1是放慢10倍; 10则是加快10倍; 1.0是正常;
 */
-(void)setSpeed:(float)speed;
/**
 停止.
 */
-(void)stop;

@property (getter=isPaused) BOOL pause;

/**
 进度回调,
 此进度回调, 在 编码完一帧后,没有任意queue判断,直接调用这个block;
 比如在:assetWriterPixelBufferInput appendPixelBuffer执行后,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^frameProgressBlock)(int frame);



@property(nonatomic, copy) void(^willshowFrameBlock)(int frame);
/**
 编码完成回调, 完成后返回生成的视频路径;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *dstPath);



/**
 当前是否在运行;
 */
@property (nonatomic,readonly) BOOL isRunning;


/**
 增加背景图片
 @param image <#image description#>
 @return <#return value description#>
 */
-(BitmapPen *)addBackgroundImage:(UIImage *)image;
/**
 增加背景视频
 
 @param videoPath 视频路径
 @return
 */
-(VideoPen *)addBackgroundVideo:(NSString *)videoPath;
/**
 增加logo;
 @param image logo图片
 @return 返回图层对象;
 */
-(BitmapPen *)addLogoBitmap:(UIImage *)image;



/**
 把原视频的声音替换掉;
 @param video 原视频
 @param audio 要替换的音频
 */
+(NSString *)addAudioDirectly:(NSString *)video audio:(NSString*)audio;

@end
NS_ASSUME_NONNULL_END

/*
 代码使用;
 
 aeText=[[DrawPadAeText alloc] init];
 __weak typeof(self) weakSelf = self;
 
 NSMutableArray *textArray=[[NSMutableArray alloc] init];
 for (int i=0; i<15; i++) {   //当前最大15行
 LSOOneLineText *text=[[LSOOneLineText alloc] init];
 text.textColor=[UIColor redColor];  //颜色是红色;
 text.text=[NSString stringWithFormat:@"ONE LINE__%d__",i];
 [textArray addObject:text];
 }
 
 aeText.textArray=textArray;
 
 [aeText setProgressBlock:^(CGFloat progess) {
 dispatch_async(dispatch_get_main_queue(), ^{
 [weakSelf drawpadProgress:progess];
 });
 }];
 
 [aeText setCompletionBlock:^(NSString * _Nonnull dstPath) {
 dispatch_async(dispatch_get_main_queue(), ^{
 [weakSelf drawpadCompleted:dstPath];
 });
 }];
 [aeText start];
 }
 -(void)drawpadProgress:(CGFloat) progress
 {
 int percent=(int)(progress*100/aeText.duration);
 LSLog(@"   当前进度 %f,百分比是:%d",progress,percent);
 }
 -(void)drawpadCompleted:(NSString *)path
 {
 VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
 vce.videoPath=path;
 [self.navigationController pushViewController:vce animated:NO];
 }
 
 */
