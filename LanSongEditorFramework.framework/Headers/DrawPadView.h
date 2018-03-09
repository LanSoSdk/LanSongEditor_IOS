//
//  DrawPadView.h
//  LanSongEditorFramework
//
//  Created by sno on 17/1/7.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanSongContext.h"
#import "LanSongView.h"


@interface DrawPadView : UIView


/**
 获取当前drawpad渲染到的屏幕尺寸;
 (单位像素)
 */
@property(readonly, nonatomic) CGSize sizeInPixels;



+ (const GLfloat *)textureCoordinatesForRotation:(LanSongRotationMode)rotationMode;


-(void)setContext:(LanSongContext *)context;
/**
 内部使用
 */
-(void)buildDrawBuffer;


/**
 内部使用
 */
-(void)remark;

/**
 内部使用
 */
-(void)pushToDisplay;

@end
