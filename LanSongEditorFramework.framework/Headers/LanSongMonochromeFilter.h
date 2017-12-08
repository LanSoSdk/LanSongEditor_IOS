#import "LanSongFilter.h"

@interface LanSongMonochromeFilter : LanSongFilter
{
    GLint intensityUniform, filterColorUniform;
}

@property(readwrite, nonatomic) CGFloat intensity;
@property(readwrite, nonatomic) LanSongVector4 color;

- (void)setColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent;

@end
