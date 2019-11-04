#import "LanSongTwoPassTextureSamplingFilter.h"

/**
 A more generalized 9x9 Gaussian blur filter
 指定区域内的高斯模糊.
 区域是圆形, 可以设置圆形中心点和半径;模糊程度;
 */
@interface LanSongGaussianBlurPositionFilter : LanSongTwoPassTextureSamplingFilter 
{
    GLint blurCenterUniform, blurRadiusUniform, aspectRatioUniform;
}

/** A multiplier for the blur size, ranging from 0.0 on up, with a default of 1.0
 */
@property (readwrite, nonatomic) CGFloat blurSize;

/** Center for the blur, defaults to 0.5, 0.5
 */
@property (readwrite, nonatomic) CGPoint blurCenter;

/** Radius for the blur, defaults to 1.0
 */
@property (readwrite, nonatomic) CGFloat blurRadius;

@end
