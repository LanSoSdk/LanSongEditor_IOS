#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "GPUImageContext.h"
#import "GPUImageOutput.h"
#import "GPUImageColorConversion.h"
#import "Pen.h"



/**
摄像头图层, 可作为一个图层放到画板上.继承自Pen, 具有Pen的移动旋转缩放滤镜等特性.
 
 2017 3月11日, 当前不建议使用这个类.
 */
@interface CameraPen : Pen <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>



/**
  是否在工作
 */
@property(readonly, nonatomic) BOOL isRunning;


/**
 引出
 */
@property(readonly, retain, nonatomic) AVCaptureSession *captureSession;


/**
 设置或获取 初始化的分辨率.
 */
@property (readwrite, nonatomic, copy) NSString *captureSessionPreset;

/**
 帧率,默认是为0; 即系统默认帧率.
 */
@property (readwrite) int32_t frameRate;


/**
 前后置摄像头是否可用.
 */
@property (readonly, getter = isFrontFacingCameraPresent) BOOL frontFacingCameraPresent;
@property (readonly, getter = isBackFacingCameraPresent) BOOL backFacingCameraPresent;

/**
 引出 AVCaptureDevice对象.
 */
@property(readonly) AVCaptureDevice *inputCamera;


/**
 当前手机屏幕是横屏还是竖屏
 竖屏则设置为: UIInterfaceOrientationPortrait
 横屏:UIInterfaceOrientationLandscapeLeft
 */
@property(readwrite, nonatomic) UIInterfaceOrientation outputImageOrientation;


/**
 前置摄像头是否镜像.
 */
@property(readwrite, nonatomic) BOOL horizontallyMirrorFrontFacingCamera;

/**
 后置摄像头是否镜像
 */
@property(readwrite, nonatomic) BOOL horizontallyMirrorRearFacingCamera;




/**
 内部使用.
 */
- (id)init:(NSString *)sessionPreset position:(AVCaptureDevicePosition)pos drawpadSize:(CGSize)size drawpadTarget:(id<GPUImageInput>)target;


- (BOOL)addAudioInputsAndOutputs;

/*
 
 */
- (BOOL)removeAudioInputsAndOutputs;

/*
 
 */
- (void)removeInputsAndOutputs;



/** 
 开始摄像头采集. 不建议外面调用
 */
- (void)startCameraCapture;

/*
 停止采集, 一般外面无需调用
 */
- (void)stopCameraCapture;


/*
 得到当前Camera的是前置还是后置.
 */
- (AVCaptureDevicePosition)cameraPosition;

/*
 得到 AVCaptureConnection 对象
 */
- (AVCaptureConnection *)videoCaptureConnection;
/**
 切换前后摄像头 调用后, 如果当前
 */
- (void)rotateCamera;


+ (BOOL)isBackFacingCameraPresent;

+ (BOOL)isFrontFacingCameraPresent;

@end
