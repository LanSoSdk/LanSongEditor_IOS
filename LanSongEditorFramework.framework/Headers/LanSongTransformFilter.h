#import "LanSongFilter.h"

@interface LanSongTransformFilter : LanSongFilter
{
    GLint transformMatrixUniform, orthographicMatrixUniform;
    LanSongMatrix4x4 orthographicMatrix;
}


/**
 2D变换矩阵, 可以设置, 也可以读取
 */
@property(readwrite, nonatomic) CGAffineTransform affineTransform;

/**
 3D变换, 可以设置, 也可以读取
 */
@property(readwrite, nonatomic) CATransform3D transform3D;


/**
 是否忽略宽高比;
 默认为NO. 如果忽略宽高比,则旋转可能变形; 不建议设置;
 */
@property(readwrite, nonatomic) BOOL ignoreAspectRatio;


/**
 设置锚点在左上角;
 默认在中心;
 设置后, 会把画面显示到左上角.但旋转一样以画面的中心点旋转;
 */
@property(readwrite, nonatomic) BOOL anchorTopLeft;

@end

