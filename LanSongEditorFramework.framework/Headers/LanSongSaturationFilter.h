#import "LanSongFilter.h"

/** Adjusts the saturation of an image
 */
@interface LanSongSaturationFilter : LanSongFilter
{
    GLint saturationUniform;
}

/** Saturation ranges from 0.0 (fully desaturated) to 2.0 (max saturation), with 1.0 as the normal level
 */
@property(nonatomic,readonly) CGFloat minValue;
@property(nonatomic,readonly) CGFloat maxValue;
@property(nonatomic,readonly) CGFloat defaultValue;

@property(readwrite, nonatomic) CGFloat saturation; 

@end
