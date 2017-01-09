//
//  ViewPen.h
//  LanSongEditorFramework
//
//  Created by sno on 16/12/24.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pen.h"


@interface ViewPen : Pen

/**
 内部使用 inner use
 */
@property BOOL isFromUI;

- (id)initWithView:(UIView *)inputView drawpadSize:(CGSize)size drawpadTarget:(id<GPUImageInput>)target;
- (id)initWithLayer:(CALayer *)inputLayer drawpadSize:(CGSize)size drawpadTarget:(id<GPUImageInput>)target;

- (CGSize)layerSizeInPixels;

- (void)updateUsingCurrentTime;

- (void)updateWithTimestamp:(CMTime)frameTime;


@end
