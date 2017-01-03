//
//  UIView+UIImage.h
//  TouchPainter
//
//  Created by Carlo Chung on 10/23/10.
//  Copyright 2010 Carlo Chung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BlazeiceCommon.h"
#import "BlazeiceDEBUG.h"

@interface UIView (UIImage)

- (UIImage*) ScreenShots;

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

- (UIImage*)captureView: (UIView *)theView;// 对于特定UIView的截屏


- (CGSize) adaptiveImageWithImage:(UIImage *)image width:(float)w height:(float)h;

- (CGImageRef)newTransformedImage:(CGAffineTransform)transform
                      sourceImage:(CGImageRef)sourceImage
                       sourceSize:(CGSize)sourceSize
                sourceOrientation:(UIImageOrientation)sourceOrientation
                      outputWidth:(CGFloat)outputWidth
                         cropSize:(CGSize)cropSize
                    imageViewSize:(CGSize)imageViewSize;

- (CGImageRef)newScaledImage:(CGImageRef)source
             withOrientation:(UIImageOrientation)orientation
                      toSize:(CGSize)size
                 withQuality:(CGInterpolationQuality)quality;

- (UIImage*)ScreenShots2;

- (UIImage*)ScreenShots3;

- (UIImage*)ScreenShotsOnece;

@end
