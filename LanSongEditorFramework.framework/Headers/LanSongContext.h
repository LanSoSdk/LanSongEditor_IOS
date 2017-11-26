#import "ShaderProgram.h"
#import "LanSongFramebuffer.h"
#import "LanSongFramebufferCache.h"

//----LANSO++
#define LANSONGSDK_DEBUG 0

#define SNOLog(msg...) do{ if(DEUG) printf(msg);}while(0)


// 设置Dlog可以打印出类名,方法名,行数.
#ifdef LANSONGSDK_DEBUG
    #define LSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
    #define LANSOSDKLine NSLog(@"[LanSoEditor] function:%s [Line %d]", __PRETTY_FUNCTION__, __LINE__);
#else
    #define LSLog(...)
    #define LANSOSDKLine ;
#endif

//-------LANSO++  END

/**
 如果有向左旋转, 向右旋转的角度,则返回YES, 交换宽高;
 */
#define LanSongRotationSwapsWidthAndHeight(rotation) ((rotation) == kLanSongRotateLeft || (rotation) == kLanSongRotateRight || (rotation) == kLanSongRotateRightFlipVertical || (rotation) == kLanSongRotateRightFlipHorizontal)

typedef NS_ENUM(NSUInteger, LanSongRotationMode) {
	kLanSongNoRotation,
	kLanSongRotateLeft,
	kLanSongRotateRight,
	kLanSongFlipVertical,
	kLanSongFlipHorizonal,
	kLanSongRotateRightFlipVertical,
	kLanSongRotateRightFlipHorizontal,
	kLanSongRotate180
};

@interface LanSongContext : NSObject

@property(readonly, nonatomic) dispatch_queue_t contextQueue;
@property(readwrite, retain, nonatomic) ShaderProgram *currentShaderProgram;
@property(readonly, retain, nonatomic) EAGLContext *context;
@property(readonly) CVOpenGLESTextureCacheRef coreVideoTextureCache;
@property(readonly) LanSongFramebufferCache *framebufferCache;


/**
 特定用户使用.
 */
+(void)setOpengles30:(BOOL)is;

+ (void *)contextKey;
+ (LanSongContext *)sharedImageProcessingContext;
+ (dispatch_queue_t)sharedContextQueue;
+ (LanSongFramebufferCache *)sharedFramebufferCache;
+ (void)useImageProcessingContext;
- (void)useAsCurrentContext;
+ (void)setActiveShaderProgram:(ShaderProgram *)shaderProgram;
- (void)setContextShaderProgram:(ShaderProgram *)shaderProgram;
+ (GLint)maximumTextureSizeForThisDevice;
+ (GLint)maximumTextureUnitsForThisDevice;
+ (GLint)maximumVaryingVectorsForThisDevice;
+ (BOOL)deviceSupportsOpenGLESExtension:(NSString *)extension;
+ (BOOL)deviceSupportsRedTextures;
+ (BOOL)deviceSupportsFramebufferReads;
+ (CGSize)sizeThatFitsWithinATextureForSize:(CGSize)inputSize;

- (void)presentBufferForDisplay;
- (ShaderProgram *)programForVertexShaderString:(NSString *)vertexShaderString fragmentShaderString:(NSString *)fragmentShaderString;

- (void)useSharegroup:(EAGLSharegroup *)sharegroup;

// Manage fast texture upload
+ (BOOL)supportsFastTextureUpload;


@end

@protocol LanSongInput <NSObject>
- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;
- (void)setInputFramebuffer:(LanSongFramebuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex;
- (NSInteger)nextAvailableTextureIndex;
- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex;
- (void)setInputRotation:(LanSongRotationMode)newInputRotation atIndex:(NSInteger)textureIndex;
- (CGSize)maximumOutputSize;

/**
 原生结束处理.
 */
- (void)endProcessing;
- (BOOL)shouldIgnoreUpdatesToThisTarget;
- (BOOL)enabled;
- (BOOL)wantsMonochromeInput;
- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;
@end
