//
//  Pen.h
//  LanSongEditorFramework
//
//  Created by sno on 16/12/21.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GPUImageContext.h"
#import "GPUImageOutput.h"
#import "GPUImageFilter.h"



typedef NS_ENUM(NSUInteger, PenTpye) {
    kVideoPen,
    kBitmapPen,
    kViewPen,
    kCameraPen,
    kMVPen,
    kCALayerPen,
    kDataPen
};


/**
 提示1:   ios版本的GPUImage功能很强大, 为了滤镜部分和它兼容, 我们的图层继承自GPUImage中的GPUImageOutput,
         您可以直接使用GPUImage的滤镜效果,并支持GPUImage的各种扩展效果.
         与GPUImageOutput的区别是: GPUImageOutput只能做滤镜功能, 而我们是整个视频编辑SDK.
 
 提示2:  因为图层的的单词是Layer, 而'Layer'单词被IOS的UI使用了, 为了不使您代码中的对象命名混乱,
        我们用Pen这个单词作为图层的父类, 只是单词变化了,和Android版本的一样是图层的意思, 一样每个图层均支持移动缩放旋转滤镜等特性
 
 */
@interface Pen : GPUImageOutput
{
      NSObject *framebufferLock;  //数据的同步锁.
}

/**
 *  当前图层的类型
 */
@property(readwrite, nonatomic) PenTpye penType;

@property BOOL isFrameAvailable;

/**
 *  当前一帧处理完的frameBuffer.
 */
@property GPUImageFramebuffer *frameBufferTarget;


/**
 当前正在处理的帧的画面的大小尺寸,默认等于画面原来的大小,比如等于视频的实际宽高,等于图片的实际宽高.
 缩放是以这个尺寸进行操作的. 如果你要实时获取当前图层的尺寸,并调整他们的宽高,则可以用这个尺寸来调整.
 很多场合基本等于画面原始的大小.
 
 注意:每次是在视频处理完一帧后得到当前帧的frameSize
 */
@property CGSize frameBufferSize;

/**
 *  在绘制到画板上时的初始尺寸.   为固定值,不随图层的缩放变化而变化.
    如果你要获取当前画面的实时尺寸,则可以通过上面的frameBufferSize这个属性来获取. 缩放也是基于frameBufferSize进行的.
    
    此尺寸可以作为移动的参考.
 
 
  当前绘制原理是:ViewPen是等比例缩放到画板上, BitmapPen和ViewPen和CALayerPen, 则是1:1渲染到画板上.
 
   举例:视频是1280x720的视频, 画板尺寸是480x480,则增加到画板上后, 会自动缩放视频的尺寸,
      如果是横屏, 则视频的宽度被缩放成480, 高度被缩放成 480 x(视频的宽高比720/1280)=270; 则这里penSize的宽高是480x270,从而保证视频的宽高比一直.
      如果是竖屏, 则视频的高度被缩放到480, 宽度被缩放成 270, ....
 
 注意:后期会增加一些类似ImageView中的contentMode;其他各种缩放模式.
 */
@property CGSize penSize;


/**
 *  定义的画板尺寸
 */
@property(readwrite, nonatomic) CGSize drawPadSize;

/**
 内部使用.
 当前图层在画板中的ID号,不一定等于画板的层数.inner used
 */
@property int  idInDrawPad;

/**
 *  当前时间戳
 可通过这样换算成秒:CGFloat frameTimeDifference = CMTimeGetSeconds(currentPTS)
 */
@property CMTime currentPTS;
/**
 *  内部使用
 */
@property GPUImageRotationMode inputRotation;


/**
 当前图层是否隐藏, 
 可以用这个在新创建的图层做隐藏/显示的效果, 类似闪烁, 或创建好,暂时不显示等效果.
 */
@property(getter=isHidden) BOOL hidden;
/**
 角度值0--360度. 默认为0.0
 以视频的原视频角度为旋转对象,
 基本等同于CGAffineTransformRotate
 */
@property(readwrite, nonatomic)  CGFloat rotateDegree;
/**
 *  
 设置或读取当前画面的中心点的坐标像素值, 左上角为0,0.
 默认是中心点, 即:positionX=drawPadSize.width/2;
               positionY=drawPadSize.height/2;
 
 注意:这里的XY是画面中心点的坐标, 不是画面左上角!.
 
 */
@property(readwrite, nonatomic)  CGFloat positionX, positionY;

/**
 *  
 缩放因子, 大于1.0为放大, 小于1.0为缩小. 默认是1.0f
 此缩放是以增加到DrawPad中的frameBufferSize来做为基数, 放大或缩小
 基本等同于.CGAffineTransformScale
 
 注意: 此缩放, 是针对正要渲染的Pen进行缩放, 不会更改frameBufferSize和penSize.
 */
@property(readwrite, nonatomic)  CGFloat scaleWidth,scaleHeight;

/**
 *  内部使用
 */
- (id)initWithDrawPadSize:(CGSize)size drawpadTarget:(id<GPUImageInput>)target penType:(PenTpye) type;


/**
 内部使用.
 */
-(void)releasePen;
/**
 *  内部使用
 */
-(BOOL)decodeOneFrame;

/**
 *  内部使用
 */
-(void)loadParam:(GPUImageContext*)context;
/**
 *  内部使用
 */
-(void)loadShader;
/**
 *  内部使用
 */
- (void)draw;
/**
 *  内部使用
 */
- (void)drawDisplay;

/**
 *  切换滤镜, 默认是没有滤镜. 
    因为IOS端的GPUImage开源库很强大, 这里完全兼容GPUImage的库,您也可以根据自己的情况扩展GPUImage相关的效果.
 *
 *  @param filter 滤镜对象.
 */
-(void)switchFilter:(GPUImageOutput<GPUImageInput> *)filter;

- (void)startProcessing:(BOOL)isAutoMode;

-(void)endProcessing;

@end
