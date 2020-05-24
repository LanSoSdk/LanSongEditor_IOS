//
//
//  Created by sno on 2018/8/28.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LSOImageUtil : NSObject


+(UIImage*)pixelBufferToImage:(CVPixelBufferRef) pixelBufffer;

/**
 图片拷贝.
 
 可能不是很好的办法;
 内部代码是:
 UIGraphicsBeginImageContext(imageToCopy.size);
 [imageToCopy drawInRect:CGRectMake(0, 0, imageToCopy.size.width, imageToCopy.size.height)];
 UIImage *copiedImage =UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 */
+(UIImage *)uiImageCopy:(UIImage *)imageToCopy;

+(UIImage *)uiImageCopy:(UIImage *)image scaleSize:(CGSize)scaleSize;

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
 内部用malloc创建的内存, 没有释放;
 */
+ (unsigned char *)pixelBRGABytesFromImage:(UIImage *)image;
/**
 图片转指针数组2
 内部用malloc创建的内存, 没有释放;
 */
+ (unsigned char *)pixelBRGABytesFromImageRef:(CGImageRef)imageRef;




/**
 二进制数据,转CGImageRef类型的图片;
 */
+(CGImageRef)imageRefFromRGBABytes:(unsigned char *)imageBytes imageSize:(CGSize)imageSize;
/**
 二进制数组, 转图片

 透明通道在最高位;
 @param imageBytes 数组指针首地址
 @param imageSize 这个图片的宽高
 @return 返回当前图片;
 */
+(UIImage *)imageFromARGBBytes:(unsigned char *)imageBytes imageSize:(CGSize)imageSize;

/**
 二进制数组转图片

 透明通道在最低位;
 @param imageBytes <#imageBytes description#>
 @param imageSize <#imageSize description#>
 @return <#return value description#>
 */
+(UIImage *)imageFromRGBABytes:(unsigned char *)imageBytes imageSize:(CGSize)imageSize;


/**
 把一张图片居中裁剪成 和需要的分辨率等比例的图片.
 不是裁剪到这个分辨率. 是和这个分辨率等比例
 
 @param srcImage 输入的图片尺寸
 @param requestRatio 需要参考的分辨率.
 @return 返回裁剪后的图片
 */
+(UIImage *)cropToRequestRatio:(UIImage *)srcImage requestRatio:(CGSize)requestRatio;

/// 把UIImage中的标志为有角度的值, 直接把图片调整好,然后返回;
/// @param aImage 原图片
+(UIImage *)uiimageFixOrientation:(UIImage *)aImage;

+(CGSize)computeToSameRatio:(CGSize)imageSize requestSize:(CGSize)requestSize;
@end
