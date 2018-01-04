#import "LanSongFilterGroup.h"
#import "LanSongLowPassFilter.h"
#import "LanSongDifferenceBlendFilter.h"

@interface LanSongHighPassFilter : LanSongFilterGroup
{
    LanSongLowPassFilter *lowPassFilter;
    LanSongDifferenceBlendFilter *differenceBlendFilter;
}

// This controls the degree by which the previous accumulated frames are blended and then subtracted from the current one. This ranges from 0.0 to 1.0, with a default of 0.5.
@property(readwrite, nonatomic) CGFloat filterStrength;

@end
