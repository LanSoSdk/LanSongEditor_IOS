#import "LanSongOutput.h"

// The bytes passed into this input are not copied or retained, but you are free to deallocate them after they are used by this filter.
// The bytes are uploaded and stored within a texture, so nothing is kept locally.
// The default format for input bytes is LSOPixelFormatBGRA, unless specified with pixelFormat:
// The default type for input bytes is LSOPixelTypeUByte, unless specified with pixelType:

typedef enum {
	LSOPixelFormatBGRA = GL_BGRA,
	LSOPixelFormatRGBA = GL_RGBA,
	LSOPixelFormatRGB = GL_RGB,
    LSOPixelFormatLuminance = GL_LUMINANCE
} LSOPixelFormat;

typedef enum {
	LSOPixelTypeUByte = GL_UNSIGNED_BYTE,
	LSOPixelTypeFloat = GL_FLOAT
} LSOPixelType;

@interface LanSongRawDataInput : LanSongOutput
{
    CGSize uploadedImageSize;
	
	dispatch_semaphore_t dataUpdateSemaphore;
}

// Initialization and teardown
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize;
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize pixelFormat:(LSOPixelFormat)pixelFormat;
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize pixelFormat:(LSOPixelFormat)pixelFormat type:(LSOPixelType)pixelType;

/** Input data pixel format
 */
@property (readwrite, nonatomic) LSOPixelFormat pixelFormat;
@property (readwrite, nonatomic) LSOPixelType   pixelType;

// Image rendering
- (void)updateDataFromBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize;
- (void)processData;
- (void)processDataForTimestamp:(CMTime)frameTime;
- (CGSize)outputImageSize;

@end
