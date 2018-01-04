#import "LanSongTwoInputCrossTextureSamplingFilter.h"
#import "LanSongFilterGroup.h"

@interface LanSongPoissonBlendFilter : LanSongTwoInputCrossTextureSamplingFilter
{
    GLint mixUniform;
    
    LanSongFramebuffer *secondOutputFramebuffer;
}

// Mix ranges from 0.0 (only image 1) to 1.0 (only image 2 gradients), with 1.0 as the normal level
@property(readwrite, nonatomic) CGFloat mix;

// The number of times to propagate the gradients.
// Crank this up to 100 or even 1000 if you want to get anywhere near convergence.  Yes, this will be slow.
@property(readwrite, nonatomic) NSUInteger numIterations;

@end
