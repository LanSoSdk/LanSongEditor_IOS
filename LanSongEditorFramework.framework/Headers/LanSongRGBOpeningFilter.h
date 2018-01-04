#import "LanSongFilterGroup.h"

@class LanSongRGBErosionFilter;
@class LanSongRGBDilationFilter;

// A filter that first performs an erosion on each color channel of an image, followed by a dilation of the same radius. 
// This helps to filter out smaller bright elements.

@interface LanSongRGBOpeningFilter : LanSongFilterGroup
{
    LanSongRGBErosionFilter *erosionFilter;
    LanSongRGBDilationFilter *dilationFilter;
}

- (id)initWithRadius:(NSUInteger)radius;

@end
