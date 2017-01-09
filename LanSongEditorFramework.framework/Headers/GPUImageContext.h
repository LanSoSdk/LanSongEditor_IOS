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
 *   当前对象处理完成得到图像数据后(比如GPuImageMovie解码完成,camera得到数据,UI得到数据,filter渲染得到数据),会调用实现这个GPUImageInput协议的对象,来完成下一步的动作,比如在filter中(或下一个filter中)渲染 ,view中显示,GPUImageMoiveWrite的写入.
 *
 *  @param frameTime    处理完时的时间戳.
 *  @param textureIndex  传递到下一层的时候, 把在addTarget 的时候, Target为这个输入分配的id号,好用来识别你在target中的位置, 这里一并传递下去.这样target知道是那个过来了.
 */
- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;
/**
 *  当前对象处理完成得到图像数据后(比如GPuImageMovie解码完成,camera得到数据,UI得到数据,filter渲染得到数据),通过这里把渲染好的GPUImageframeBuffer传递过来,然后调用newFrameReadyAtTime来进行实现这个GPUImageInput协议对象的下一步操作.
 *  @param newInputFramebuffer
 *  @param textureIndex        <#textureIndex description#>
 */
- (void)setInputFramebuffer:(GPUImageFramebuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex;
/**
 *  下一个可用的纹理索引, 
      有些滤镜是有多个输入的,比如GPUImageTwoInputFilter有两个,Three有三个,
      当别的滤镜addTarget的时候, 需要Target分配一个索引上来,以方便当前再把纹理送下去的时候,也把这个索引送下去,以告知当前滤镜,过来的纹理是哪个.
 *   算法是:先addTarget的认为是0, 后addTarget的认为是1., 再后面addTarget的认为是2...
   GPUImageTwoInputFilter的刷新的步骤是:两个输入都同时刷新后, 才开始渲染.
 *  @return <#return value description#>
 */
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
