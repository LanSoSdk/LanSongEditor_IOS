#import <Foundation/Foundation.h>
#import "LanSongOutput.h"
#import "LSOObject.h"


@interface LanSongFilterPipeline : LSOObject
{
    NSString *stringValue;
}

@property (strong) NSMutableArray *filters;

@property (strong) LanSongOutput *input;
@property (strong) id <LanSongInput> output;

- (id) initWithOrderedFilters:(NSArray*) filters input:(LanSongOutput*)input output:(id <LanSongInput>)output;
- (id) initWithConfiguration:(NSDictionary*) configuration input:(LanSongOutput*)input output:(id <LanSongInput>)output;
- (id) initWithConfigurationFile:(NSURL*) configuration input:(LanSongOutput*)input output:(id <LanSongInput>)output;

- (void) addFilter:(LanSongOutput<LanSongInput> *)filter;
- (void) addFilter:(LanSongOutput<LanSongInput> *)filter atIndex:(NSUInteger)insertIndex;
- (void) replaceFilterAtIndex:(NSUInteger)index withFilter:(LanSongOutput<LanSongInput> *)filter;
- (void) replaceAllFilters:(NSArray *) newFilters;
- (void) removeFilter:(LanSongOutput<LanSongInput> *)filter;
- (void) removeFilterAtIndex:(NSUInteger)index;
- (void) removeAllFilters;

- (UIImage *) currentFilteredFrame;
- (UIImage *) currentFilteredFrameWithOrientation:(UIImageOrientation)imageOrientation;
- (CGImageRef) newCGImageFromCurrentFilteredFrame;

@end
