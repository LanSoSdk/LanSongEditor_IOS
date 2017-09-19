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


typedef struct GPUTextureOptions {
    GLenum minFilter;
    GLenum magFilter;
    GLenum wrapS;
    GLenum wrapT;
    GLenum internalFormat;
    GLenum format;
    GLenum type;
} GPUTextureOptions;

/**
 *  是上一个target的draw到这个FrameBuffer, 然后在下一个Target时, 又把这个FrameBuffer作为纹理输入,
 
 统一管理 纹理和Opengl中的framebuffer, 当在Opengl支持快速读取渲染好的数据的设备上,支持直接读取数据到CVPixelBufferRef中,
 *  opengl内部有 texture索引和opengl内部的frameBuffer索引;
 *  glGenFramebuffers(1, &framebuffer):是创建opengl内部的framebuffer.
 *  glGenTextures(1, &_texture):是创建opengl内部的纹理索引.
 *  通过texture可以绘制图像, 通过frameBuffer可以得到绘制后的数据.
 
 
 */
@interface LanSongFramebuffer : NSObject

@property(readonly) CGSize size;
@property(readonly) GPUTextureOptions textureOptions;
@property(readonly) GLuint texture;
@property(readonly) BOOL missingFramebuffer;

// Initialization and teardown
- (id)initWithSize:(CGSize)framebufferSize;
- (id)initWithSize:(CGSize)framebufferSize textureOptions:(GPUTextureOptions)fboTextureOptions onlyTexture:(BOOL)onlyGenerateTexture;
- (id)initWithSize:(CGSize)framebufferSize overriddenTexture:(GLuint)inputTexture;

// Usage
- (void)activateFramebuffer;

/**
 蓝松++
 */
-(BOOL)isReferenceCountingDisabled;

// Reference counting
- (void)lock;
- (void)unlock;
- (void)clearAllLocks;
- (void)disableReferenceCounting;
- (void)enableReferenceCounting;

// Image capture
- (CGImageRef)newCGImageFromFramebufferContents;
- (void)restoreRenderTarget;

// Raw data bytes
- (void)lockForReading;
- (void)unlockAfterReading;
- (NSUInteger)bytesPerRow;
- (GLubyte *)byteBuffer;
- (CVPixelBufferRef)pixelBuffer;

@end
