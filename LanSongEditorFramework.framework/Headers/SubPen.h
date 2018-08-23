//
//  SubPen.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/4/9.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LanSongOutput.h"

/**
 子图层暂时不支持滤镜;
 */
@interface SubPen : NSObject

//-------------------------------------------------

- (id)initWithPenSize:(CGSize)penSize DrawPadSize:(CGSize)size;
-(void)loadParam:(LanSongContext*)context;
/**
 *  内部使用
 */
- (void)draw:(LanSongFramebuffer *)inputFramebufferToUse inputSize:(CGSize)inputSize;
/**
 *  内部使用
 */
- (void)drawDisplay:(LanSongFramebuffer *)inputFramebufferToUse inputSize:(CGSize)inputSize;

@property(readwrite, nonatomic) NSString *tag;

@property(nonatomic, assign,readonly)BOOL isRunning;

@property(readwrite, nonatomic) CGSize penSize;
@property(readwrite, nonatomic) CGSize drawPadSize;

@property(getter=isHidden) BOOL hidden;
/**
 角度值0--360度. 默认为0.0
 */
@property(readwrite, nonatomic)  CGFloat rotateDegree;
/**
 *
 设置或读取  <当前图层的中心点>在容器中的坐标;
 容器坐标的左上角是左上角为0,0. 从上到下 是Y轴, 从左到右是X轴;
 */
@property(readwrite, nonatomic)  CGFloat positionX, positionY;

/**
 *
 缩放因子, 大于1.0为放大, 小于1.0为缩小. 默认是1.0f
 */
@property(readwrite, nonatomic)  CGFloat scaleWidth,scaleHeight;

/**
 直接缩放到的值,
 如果要等于把图片覆盖整个容器, 则值直接等于drawpadSize即可.
 */
@property(readwrite, nonatomic)  CGFloat scaleWidthValue,scaleHeightValue;


/**
 调节当前画面中的RGBA 4个分量的百分比;
 如果你设置了redPercenet=0.8则表示把当前像素中的红色分量降低80%;
 */
@property(readwrite, nonatomic) CGFloat redPercent;
@property(readwrite, nonatomic) CGFloat greenPercent;
@property(readwrite, nonatomic) CGFloat bluePercent;
@property(readwrite, nonatomic) CGFloat alphaPercent;


/**
 同时设置 RGBA的百分比;
 */
-(void) setRGBAPercent:(CGFloat)value;
@end
