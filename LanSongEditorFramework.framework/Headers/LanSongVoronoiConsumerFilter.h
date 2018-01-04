#import "LanSongTwoInputFilter.h"

@interface LanSongVoronoiConsumerFilter : LanSongTwoInputFilter 
{
    GLint sizeUniform;
}

@property (nonatomic, readwrite) CGSize sizeInPixels;

@end
