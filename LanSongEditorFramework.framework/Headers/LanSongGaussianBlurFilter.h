#import "LanSongTwoPassTextureSamplingFilter.h"

/** A Gaussian blur filter
    Interpolated optimization based on Daniel Rákos' work at
 */

@interface LanSongGaussianBlurFilter : LanSongTwoPassTextureSamplingFilter 
{
    BOOL shouldResizeBlurRadiusWithImageSize;
    CGFloat _blurRadiusInPixels;
}

/**
 A multiplier for the spacing between texels, ranging from 0.0 on up, with a default of 1.0. Adjusting this may slightly increase the blur strength, but will introduce artifacts in the result.
 */
@property (readwrite, nonatomic) CGFloat texelSpacingMultiplier;

/**
 像素的模糊半径, 默认是2.0;
 建议最大值是50; 正常模糊是8.0;
 */
@property (readwrite, nonatomic) CGFloat blurRadiusInPixels;

/**
 */
@property (readwrite, nonatomic) CGFloat blurRadiusAsFractionOfImageWidth;
@property (readwrite, nonatomic) CGFloat blurRadiusAsFractionOfImageHeight;

/// The number of times to sequentially blur the incoming image. The more passes, the slower the filter.
@property(readwrite, nonatomic) NSUInteger blurPasses;

+ (NSString *)vertexShaderForStandardBlurOfRadius:(NSUInteger)blurRadius sigma:(CGFloat)sigma;
+ (NSString *)fragmentShaderForStandardBlurOfRadius:(NSUInteger)blurRadius sigma:(CGFloat)sigma;
+ (NSString *)vertexShaderForOptimizedBlurOfRadius:(NSUInteger)blurRadius sigma:(CGFloat)sigma;
+ (NSString *)fragmentShaderForOptimizedBlurOfRadius:(NSUInteger)blurRadius sigma:(CGFloat)sigma;

- (void)switchToVertexShader:(NSString *)newVertexShader fragmentShader:(NSString *)newFragmentShader;

@end
