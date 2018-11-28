//
//
//  Created by sno on 2018/8/28.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LanSongImageUtil : NSObject

/**
 CVPixelBufferRef 转image
 
 pixelBuffer中的图像格式是 RGBA
 
 内部是: kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst,
 */
+(UIImage*)pixelBufferToImage:(CVPixelBufferRef) pixelBufffer;

/**
 图片转 像素buffer(编码用)
 */
+ (CVPixelBufferRef )pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size;
/**
 字符串转图片
 */
+(UIImage *)createImageWithText:(NSString *)text imageSize:(CGSize)size;
/**
 字符串转图片
 */
+ (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size;
/**
 图片转指针数组1
 */
+ (unsigned char *)pixelBRGABytesFromImage:(UIImage *)image;
/**
 图片转指针数组2
 */
+ (unsigned char *)pixelBRGABytesFromImageRef:(CGImageRef)imageRef;


@end
