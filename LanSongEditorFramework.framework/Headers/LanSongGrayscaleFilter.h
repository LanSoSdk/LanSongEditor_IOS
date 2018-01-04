#import "LanSongFilter.h"

extern NSString *const kLanSongLuminanceFragmentShaderString;

/** Converts an image to grayscale (a slightly faster implementation of the saturation filter, without the ability to vary the color contribution)
 */
@interface LanSongGrayscaleFilter : LanSongFilter

@end
