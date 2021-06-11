//
//  PicturePen.h
//  LanSongEditorFramework
//
//  Created by sno on 16/12/24.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <UIKit/UIKit.h>
#import "LSOPen.h"
#import "LSOBitmapAsset.h"



@interface LSOBitmapPen : LSOPen
{
    CGSize pixelSizeOfImage;
    BOOL hasProcessedImage;
    
    dispatch_semaphore_t imageUpdateSemaphore;
}


/**
切换图片, 切换后, 新的图片在下一帧显示.
 @return 切换成功,返回YES,失败返回NO
 */
- (BOOL)switchBitmap:(UIImage *)image;



/**********************一下为内部使用********************************************************/
-  (id)initWithAsset:(LSOBitmapAsset *)bmpAsset drawPadSize:(CGSize)size drawpadTarget:(id<LanSongInput>)target;

-  (id)initWithURL:(NSURL *)url drawPadSize:(CGSize)size drawpadTarget:(id<LanSongInput>)target;

- (id)initWithImage:(UIImage *)newImageSource drawPadSize:(CGSize)size drawpadTarget:(id<LanSongInput>)target;
- (id)initWithCGImage:(CGImageRef)newImageSource drawPadSize:(CGSize)size drawpadTarget:(id<LanSongInput>)target;
- (void)processImage;
- (CGSize)outputImageSize;
-(LanSongFramebuffer *)getFrameBuffer;
-(void)loadParam:(LanSongContext*)context;
- (BOOL)processImageWithCompletionHandler:(void (^)(void))completion;
- (void)processImageUpToFilter:(LanSongOutput<LanSongInput> *)finalFilterInChain withCompletionHandler:(void (^)(UIImage *processedImage))block;

@end
