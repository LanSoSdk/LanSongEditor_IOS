//
//  CameraPen.h
//  LanSongEditorFramework
//
//  Created by sno on 2017/9/6.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "Pen.h"
#import "MyEncoder3.h"


#import "LanSongContext.h"
#import "LanSongOutput.h"
#import "LanSongColorConversion.h"

//Optionally override the YUV to RGB matrices
void setColorConvert601_CameraPen( GLfloat conversionMatrix[9] );
void setColorConvert601FullRange_CameraPen( GLfloat conversionMatrix[9] );
void setColorConvert709_CameraPen( GLfloat conversionMatrix[9] );


//Delegate Protocal for Face Detection.

///**
// 摄像头视频输出的回调, 拿到原画面后,可以把数据拉出去.
// */
@protocol CameraPenDelegate <NSObject>

@optional
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;
@end


/**
 A LanSongOutput that provides frames from either camera
 */
@interface CameraPen : Pen <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>
{
    NSUInteger numberOfFramesCaptured;
    CGFloat totalFrameTimeDuringCapture;
    
    AVCaptureSession *_captureSession;
    //采集的设备,有input和output.
    AVCaptureDevice *_inputCamera;//
    AVCaptureDevice *_microphone;
    
    AVCaptureDeviceInput *videoInput;
    AVCaptureVideoDataOutput *videoOutput;
    
    BOOL capturePaused;  //停止画面输出, 就是在回调中,直接返回.
    
    /*
     outputRotation: 下发到target中的角度.
     internalRotation: 当画面设置后, 需要在yuv2RGB的时候, 旋转角度.
     */
    LanSongRotationMode outputRotation, internalRotation;
    dispatch_semaphore_t frameRenderingSemaphore;
    
    BOOL captureAsYUV;
    GLuint luminanceTexture, chrominanceTexture;
    
    __unsafe_unretained id<CameraPenDelegate> _delegate;
}

/// Whether or not the underlying AVCaptureSession is running
@property(readonly, nonatomic) BOOL isRunning;

@property(readonly, retain, nonatomic) AVCaptureSession *captureSession;

@property (readwrite, nonatomic, copy) NSString *captureSessionPreset;

@property (readwrite) int32_t frameRate;

/// Easy way to tell which cameras are present on device
@property (readonly, getter = isFrontFacingCameraPresent) BOOL frontFacingCameraPresent;
@property (readonly, getter = isBackFacingCameraPresent) BOOL backFacingCameraPresent;


/// Use this property to manage camera settings. Focus point, exposure point, etc.
@property(readonly) AVCaptureDevice *inputCamera;

@property(readwrite, nonatomic) UIInterfaceOrientation outputImageOrientation;

@property(readwrite, nonatomic) BOOL horizontallyMirrorFrontFacingCamera, horizontallyMirrorRearFacingCamera;

@property(nonatomic, assign) id<CameraPenDelegate> delegate;

/**
 内部使用
 */
- (id)init:(NSString *)sessionPreset position:(AVCaptureDevicePosition)pos drawpadSize:(CGSize)size drawpadTarget:(id<LanSongInput>)target;

- (BOOL)addAudioInputsAndOutputs;

- (BOOL)removeAudioInputsAndOutputs;

- (void)removeInputsAndOutputs;

- (void)startCameraCapture;
- (void)stopCameraCapture;

- (void)pauseCameraCapture;

- (void)resumeCameraCapture;

- (void)processAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (AVCaptureDevicePosition)cameraPosition;

- (AVCaptureConnection *)videoCaptureConnection;

- (void)rotateCamera;

- (CGFloat)averageFrameDurationDuringCapture;


- (void)setAudioEncoderTarget:(MyEncoder3 *)newValue;

+ (BOOL)isBackFacingCameraPresent;
+ (BOOL)isFrontFacingCameraPresent;

//-------lanso++

@end
