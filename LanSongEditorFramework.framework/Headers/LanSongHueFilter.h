
#import "LanSongFilter.h"

@interface LanSongHueFilter : LanSongFilter
{
    GLint hueAdjustUniform;
    
}




/**
 调节色调.
 最小值 0.0, 最大值 360.0, 默认值是 90.0;
 */
@property(nonatomic,readonly) CGFloat minValue;
@property(nonatomic,readonly) CGFloat maxValue;
@property(nonatomic,readonly) CGFloat defaultValue;


@property (nonatomic, readwrite) CGFloat hue;

@end
