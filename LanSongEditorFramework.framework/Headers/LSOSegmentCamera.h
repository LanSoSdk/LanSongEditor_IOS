//
//  LSOModuleCamera.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/9/8.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"
#import "LSOCameraView.h"
#import "LSOSegmentModule.h"
#import "LSOCamLayer.h"



NS_ASSUME_NONNULL_BEGIN

@interface LSOSegmentCamera : LSOObject




+(void )setCameraCaptureAsRGBA:(BOOL)is;

/**
 初始化

 @param view 显示view
 @param isFront 是否设置为前置
 */
-(id)initFullScreen:(LSOCameraView *)view isFrontCamera:(BOOL)isFront  module:(LSOSegmentModule *)module;


@property (nonatomic) CGSize compSize;


@property (nonatomic, readonly) float recordMaxDuration;

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


-(BOOL)startRecord;


-(void)pauseRecord;

/**
 停止录制, 异步停止;
 停止后, 会通过recordCompletionBlock返回得到的视频;
 */
-(void)stopRecordAsync;
/**
 切换前后镜头
 */
- (void)changeCamera;


@property (nonatomic,assign) BOOL recordMic;

/**
 是否是前置相机
 */
@property (readonly, nonatomic) BOOL isFrontCamera;

/**
 打开闪光灯/手电筒
 */
@property (nonatomic,assign) BOOL flashOn;

@property (nonatomic,assign) BOOL disableBackGround;

/**
 获取摄像头图层;
 */
- (LSOCamLayer *)getCameraLayer;

/**
 设置 导出时的模板声音音量
 单位 0---2.0; 1.0为正常. 0.1是减弱; 2.0是增大;
 */
@property (nonatomic,assign) CGFloat exportModuleVolume;

/**
 当前已经录制的时长;
 */
@property (nonatomic, readonly) float recordDuration;

@property(nonatomic, copy) void(^cameraSampleBufferBlock)(CMSampleBufferRef sampleBuffer);

/**
 进度回调,
 当在编码的时候, 等于当前视频图层的视频播放进度 时间单位是秒;;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^recordProgressBlock)(CGFloat currentProgress, float percent);

/**
 录制完成回调;
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^recordCompletionBlock)( NSString *_Nullable dstPath);
/**
 当前是否在运行;
 */
@property (nonatomic,readonly) BOOL isRunning;


@property (nonatomic,readonly) BOOL isRecording;


/**
 在录制的同时, 录制一个UI界面;
 设置为nil,则不录制;
 */
-(BOOL)addUIView:(UIView *)uiView;


@property(nonatomic, copy) unsigned char *_Nullable(^outDataCallBack)(void);

//设置为禁止抠图模式
@property(atomic, assign) BOOL disableSegmentMode;


- (LSOCamLayer *)addForeGroundVideoUrl:(NSURL *)url;


- (void)setSegmentEnable:(BOOL)enable;

/**
 取消;
 */
-(void)cancel;
@end
NS_ASSUME_NONNULL_END


