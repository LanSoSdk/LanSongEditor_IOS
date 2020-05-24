#import "LanSongFilter.h"

@interface LanSongSharpenFilter : LanSongFilter
{
    GLint sharpnessUniform;
    GLint imageWidthFactorUniform, imageHeightFactorUniform;
}

// Sharpness ranges from -4.0 to 4.0, with 0.0 as the normal level


@property(nonatomic,readonly) CGFloat minValue;
@property(nonatomic,readonly) CGFloat maxValue;
@property(nonatomic,readonly) CGFloat defaultValue;


@property(readwrite, nonatomic) CGFloat sharpness; 

@end
