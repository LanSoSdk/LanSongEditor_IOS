#import "LanSongFilterGroup.h"

@class LanSongGaussianBlurFilter;

/** A Gaussian blur that preserves focus within a circular region
 指定区域以外的高斯模糊
  区域是圆形, 可以设置圆形中心点和半径;模糊程度;
 */
@interface LanSongGaussianSelectiveBlurFilter : LanSongFilterGroup 
{
    LanSongGaussianBlurFilter *blurFilter;
    LanSongFilter *selectiveFocusFilter;
    BOOL hasOverriddenAspectRatio;
}

/**
 The radius of the circular area being excluded from the blur
 */
@property (readwrite, nonatomic) CGFloat excludeCircleRadius;
/** The center of the circular area being excluded from the blur
 */
@property (readwrite, nonatomic) CGPoint excludeCirclePoint;
/**

 The size of the area between the blurred portion and the clear circle
 */
@property (readwrite, nonatomic) CGFloat excludeBlurSize;
/**
 模糊的半径, 单位像素
 A radius in pixels to use for the blur, with a default of 5.0. This adjusts the sigma variable in the Gaussian distribution function.
 */
@property (readwrite, nonatomic) CGFloat blurRadiusInPixels;
/**
 宽高比;
 The aspect ratio of the image, used to adjust the circularity of the in-focus region. By default, this matches the image aspect ratio, but you can override this value.
 */
@property (readwrite, nonatomic) CGFloat aspectRatio;

@end
