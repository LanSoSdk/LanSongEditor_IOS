#import "LanSongProgram.h"
#import "LanSongFramebuffer.h"
#import "LanSongFramebufferCache.h"

//----LANSO++
//显示或注释掉.
#define LANSONGSDK_DEBUG 1

#define SNOLog(msg...) do{ if(DEUG) printf(msg);}while(0)


// 设置Dlog可以打印出类名,方法名,行数.
#ifdef LANSONGSDK_DEBUG
#define LSLog(fmt, ...) NSLog((@"" fmt), ##__VA_ARGS__);
#define LANSOSDKLine NSLog(@"[LanSoEditor] function:%s [Line %d]", __PRETTY_FUNCTION__, __LINE__);
#else
#define LSLog(...)
#define LANSOSDKLine ;
#endif

//-------LANSO++  END
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
@property(readwrite, retain, nonatomic) LanSongProgram *currentLanSongProgram;
@property(readonly, retain, nonatomic) EAGLContext *context;
@property(readonly) CVOpenGLESTextureCacheRef coreVideoTextureCache;
@property(readonly) LanSongFramebufferCache *framebufferCache;

+ (void *)contextKey;
+ (LanSongContext *)sharedImageProcessingContext;
+ (dispatch_queue_t)sharedContextQueue;
+ (LanSongFramebufferCache *)sharedFramebufferCache;
+ (void)useImageProcessingContext;
- (void)useAsCurrentContext;
+ (void)setActiveLanSongProgram:(LanSongProgram *)LanSongProgram;
- (void)setContextLanSongProgram:(LanSongProgram *)LanSongProgram;
+ (GLint)maximumTextureSizeForThisDevice;
+ (GLint)maximumTextureUnitsForThisDevice;
+ (GLint)maximumVaryingVectorsForThisDevice;
+ (BOOL)deviceSupportsOpenGLESExtension:(NSString *)extension;
+ (BOOL)deviceSupportsRedTextures;
+ (BOOL)deviceSupportsFramebufferReads;
+ (CGSize)sizeThatFitsWithinATextureForSize:(CGSize)inputSize;

- (void)presentBufferForDisplay;
- (LanSongProgram *)programForVertexShaderString:(NSString *)vertexShaderString fragmentShaderString:(NSString *)fragmentShaderString;

- (void)useSharegroup:(EAGLSharegroup *)sharegroup;

/**
 特定客户使用

 @param is <#is description#>
 */
+(void)setOpengles30:(BOOL)is;

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
- (void)endProcessing;
- (BOOL)shouldIgnoreUpdatesToThisTarget;
- (BOOL)enabled;
- (BOOL)wantsMonochromeInput;
- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;
@end
