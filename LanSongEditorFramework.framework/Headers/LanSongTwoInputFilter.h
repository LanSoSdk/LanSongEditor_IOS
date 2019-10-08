#import "LanSongFilter.h"

extern NSString *const kLanSongTwoInputTextureVertexShaderString;

@interface LanSongTwoInputFilter : LanSongFilter
{
    LanSongFramebuffer *secondInputFramebuffer;
    GLint filterSecondTextureCoordinateAttribute;
    GLint filterInputTextureUniform2;
    LanSongRotationMode inputRotation2;
    CMTime firstFrameTime, secondFrameTime;
    
    BOOL hasSetFirstTexture, hasReceivedFirstFrame, hasReceivedSecondFrame, firstFrameWasVideo, secondFrameWasVideo;
    BOOL firstFrameCheckDisabled, secondFrameCheckDisabled;
}

- (void)disableFirstFrameCheck;
- (void)disableSecondFrameCheck;

@end
