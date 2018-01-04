#import "LanSongFilter.h"

@interface LanSongPerlinNoiseFilter : LanSongFilter 
{
    GLint scaleUniform, colorStartUniform, colorFinishUniform;
}

@property (readwrite, nonatomic) LanSongVector4 colorStart;
@property (readwrite, nonatomic) LanSongVector4 colorFinish;

@property (readwrite, nonatomic) float scale;

@end
