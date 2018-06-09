#import "LanSongFilter.h"

typedef enum { kLanSongHistogramRed, kLanSongHistogramGreen, kLanSongHistogramBlue, kLanSongHistogramRGB, kLanSongHistogramLuminance} LanSongHistogramType;

@interface LanSongHistogramFilter : LanSongFilter
{
    LanSongHistogramType histogramType;
    
    GLubyte *vertexSamplingCoordinates;
    
    LanSongProgram *secondFilterProgram, *thirdFilterProgram;
    GLint secondFilterPositionAttribute, thirdFilterPositionAttribute;
}

// Rather than sampling every pixel, this dictates what fraction of the image is sampled. By default, this is 16 with a minimum of 1.
@property(readwrite, nonatomic) NSUInteger downsamplingFactor;

// Initialization and teardown
- (id)initWithHistogramType:(LanSongHistogramType)newHistogramType;
- (void)initializeSecondaryAttributes;

@end
