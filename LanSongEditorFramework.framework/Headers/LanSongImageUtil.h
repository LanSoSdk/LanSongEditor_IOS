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

+ (CVPixelBufferRef )pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size;

+(UIImage *)createImageWithText:(NSString *)text imageSize:(CGSize)size;

+ (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size;

@end
