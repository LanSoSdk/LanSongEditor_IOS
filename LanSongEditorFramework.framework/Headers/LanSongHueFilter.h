
#import "LanSongFilter.h"

@interface LanSongHueFilter : LanSongFilter
{
    GLint hueAdjustUniform;
    
}
@property (nonatomic, readwrite) CGFloat hue;

@end
