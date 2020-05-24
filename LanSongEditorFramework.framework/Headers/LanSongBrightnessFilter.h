#import "LanSongFilter.h"

@interface LanSongBrightnessFilter : LanSongFilter
{
    GLint brightnessUniform;
}

// Brightness ranges from -1.0 to 1.0, with 0.0 as the normal level
@property(nonatomic,readonly) CGFloat minValue;
@property(nonatomic,readonly) CGFloat maxValue;
@property(nonatomic,readonly) CGFloat defaultValue;

@property(readwrite, nonatomic) CGFloat brightness; 

@end
