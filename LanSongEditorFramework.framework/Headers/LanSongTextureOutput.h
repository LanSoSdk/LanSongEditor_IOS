#import <Foundation/Foundation.h>
#import "LanSongContext.h"

@protocol LanSongTextureOutputDelegate;

@interface LanSongTextureOutput : NSObject <LanSongInput>
{
    LanSongFramebuffer *firstInputFramebuffer;
}

@property(readwrite, unsafe_unretained, nonatomic) id<LanSongTextureOutputDelegate> delegate;
@property(readonly) GLuint texture;
@property(nonatomic) BOOL enabled;

- (void)doneWithTexture;

@end

@protocol LanSongTextureOutputDelegate
- (void)newFrameReadyFromTextureOutput:(LanSongTextureOutput *)callbackTextureOutput;
@end
