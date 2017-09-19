#import "LanSongFilter.h"

@interface LanSongBuffer : LanSongFilter
{
    NSMutableArray *bufferedFramebuffers;
}

@property(readwrite, nonatomic) NSUInteger bufferSize;

@end
