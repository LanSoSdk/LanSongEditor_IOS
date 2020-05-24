#import "LanSongFilter.h"

@interface LanSongExposureFilter : LanSongFilter
{
    GLint exposureUniform;
}

// Exposure ranges from -10.0 to 10.0, with 0.0 as the normal level


@property(nonatomic,readonly) CGFloat minValue;
@property(nonatomic,readonly) CGFloat maxValue;
@property(nonatomic,readonly) CGFloat defaultValue;



@property(readwrite, nonatomic) CGFloat exposure; 

@end
