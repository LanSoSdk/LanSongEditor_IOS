//
//  PenEnd.h
//  LanSongEditorFramework
//
//  Created by sno on 17/8/11.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LanSongContext.h"
#include "Pen.h"

@interface PenEnd : NSObject <LanSongInput>
{
    
}
@property  BOOL isFrameAvailable;

@property LanSongFramebuffer *frameBufferTarget;


/**
 当前正在处理的帧的画面的大小尺寸,默认等于画面原来的大小,比如等于视频的实际宽高,等于图片的实际宽高.
 缩放是以这个尺寸进行操作的. 如果你要实时获取当前图层的尺寸,并调整他们的宽高,则可以用这个尺寸来调整.
 很多场合基本等于画面原始的大小.
 
 注意:每次是在视频处理完一帧后得到当前帧的frameSize
 */
@property CGSize frameBufferSize;


@property CMTime currentPTS;

@property LanSongRotationMode inputRotation;

-(id)init;

@end
