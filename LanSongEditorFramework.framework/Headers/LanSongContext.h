#import "ShaderProgram.h"
#import "LanSongFramebuffer.h"
#import "LanSongFramebufferCache.h"

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
