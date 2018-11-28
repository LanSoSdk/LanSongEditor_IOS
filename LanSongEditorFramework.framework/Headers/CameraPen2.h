//
//  CameraPen2.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/8/20.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "LanSongContext.h"
#import "LanSongOutput.h"
#import "LanSongColorConversion.h"
#import "Pen.h"


@interface CameraPen2 : Pen <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>


/**
 是否在运行;
 */
@property(readonly, nonatomic) BOOL isRunning;
/**
 当前采集回话类.
 你可以拿到这个回话, 来做:
 [_captureSession beginConfiguration];
xxxxx的设置.
 [_captureSession commitConfiguration];
 */
@property(readonly, retain, nonatomic) AVCaptureSession *captureSession;


/**
 当前Camera的分辨率设置.
 我们默认前置是720P;后置是1080P
 */
@property (readwrite, nonatomic, copy) NSString *captureSessionPreset;


/**
 帧率;
 设置或读取当前AVCamera的帧率
 */
@property (readwrite) int32_t frameRate;


/**
 在录制的时候, 禁止声音;
 在DrawPadCameraPreview的 startPreview前调用
 */
@property (getter=isDisableAudio) BOOL disableAudio;

/**
 查看当前摄像机图层是否是前置或后置;
 */
@property (readonly, getter = isFrontFacingCameraPresent) BOOL frontFacingCameraPresent;
@property (readonly, getter = isBackFacingCameraPresent) BOOL backFacingCameraPresent;


/**
 获取当前采集设备.
 */
@property(readonly) AVCaptureDevice *inputCamera;


/**
 设置AVCamera输入到容器中的图像角度;
 [不建议使用]
 */
@property(readwrite, nonatomic) UIInterfaceOrientation outputImageOrientation;


/**
 当是前置的时候, 水平是否镜像;
 */
@property(readwrite, nonatomic) BOOL horizontallyMirrorFrontFacingCamera, horizontallyMirrorRearFacingCamera;

/**
 前后镜头切换
 */
- (void)rotateCamera;

/**
 当前ios设备是否支持前后置
 */
+ (BOOL)isBackFacingCameraPresent;
+ (BOOL)isFrontFacingCameraPresent;



/**************************一下内部使用****************************************************/
- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition padSize:(CGSize)size;
- (BOOL)addAudioInputsAndOutputs;
- (BOOL)removeAudioInputsAndOutputs;
- (void)removeInputsAndOutputs;
- (void)startCameraCapture;
- (void)stopCameraCapture;
- (void)pauseCameraCapture;
- (void)resumeCameraCapture;
- (void)processVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)processAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (AVCaptureDevicePosition)cameraPosition;
- (AVCaptureConnection *)videoCaptureConnection;
@end
