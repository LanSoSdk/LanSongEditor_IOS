#import "LanSongFilter.h"


/**
 裁剪滤镜.
 内部会根据传入的旋转角度来调整裁剪的大小;
 */
@interface LanSongCropFilter : LanSongFilter
{
    GLfloat cropTextureCoordinates[8];
}

/**
 
 范围是0--1;
 x: 0.0---1.0
 y: 0.0---1.0
 //可以在任何进度中实时修改;
 */
@property(readwrite, nonatomic) CGRect cropRegion;

/**
 
 范围是0--1;
 x: 0.0---1.0
 y: 0.0---1.0
 */
- (id)initWithCropRegion:(CGRect)newCropRegion;

@end
