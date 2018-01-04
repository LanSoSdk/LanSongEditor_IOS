#import "LanSongFilter.h"

extern NSString *const kLanSongNearbyTexelSamplingVertexShaderString;

@interface LanSong3x3TextureSamplingFilter : LanSongFilter
{
    GLint texelWidthUniform, texelHeightUniform;
    
    CGFloat texelWidth, texelHeight;
    BOOL hasOverriddenImageSizeFactor;
}

// The texel width and height determines how far out to sample from this texel. By default, this is the normalized width of a pixel, but this can be overridden for different effects.
@property(readwrite, nonatomic) CGFloat texelWidth; 
@property(readwrite, nonatomic) CGFloat texelHeight; 


@end
