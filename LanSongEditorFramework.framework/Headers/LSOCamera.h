//
//  LSOCamera.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/9/8.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"
#import "LSOCameraView.h"

NS_ASSUME_NONNULL_BEGIN

//录制的视频段;
@interface LSORecordFile: NSObject

@property (assign, nonatomic) CGFloat duration;
@property (strong, nonatomic) NSString *videoPath;
@property (strong, nonatomic) NSString *audioPath;
@end

@interface LSOCamera : LSOObject

/**
 初始化

 @param view 显示view
 @param isFront 是否设置为前置
 */
-(id)initFullScreen:(LSOCameraView *)view isFrontCamera:(BOOL)isFront;

/**
 录制最大时长. 在init后设置;
 */
@property (nonatomic, assign) float recordMaxDuration;

/**
 当前已经录制的时长;
 */
@property (nonatomic,readonly)    CGFloat  recordDuration;


/**
 录制的几段视频;
 只读使用,请勿写入文件
 */
@property (nonatomic, readonly)NSMutableArray<LSORecordFile *> *recordArray;


/**
 录像大小;
 */
@property (nonatomic, readonly) CGSize cameraSize;

/**
 开始执行
 这个只是预览, 开始后,不会编码, 不会有完成回调
 @return 执行成功返回YES, 失败返回NO;
 */
-(BOOL)startPreview;

/**
 停止预览
 */
-(void)stopPreview;

/**
 设置录制的码率
 在startRecord前调用;
 */
-(void)setRecordBitrate:(int)bitrate;


/**
 开始录制
 */
-(BOOL)startRecord;

/**
 暂停录制
 */
-(void)pauseRecord;

/**
 停止录制, 异步停止;
 */
-(BOOL)stopRecordAsync;

/**
 删除上一段
 */
-(BOOL)deleteLastRecord;
/**
 切换前后镜头
 */
- (void)changeCamera;
/**
 是否是前置相机
 */
@property (readonly, nonatomic) BOOL isFrontCamera;

/**
 打开闪光灯/手电筒
 */
@property (nonatomic,assign) BOOL flashOn;


/**
 录制mic;
默认是录制mic; 当有外音或前景视频声音时, 禁止录制外音;
 */
@property (nonatomic,assign) BOOL recordMic;

/**
 设置美颜,
 范围是0.0---1.0; 0.0是关闭美颜; 默认是0.0;
 */
@property (readwrite,nonatomic) CGFloat beautyLevel;

/**
设置一个滤镜, 设置后, 之前增加的滤镜将全面清空.
类似滤镜一个一个的切换.新设置一个, 会覆盖上一个滤镜.
如果滤镜是无, 或清除之前的滤镜, 这里填nil;
*/
@property (nonatomic,nullable, copy)LanSongFilter  *filter;

/**
 
 增加一个滤镜,  如果你只需要切换一个滤镜,则用上面的filter;
 增加后, 会在上一个滤镜的后面增加一个新的滤镜.
 是级联的效果
 源图像--->滤镜1--->滤镜2--->滤镜3--->移动旋转缩放透明遮罩处理--->与别的图层做混合;
 */
-(void)addFilter:(nullable LanSongFilter *)filter;

/**
 删除一个滤镜;
 */
-(void)removeFilter:(nullable LanSongFilter *)filter;
/**
 删除所有滤镜;
 */
-(void)removeAllFilter;



/**
 从ios的Camera回调拿到的相机实时图像;
 
 使用举例:
 [drawPadCamera.cameraPen setCameraSampleBufferBlock:^(CMSampleBufferRef sampleBuffer) {
 
 
 CVImageBufferRef cameraFrame = CMSampleBufferGetImageBuffer(sampleBuffer);
 int bufferWidth = (int) CVPixelBufferGetWidth(cameraFrame);
 int bufferHeight = (int) CVPixelBufferGetHeight(cameraFrame);
 LSOLog(@"cameraFrame---:%@, width:%d, height:%d",cameraFrame,bufferWidth,bufferHeight);
 
 }];
 
内部代码如下: captureOutput是AVCaptureOutput的代理回调;
  - (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
 {
     //if(isVideoSample){
            CFRetain(sampleBuffer);  //计数加一
            异步进入我们的线程{ (我们线程是一个queue,你也可以跳出我们的线程)
                cameraSampleBufferBlock(sampleBuffer);  //<------调用设置的回调
                 [self processVideoSampleBuffer:sampleBuffer]; <-----我们自己的处理;
                CFRelease(sampleBuffer);  //计数减一;
            }
      }
 }
 */
@property(nonatomic, copy) void(^cameraSampleBufferBlock)(CMSampleBufferRef sampleBuffer);

/**
 进度回调,
 当在编码的时候, 等于当前视频图层的视频播放进度 时间单位是秒;;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^recordProgressBlock)(CGFloat totalProgress, CGFloat currentProgress);

/**
 录制完成回调;
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^recordCompletionBlock)( NSString *_Nullable dstPath);


@property(nonatomic, copy) NSString *_Nullable(^concatFunctionBlock)(NSMutableArray *array);
/**
 适配ios13  必须按照demo中的设置;
 */
@property(nonatomic, copy) NSString *_Nullable(^mergeAVBlock)(NSString *video, NSString *audio);
/**
 当前是否在运行;
 */
@property (nonatomic,readonly) BOOL isRunning;

/**
 是否在录制中;
 */
@property (nonatomic,readonly) BOOL isRecording;


/**
 在录制的同时, 录制一个UI界面;
 设置为nil,则不录制;
 */
-(BOOL)addUIView:(UIView *)uiView;

/**
 设置前景视频
 在开始录制前设置;
 */
- (BOOL)setForeGroundVideoWithColorUrl:(NSURL *_Nullable)colorUrl maskUrl:(NSURL *_Nullable) maskUrl;

/**
 设置前景图片;
 */
- (BOOL) setForeGroundImageWithUrl:(NSURL *_Nullable)url;

/**
 设置音乐;
 */
- (BOOL)setMusicWithUrl:(NSURL *)url;

/**
 拍照
 */
-(UIImage *)takePicture;

@end
NS_ASSUME_NONNULL_END
