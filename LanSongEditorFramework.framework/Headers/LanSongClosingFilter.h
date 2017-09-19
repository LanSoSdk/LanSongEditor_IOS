#import "LanSongFilterGroup.h"

@class LanSongErosionFilter;
@class LanSongDilationFilter;

// A filter that first performs a dilation on the red channel of an image, followed by an erosion of the same radius. 
// This helps to filter out smaller dark elements.

@interface LanSongClosingFilter : LanSongFilterGroup
{
    LanSongErosionFilter *erosionFilter;
    LanSongDilationFilter *dilationFilter;
}

@property(readwrite, nonatomic) CGFloat verticalTexelSpacing, horizontalTexelSpacing;

- (id)initWithRadius:(NSUInteger)radius;

@end
