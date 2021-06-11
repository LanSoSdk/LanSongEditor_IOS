//
//  LSOSegmentImage.h
//  LanSongEditorFramework
//
//  Created by sno on 2021/4/20.
//  Copyright © 2021 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOCamLayer.h"
#import "LSOXAssetInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOSegmentImage : NSObject


/// 同一时刻只能有一个对象在工作
/// @param url 图片路径
- (instancetype)initWithUIImageURL:(NSURL *)url;



/// 输入图片对象
/// @param image
- (instancetype)initWithUIImage:(UIImage *)image;



/// 输入的原始图像;
@property (nonatomic, readonly) UIImage *originalImage;

/**
 在异步线程执行此block; 请用一下代码后调用;
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^segmentCompletionBlock)(void);


/// 开始分割;
- (void)start;



/// 输出的分辨率
@property (nonatomic, readonly) CGSize outputSize;

/// 获取图像
/// @param rgbaPtr 分割后的图像;
- (BOOL)getFrame:(unsigned char *)rgbaPtr;


- (void)releaseLSO;

/**
 rgba转 图片.
 - (UIImage *) convertaIntoUIImage:(void*)bitsData size:(CGSize)size

 {
     CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//
     void *colorData = bitsData;

     CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, colorData, size.width*size.height*4, NULL);
     CGImageRef cgImage2 = CGImageCreate(size.width,
                                         size.height,
                                         8,
                                         8 * 4,
                                         size.width*4,
                                         colorSpace,
                                         kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst,
                                         provider,
                                         NULL,
                                         NO,
                                         kCGRenderingIntentDefault);

     UIImage *image = [UIImage imageWithCGImage:cgImage2];
     CGDataProviderRelease(provider);
     CGColorSpaceRelease(colorSpace);
     CGImageRelease(cgImage2);
     return image;
 }
 
 */
@end

NS_ASSUME_NONNULL_END
