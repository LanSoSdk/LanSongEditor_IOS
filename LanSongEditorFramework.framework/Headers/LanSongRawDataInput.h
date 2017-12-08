#import "LanSongOutput.h"

// The bytes passed into this input are not copied or retained, but you are free to deallocate them after they are used by this filter.
// The bytes are uploaded and stored within a texture, so nothing is kept locally.
// The default format for input bytes is LanSongPixelFormatBGRA, unless specified with pixelFormat:
// The default type for input bytes is LanSongPixelTypeUByte, unless specified with pixelType:

typedef enum {
	LanSongPixelFormatBGRA = GL_BGRA,
	LanSongPixelFormatRGBA = GL_RGBA,
	LanSongPixelFormatRGB = GL_RGB,
    LanSongPixelFormatLuminance = GL_LUMINANCE
} LanSongPixelFormat;

typedef enum {
	LanSongPixelTypeUByte = GL_UNSIGNED_BYTE,
	LanSongPixelTypeFloat = GL_FLOAT
} LanSongPixelType;

@interface LanSongRawDataInput : LanSongOutput
{
    CGSize uploadedImageSize;
	
	dispatch_semaphore_t dataUpdateSemaphore;
}

// Initialization and teardown
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize;
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize pixelFormat:(LanSongPixelFormat)pixelFormat;
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize pixelFormat:(LanSongPixelFormat)pixelFormat type:(LanSongPixelType)pixelType;

/** Input data pixel format
 */
@property (readwrite, nonatomic) LanSongPixelFormat pixelFormat;
@property (readwrite, nonatomic) LanSongPixelType   pixelType;

// Image rendering
- (void)updateDataFromBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize;
- (void)processData;
- (void)processDataForTimestamp:(CMTime)frameTime;
- (CGSize)outputImageSize;

@end
