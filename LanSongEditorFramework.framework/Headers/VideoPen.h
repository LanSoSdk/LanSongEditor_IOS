//
//  VideoPen.h
//  LanSongEditorFramework
//
//  Created by sno on 16/12/19.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GPUImageMovie.h"
#import "GPUImageFilter.h"
#import "GPUImageOutput.h"


@interface VideoPen : NSObject

@property CGFloat videoWidth;
@property CGFloat videoHeight;

/**
 *  drawPad架构内部使用, 外界不许调用
 */
-(id)initWithPath:(NSString *)videoPath filter:(GPUImageFilter *)filter;

/**
 *  drawPad架构内部使用, 外界不许调用
 */
-(void)prepare:(BOOL)speed encoder:(GPUImageMovieWriter *)movieWriter;
/**
 *  drawPad架构内部使用, 外界不许调用
 */
-(void)start;

/**
 *  drawPad架构内部使用, 外界不许调用
 */
-(GPUImageOutput *)getTarget;



-(void)setRotate:(CGFloat)angle;

-(void)setPosition:(CGFloat)posX posY:(CGFloat)posY;

-(void)setScale:(CGFloat)scaleX scaleY:(CGFloat)scaleY;

@end
