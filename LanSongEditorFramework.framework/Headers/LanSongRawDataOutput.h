#import <Foundation/Foundation.h>
#import "LanSongContext.h"

struct LSOByteColorVector {
    GLubyte red;
    GLubyte green;
    GLubyte blue;
    GLubyte alpha;
};
typedef struct LSOByteColorVector LSOByteColorVector;

@protocol LanSongRawDataProcessor;

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
@interface LanSongRawDataOutput : NSObject <LanSongInput> {
    CGSize imageSize;
    LanSongRotationMode inputRotation;
    BOOL outputBGRA;
}
#else
@interface LanSongRawDataOutput : NSObject <LanSongInput> {
    CGSize imageSize;
    LanSongRotationMode inputRotation;
    BOOL outputBGRA;
}
#endif

@property(readonly) GLubyte *rawBytesForImage;
@property(nonatomic, copy) void(^newFrameAvailableBlock)(void);
@property(nonatomic) BOOL enabled;

// Initialization and teardown
- (id)initWithImageSize:(CGSize)newImageSize resultsInBGRAFormat:(BOOL)resultsInBGRAFormat;

// Data access
- (LSOByteColorVector)colorAtLocation:(CGPoint)locationInImage;
- (NSUInteger)bytesPerRowInOutput;

- (void)setImageSize:(CGSize)newImageSize;

- (void)lockFramebufferForReading;
- (void)unlockFramebufferAfterReading;

@end
