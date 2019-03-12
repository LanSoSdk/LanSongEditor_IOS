#import "LanSongOutput.h"

@interface LanSongUIElement : LanSongOutput

// Initialization and teardown
- (id)initWithView:(UIView *)inputView;
- (id)initWithLayer:(CALayer *)inputLayer;

// Layer management
- (CGSize)layerSizeInPixels;
- (void)update;

//是否在更新完CALayer数据后,锁住, 后面不再渲染CALayer,从而加快渲染时间;
@property (nonatomic, assign)BOOL lockCALayerData;
@end
