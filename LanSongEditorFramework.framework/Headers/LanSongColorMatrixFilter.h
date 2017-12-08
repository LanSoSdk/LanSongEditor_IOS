#import "LanSongFilter.h"

/** Transforms the colors of an image by applying a matrix to them
 */
@interface LanSongColorMatrixFilter : LanSongFilter
{
    GLint colorMatrixUniform;
    GLint intensityUniform;
}

/** A 4x4 matrix used to transform each color in an image
 */
@property(readwrite, nonatomic) LanSongMatrix4x4 colorMatrix;

/** The degree to which the new transformed color replaces the original color for each pixel
 */
@property(readwrite, nonatomic) CGFloat intensity;

@end
