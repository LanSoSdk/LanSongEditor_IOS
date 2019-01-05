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



@property (nonatomic,readonly) CGSize drawpadSize;
/**
 增加预览窗口
 */
-(void)addLanSongView2:(LanSongView2 *)view;
/**
 开始执行
 */
-(BOOL)startPreview;

-(BOOL)startExport;
/**
 取消
 */
-(void)cancel;


/**
 放进去一段文字;
 
 内部会根据json中每一行的大小来分段.
 
 @param text 文字
 @param start 文字的开始时间
 @param endTime 文字的结束时间;
 */
-(void)pushText:(NSString *)text  startTime:(float)startTime endTime:(float)endTime;

/**
 进度回调,
 此进度回调, 在 编码完一帧后,没有任意queue判断,直接调用这个block;
 比如在:assetWriterPixelBufferInput appendPixelBuffer执行后,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^frameProgressBlock)(BOOL isExport,float percent);
/**
 编码完成回调, 完成后返回生成的视频路径;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^completionBlock)(BOOL isExport,NSString *dstPath);



/**
 当前是否在运行;
 */
@property (nonatomic,readonly) BOOL isRunning;

@property (nonatomic,readonly) BOOL isExporting;
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

-(void)addAudioPath:(NSURL *)path;

@end
NS_ASSUME_NONNULL_END

