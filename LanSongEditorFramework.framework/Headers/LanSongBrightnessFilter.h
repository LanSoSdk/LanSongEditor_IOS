#import "LanSongFilter.h"

@interface LanSongBrightnessFilter : LanSongFilter
{
    GLint brightnessUniform;
}

// Brightness ranges from -1.0 to 1.0, with 0.0 as the normal level
@property(readwrite, nonatomic) CGFloat brightness; 

@end
