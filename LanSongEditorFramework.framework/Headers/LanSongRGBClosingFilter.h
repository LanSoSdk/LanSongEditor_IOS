#import "LanSongFilterGroup.h"

@class LanSongRGBErosionFilter;
@class LanSongRGBDilationFilter;

// A filter that first performs a dilation on each color channel of an image, followed by an erosion of the same radius. 
// This helps to filter out smaller dark elements.

@interface LanSongRGBClosingFilter : LanSongFilterGroup
{
    LanSongRGBErosionFilter *erosionFilter;
    LanSongRGBDilationFilter *dilationFilter;
}

- (id)initWithRadius:(NSUInteger)radius;


@end
