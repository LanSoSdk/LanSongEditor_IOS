#import "LanSongFilter.h"

@interface LanSongFalseColorFilter : LanSongFilter
{
    GLint firstColorUniform, secondColorUniform;
}

// The first and second colors specify what colors replace the dark and light areas of the image, respectively. The defaults are (0.0, 0.0, 0.5) amd (1.0, 0.0, 0.0).
@property(readwrite, nonatomic) LanSongVector4 firstColor;
@property(readwrite, nonatomic) LanSongVector4 secondColor;

- (void)setFirstColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent;
- (void)setSecondColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent;

@end
