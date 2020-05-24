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

@interface LanSongRawDataOutput : NSObject <LanSongInput> {
    CGSize imageSize;
    LanSongRotationMode inputRotation;
    BOOL outputBGRA;
}

@property(readonly) GLubyte *rawBytesForImage;
@property(nonatomic, copy) void(^newFrameAvailableBlock)(void);
@property(nonatomic) BOOL enabled;

- (id)initWithImageSize:(CGSize)newImageSize resultsInBGRAFormat:(BOOL)resultsInBGRAFormat;

- (LSOByteColorVector)colorAtLocation:(CGPoint)locationInImage;
- (NSUInteger)bytesPerRowInOutput;

- (void)setImageSize:(CGSize)newImageSize;

- (void)lockFramebufferForReading;
- (void)unlockFramebufferAfterReading;

@end

