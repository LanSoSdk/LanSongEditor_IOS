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
#import "LSOPen.h"


@interface LSOCameraPen : LSOPen <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>


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
 抓拍一张图片
 拍照.
 设置后, 会在下一帧数据到来后,拿到数据,转换为UIImage返回;
 注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....CODEC....
 });
 */
- (void)setSnapShotUIImage:(void (^)(UIImage *))handler;


/**
 把当前camera中的视频数据拉出来.
 输出的格式是nv12;
 注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....CODEC....
 });
 nv12 是内部经过malloc()分配到字节, 使用后,请free(nv12);
 nv12 是内部经过malloc()分配到字节, 使用后,请free(nv12);
 nv12 是内部经过malloc()分配到字节, 使用后,请free(nv12);
 nv12 是内部经过malloc()分配到字节, 使用后,请free(nv12);
 注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
 */
@property(nonatomic, copy) void(^cameraVideoDataOutBlock)(unsigned char *nv12, int width,int height);
/**
 把当前camera中的声音拉出来.
 输出是像素点数组.
 注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....CODEC....
 });
 sample 是内部经过malloc()分配到字节, 使用后,请free(sample);
 sample 是内部经过malloc()分配到字节, 使用后,请free(sample);
 sample 是内部经过malloc()分配到字节, 使用后,请free(sample);
 */
@property(nonatomic, copy) void(^cameraAudioDataOutBlock)(unsigned char *sample, int length);
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
