//
//  MyProgram.h
//  LanSongEditorFramework
//
//  Created by sno on 16/12/21.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanSongContext.h"

#import "LanSongFilter.h"



@interface LSOXViewProgram : NSObject

{
    GLint transformMatrixUniform;
    GLint mAlphaPercentUniform ;
    GLint mRedPercentUniform;
    GLint mGreenPercentUniform;
    GLint mBluePercentUniform;
    
    
    /*
     投影矩阵, 负责把移动旋转缩放3D投影到gl窗口上.
     */
    GLint orthographicMatrixUniform;
    LanSongMatrix4x4 orthographicMatrix;
}

/**
 角度值0--360度.
 以视频的原视频角度为旋转对象,等同于CGAffineTransformRotate
 默认为0.0
 */
@property  CGFloat rotateDegree;
/**
 *  用户设置过来的是 以左上角为0,0的,右下角是pad的宽高. 从左到右, 从上到下.
 
 
 */
@property  CGFloat positionX, positionY;

/**
 缩放系数.
 相对于drawpadSize的相对系数.
 */
@property  CGFloat scaleWidth, scaleHeight;


@property CGFloat redPercentValue,greenPercentValue,bluePercentValue,alphaPercentValue;

@property BOOL  isCamFrontMirror; //摄像头图层,前置是否镜像. 如果是前置,则镜像, 如果不是前置, 则不镜像.





-(id)initWithDrawPadSize:(CGSize)size;

-(void)setContext:(LanSongContext *)context;

-(BOOL)loadShader;

-(void)drawCamera:(LanSongFramebuffer *)inputFramebufferToUse inputSize:(CGSize)inputSize mirror:(BOOL)mirror;

-(void)draw:(LanSongFramebuffer *)inputFramebufferToUse inputSize:(CGSize)inputSize;

- (void)drawPicture:(LanSongFramebuffer *)inputFramebufferToUse inputSize:(CGSize)inputSize;

- (void)drawView:(LanSongFramebuffer *)inputFramebufferToUse inputSize:(CGSize)inputSize;

/**
 *  让用户可以直接设置2D  暂时不用, 太麻烦了
 
 - (void)setTransform2D:(CGAffineTransform)newValue;
 
 //让用户可以直接设置3D, 暂时不用,他麻烦了
 - (void)setTransform3D:(CATransform3D)newValue;
 */




@end
