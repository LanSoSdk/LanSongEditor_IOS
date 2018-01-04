#import "LanSongFilterGroup.h"

@interface LanSongAdaptiveThresholdFilter : LanSongFilterGroup

/** A multiplier for the background averaging blur radius in pixels, with a default of 4
 */
@property(readwrite, nonatomic) CGFloat blurRadiusInPixels;

@end
