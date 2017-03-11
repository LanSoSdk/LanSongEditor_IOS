#import "GLProgram.h"
#import "GPUImageFramebuffer.h"
#import "GPUImageFramebufferCache.h"

#define GPUImageRotationSwapsWidthAndHeight(rotation) ((rotation) == kGPUImageRotateLeft || (rotation) == kGPUImageRotateRight || (rotation) == kGPUImageRotateRightFlipVertical || (rotation) == kGPUImageRotateRightFlipHorizontal)


/**
 *  注意,这里只是对外部输入源的纹理顶点做旋转操作, 固定点调换操作,从而把调换后的顶点投射过去而已.
 
 如果真要达到旋转的效果, 还需要对gl-display的坐标数组做变化.
 
 */
typedef NS_ENUM(NSUInteger, GPUImageRotationMode) {
    /**
     *  输入源纹理数组不旋转
     */
    kGPUImageNoRotation,
    /**
     *  向左旋转90度.逆时针
     */
    kGPUImageRotateLeft,
    /**
     *  顺时针旋转90度
     */
     kGPUImageRotateRight,
    /**
     *  垂直翻转
     */
    kGPUImageFlipVertical,
    /**
     *  水平翻转
     */
    kGPUImageFlipHorizonal,
    /**
     *  顺时针90度并垂直翻转
     */
    kGPUImageRotateRightFlipVertical,
    /**
     *  顺时针90度,并水平翻转
     */
    kGPUImageRotateRightFlipHorizontal,
    /**
     *  旋转180度.
     */
    kGPUImageRotate180
};
/**
 *  定义了一个GPUImageContext 环境.
 */
@interface GPUImageContext : NSObject

@property(readonly, nonatomic) dispatch_queue_t contextQueue;
@property(readwrite, retain, nonatomic) GLProgram *currentShaderProgram;
@property(readonly, retain, nonatomic) EAGLContext *context;
@property(readonly) CVOpenGLESTextureCacheRef coreVideoTextureCache;
@property(readonly) GPUImageFramebufferCache *framebufferCache;

+ (void *)contextKey;
+ (GPUImageContext *)sharedImageProcessingContext;
+ (dispatch_queue_t)sharedContextQueue;
+ (GPUImageFramebufferCache *)sharedFramebufferCache;
+ (void)useImageProcessingContext;
- (void)useAsCurrentContext;
+ (void)setActiveShaderProgram:(GLProgram *)shaderProgram;
- (void)setContextShaderProgram:(GLProgram *)shaderProgram;
+ (GLint)maximumTextureSizeForThisDevice;
+ (GLint)maximumTextureUnitsForThisDevice;
+ (GLint)maximumVaryingVectorsForThisDevice;
+ (BOOL)deviceSupportsOpenGLESExtension:(NSString *)extension;
+ (BOOL)deviceSupportsRedTextures;
+ (BOOL)deviceSupportsFramebufferReads;
+ (CGSize)sizeThatFitsWithinATextureForSize:(CGSize)inputSize;

- (void)presentBufferForDisplay;
- (GLProgram *)programForVertexShaderString:(NSString *)vertexShaderString fragmentShaderString:(NSString *)fragmentShaderString;

- (void)useSharegroup:(EAGLSharegroup *)sharegroup;

// Manage fast texture upload
+ (BOOL)supportsFastTextureUpload;

@end

@protocol GPUImageInput <NSObject>
/**
 */
- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;
/**
 */
- (void)setInputFramebuffer:(GPUImageFramebuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex;

- (NSInteger)nextAvailableTextureIndex;
/**
 *  设置要输入纹理的size尺寸.
 *
 *  @param newSize      尺寸值
 *  @param textureIndex 在当前滤镜中的target序号.
 */
- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex;

- (void)setInputRotation:(GPUImageRotationMode)newInputRotation atIndex:(NSInteger)textureIndex;
- (CGSize)maximumOutputSize;


- (void)endProcessing;

- (BOOL)shouldIgnoreUpdatesToThisTarget;
- (BOOL)enabled;

/**
 接收者是否可以 以单色 输入.

 @return 
 */
- (BOOL)wantsMonochromeInput;
- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;
@end
