#import <Foundation/Foundation.h>

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#else
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#endif

#import <QuartzCore/QuartzCore.h>
#import <CoreMedia/CoreMedia.h>
#import "LSOObject.h"



typedef struct LSOTextureOptions {
    GLenum minFilter;
    GLenum magFilter;
    GLenum wrapS;
    GLenum wrapT;
    GLenum internalFormat;
    GLenum format;
    GLenum type;
} LSOTextureOptions;

@interface LanSongFramebuffer : LSOObject

@property(readonly) CGSize size;
@property(readonly) LSOTextureOptions textureOptions;

/**
 framebuffer输出的 texture;
 */
@property(readonly) GLuint texture;
@property(readonly) BOOL missingFramebuffer;


- (id)initWithSize:(CGSize)framebufferSize;
- (id)initWithSize:(CGSize)framebufferSize textureOptions:(LSOTextureOptions)fboTextureOptions onlyTexture:(BOOL)onlyGenerateTexture;
- (id)initWithSize:(CGSize)framebufferSize overriddenTexture:(GLuint)inputTexture;

- (id)initWithDecoderSize:(CGSize)framebufferSize context:(EAGLContext *)context  queue:(CVOpenGLESTextureCacheRef)queue;

// Usage
- (void)activateFramebuffer;

// Reference counting
- (void)lock;
- (void)unlock;
- (void)clearAllLocks;
- (void)disableReferenceCounting;
- (void)enableReferenceCounting;

// Image capture
- (CGImageRef)newCGImageFromFramebufferContents;
- (CGImageRef)newCGImageFromFramebufferContents:(EAGLContext *)_context;

- (CGImageRef)getCGImageRefFromFBO;

- (void)restoreRenderTarget;

// Raw data bytes
- (void)lockForReading;
- (void)unlockAfterReading;
- (NSUInteger)bytesPerRow;
- (GLubyte *)byteBuffer;
- (CVPixelBufferRef)pixelBuffer;

-(GLint )getFrameBuffer;


- (GLubyte *)getAndLockBufferAddress;
- (void)unlockBufferAddress;

@end
