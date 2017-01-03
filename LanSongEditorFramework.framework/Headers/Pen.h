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
    kViewPen
};


@protocol PenDelegate <NSObject>

- (void)decodeFrame;

@end

@interface Pen : GPUImageOutput


/**
 *  当前画笔的类型
 */
@property(readwrite, nonatomic) PenTpye penType;

@property BOOL isFrameAvailable;

/**
 *  当前一帧处理完的frameBuffer.
 */
@property GPUImageFramebuffer *frameBufferTarget;


/**
 *VideoPen的图像实际宽高.
 BitmapPen就等于图片原尺寸.
 ViewPen  等于当前view的实际像素尺寸.
 */
@property CGSize frameBufferSize;

/**
 *  在绘制到画板上时的初始尺寸.
   为固定值,不随画笔的形变而变化.
 */
@property CGSize penSize;


/**
 *  当前定义的画板尺寸
 */
@property(readwrite, nonatomic) CGSize drawPadSize;
/**
 *  内部使用
 */
@property(readwrite, nonatomic) id<GPUImageInput> drawpadTarget;

//当前画笔在画板中的ID号,不一定等于画板的层数.inner used
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
 *  旋转角度 0--360度.
 */
@property(readwrite, nonatomic)  CGFloat rotateDegree;
/**
 *  设置或读取当前坐标, 坐标以左上角为0,0
 */
@property(readwrite, nonatomic)  CGFloat positionX, positionY;

/**
 *  缩放因子, 大于1.0为放大, 小于1.0为缩小.
 */
@property(readwrite, nonatomic)  CGFloat scaleWidth,scaleHeight;


/**
 *  内部使用
 */
- (id)initWithDrawPadSize:(CGSize)size drawpadTarget:(id<GPUImageInput>)target penType:(PenTpye) type;

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

- (void)startProcessing;

@end
