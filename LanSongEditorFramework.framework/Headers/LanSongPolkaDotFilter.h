#import "LanSongPixellateFilter.h"

@interface LanSongPolkaDotFilter : LanSongPixellateFilter
{
    GLint dotScalingUniform;
}

@property(readwrite, nonatomic) CGFloat dotScaling;

@end
