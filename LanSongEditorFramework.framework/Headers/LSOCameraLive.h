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


@class LSOCamLayer;

@interface LSOCameraLive : LSOObject

+(void )setCameraCaptureAsRGBA:(BOOL)is;

/**
 绿幕抠图, 虚拟直播的场景;
 */
-(id)initFullScreen2:(LSOCameraView *)view isFrontCamera:(BOOL)isFront;



/// 容器大小;
@property (nonatomic, readonly) CGSize compSize;

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

/// 获得相机图层;
- (LSOCamLayer *)getCameraLayer;


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


@property (nonatomic,assign) LSOCameraSize cameraSize;


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
 是否绿幕抠图
 */
@property (nonatomic,assign) BOOL isGreenMatting;



/// 增加一个绿色背景的视频/图片
/// 注: 视频最大个数为5个;
/// @param url 视频或图片的url
- (LSOCamLayer *)addGreenFileWithURL:(NSURL *)url;


/// 增加gif
/// @param url gif文件路径
- (LSOCamLayer *)addGifFileWithURL:(NSURL *)url;


/// 删除增加的一个图层;
/// @param layer 图层对象;
-(void)removeLayer:(LSOCamLayer *)layer;


/// 取消前景;
- (void)cancelForeGround;



/// 设置背景,背景可以是图片或视频
/// @param url 图片或视频的url
/// @param audioVolume 如果是视频,可设置音量; 如果是图片则忽略
/// @param handler 完整后的回调;
- (void)setBackGroundUrl:(NSURL *_Nullable)url audioVolume:(float)audioVolume handler:(void (^)(LSOCamLayer *))handler;



/// 取消背景
- (void)cancelBackGround;



/// 获取背景视频的avplayer播放器;
- (AVPlayer *)backGroundAVPlayer;




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
 当前是否在运行;
 */
@property (nonatomic,readonly) BOOL isRunning;

/**
 拍照
 */
-(UIImage *)takePicture;


@property(nonatomic, copy) void(^userSelectedLayerBlock)(LSOCamLayer *layer);

@property (nonatomic, assign) BOOL disableTouchEvent;


@end
NS_ASSUME_NONNULL_END
