//
//  CALayerPen.h
//  LanSongEditorFramework
//
//  Created by sno on 17/2/20.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "Pen.h"

@interface CALayerPen : Pen


/**
 内部使用 inner use
 */
@property BOOL isFromUI;


/**
 内部使用.
 */
- (id)initWithLayer:(CALayer *)inputLayer drawpadSize:(CGSize)size drawpadTarget:(id<GPUImageInput>)target;

@end
