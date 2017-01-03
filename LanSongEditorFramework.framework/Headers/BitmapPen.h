//
//  PicturePen.h
//  LanSongEditorFramework
//
//  Created by sno on 16/12/24.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <UIKit/UIKit.h>
#import "Pen.h"


@interface BitmapPen : Pen
{
    CGSize pixelSizeOfImage;
    BOOL hasProcessedImage;
    
    dispatch_semaphore_t imageUpdateSemaphore;
}

-  (id)initWithURL:(NSURL *)url drawPadSize:(CGSize)size drawpadTarget:(id<GPUImageInput>)target;

- (id)initWithData:(NSData *)imageData drawPadSize:(CGSize)size drawpadTarget:(id<GPUImageInput>)target;

- (id)initWithImage:(UIImage *)newImageSource drawPadSize:(CGSize)size drawpadTarget:(id<GPUImageInput>)target;

- (id)initWithCGImage:(CGImageRef)newImageSource drawPadSize:(CGSize)size drawpadTarget:(id<GPUImageInput>)target;



- (void)processImage;

- (CGSize)outputImageSize;

-(GPUImageFramebuffer *)getFrameBuffer;

-(void)loadParam:(GPUImageContext*)context;


- (BOOL)processImageWithCompletionHandler:(void (^)(void))completion;

- (void)processImageUpToFilter:(GPUImageOutput<GPUImageInput> *)finalFilterInChain withCompletionHandler:(void (^)(UIImage *processedImage))block;

@end
