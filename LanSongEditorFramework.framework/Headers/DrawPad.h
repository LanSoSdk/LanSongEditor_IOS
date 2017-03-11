//
//  DrawPad.h
//  LanSongEditorFramework
//
//  Created by sno on 16/12/28.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GPUImage.h"
#import "VideoPen.h"
#import "BitmapPen.h"
#import "ViewPen.h"
#import "CameraPen.h"
#import "MVPen.h"
#import "CALayerPen.h"
#import "DataPen.h"



typedef NS_ENUM(NSUInteger, DrawPadUpdateMode) {
    //当所有的pen准备好时,刷新,默认采用这个刷新模式; 当有主视频图层时,自动设置为这种模式
    kPenReadyUpdate,
    
    //自动定时器刷新; 适用于照片影集,摄像头等没有视频图层的场合.
    kAutoTimerUpdate,
};
/**
 *  这个类是仅用作DrawPadView和 DrawPadExecute的父类使用, 不可独立创建对象,
 内部使用.
 */
@interface DrawPad : NSObject

/**
 *    DrawPad执行完成后的回调.
 
 注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....CODEC....
 });
 */
@property(nonatomic, copy) void(^onCompletionBlock)(void);

/**
 *     DrawPad执行过程中的进度对调.
 
 注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....CODEC....
 });
 */
@property(nonatomic, copy) void(^onProgressBlock)(CGFloat);

/**
 *  drawPad的高度和宽度.注意:这里是像素值, 不是屏幕点,如果您使用, 要根据layer.contentScale来得到屏幕点.
 */
@property CGFloat drawPadWidth;
@property CGFloat drawPadHeight;

@property CGSize  drawpadSize;

/**
 是否前台播放. 内部使用.
 */
@property BOOL isForeGround;

//当前画板 DrawPad是否在工作.
@property  BOOL isWorking;
/**
 *   初始化画板
 *
 *  @param padWidth  画板宽度
 *  @param padHeight 画板高度
 *  @param bitrate   画板在编码时的码率
 *  @param dstPath   画板编码后保持的绝对路径
 *
 *  @return
 */
- (id)initWithWidth:(CGFloat)padWidth height:(CGFloat)padHeight bitrate:(int)bitrate dstPath:(NSString *)dstPath;
/**
 *  增加主视频, 如果有主视频,则以主视频的时间为准,
 *
 *   1.如果设置了主视频,则音频部分,自动用主视频的音频作为目标视频中的音频部分.
 *
 *  @param videoPath 文件的绝对路径
 *  @param filter    可以给视频增加一个GPUImageFilter的滤镜
 *
 *  @return
 */
-(VideoPen *)addMainVideoPen:(NSString *)videoPath filter:(GPUImageFilter *)filter;

/**
 *  增加视频图层
 *
 *  @param videoPath 文件的绝对路径
 *  @param filter    滤镜, 不增加设置为nil
 *
 *  @return
 */
-(VideoPen *)addVideoPen:(NSString *)videoPath filter:(GPUImageFilter *)filter;



/**
 向画板中增加一个MV图层, 以用来显示MV效果.

 @param colorPath mv视频的彩色视频
 @param maskPath  mv视频中的黑白视频
 @param filter  可以给mv效果设置一个滤镜,如果不需要,设置为null
 @return  返回MV图层对象.
 */
-(MVPen *)addMVPen:(NSString *)colorPath  maskPath:(NSString *)maskPath filter:(GPUImageFilter *)filter;



/**
 *  增加图片图层
 *
 *  @param inputImage
 *
 *  @return
 */
-(BitmapPen *)addBitmapPen:(UIImage *)inputImage;

/**
 *  增加 UI图层
 *
 *  @param view   大小,尽量等于画板的大小.
 *  @param fromUI 这个view是否属于UI界面的一部分, 如果是属于UI的一部分,则画板在渲染的时候, 不会再次渲染到预览画面上
 *
 *  @return
 */
-(ViewPen *)addViewPen:(UIView *)view fromUI:(BOOL)fromUI;


/**
 向DrawPad中增加一个CALayer
 注意, 因IOS的UI是采用[点]的概念, 而我们的DrawPad里是[像素], 像素和点呈现在屏幕上是有偏差的, 
 因增加到DrawPad后的CALayer,也会显示到屏幕上, 作为预览使用. 建议您不要再增加到屏幕上,

 @param inputLayer 创建好的CALayer对象.
 @param fromUI 是否来自UI, 建议设置为NO,即增加到DrawPad上的calayer不要再增加到其他UIView中.
 @return 图层对象
 */
-(CALayerPen *)addCALayerPenWithLayer:(CALayer *)inputLayer fromUI:(BOOL)fromUI;



/**
 增加摄像头图层
 
 @param sessionPreset 预览分辨率, 建议是:AVCaptureSessionPreset640x480
 @param cameraPosition 如使用前置摄像头,则为AVCaptureDevicePositionFront; 后置则是: AVCaptureDevicePositionBack;
 
 @return
 */
-(CameraPen *)addCameraPen:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition;
/**
 *  删除一个图层
 */
-(void)removePen:(Pen *)pen;
/**
 *  为前台画板增加一个预览view界面
 *
 *  @param preview
 */
-(void) setDrawPadPreView:(UIView *)preview;

/**
 *  获取画板的宽度
 */
-(CGFloat)getDrawPadWidth;

/**
 *  获取画板的高度.
 */
-(CGFloat)getDrawPadHeight;

/**
 *  设置刷新模式
 *
 *  注意:一定需要在 startDrawPad之前使用.
 *
 *  @param mode 模式
 *  @param fps  当是自动刷新时使用的帧率, 如是PenReady模式,则这里不起作用.
 */
-(void)setUpdateMode:(DrawPadUpdateMode)mode autoFps:(CGFloat)fps;
/**
 *  开始执行.
 */
-(void)startDrawPad;
/**
 *  停止工作
 */
-(void)stopDrawPad;

/**
 *  设置图层的背景颜色, 默认是黑色,
 *
 *  @param redComponent   红色, 值0.0f---1.0f
 *  @param greenComponent 绿色 值0.0f---1.0f
 *  @param blueComponent  蓝色 值0.0f---1.0f
 *  @param alphaComponent 透明度 值0.0f---1.0f
 */
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;

@end
