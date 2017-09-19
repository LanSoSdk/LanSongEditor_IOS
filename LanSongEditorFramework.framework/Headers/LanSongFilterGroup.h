#import "LanSongOutput.h"
#import "LanSongFilter.h"

@interface LanSongFilterGroup : LanSongOutput <LanSongInput>
{
    NSMutableArray *filters;
    BOOL isEndProcessing;
}

@property(readwrite, nonatomic, strong) LanSongOutput<LanSongInput> *terminalFilter;
@property(readwrite, nonatomic, strong) NSArray *initialFilters;
@property(readwrite, nonatomic, strong) LanSongOutput<LanSongInput> *inputFilterToIgnoreForUpdates; 

// Filter management
- (void)addFilter:(LanSongOutput<LanSongInput> *)newFilter;
- (LanSongOutput<LanSongInput> *)filterAtIndex:(NSUInteger)filterIndex;
- (NSUInteger)filterCount;

@end
