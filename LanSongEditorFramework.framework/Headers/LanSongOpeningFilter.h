#import "LanSongFilterGroup.h"

@class LanSongErosionFilter;
@class LanSongDilationFilter;

// A filter that first performs an erosion on the red channel of an image, followed by a dilation of the same radius. 
// This helps to filter out smaller bright elements.

@interface LanSongOpeningFilter : LanSongFilterGroup
{
    LanSongErosionFilter *erosionFilter;
    LanSongDilationFilter *dilationFilter;
}

@property(readwrite, nonatomic) CGFloat verticalTexelSpacing, horizontalTexelSpacing;

- (id)initWithRadius:(NSUInteger)radius;

@end
