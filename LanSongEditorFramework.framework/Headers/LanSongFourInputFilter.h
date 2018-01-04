#import "LanSongThreeInputFilter.h"

extern NSString *const kLanSongFourInputTextureVertexShaderString;

@interface LanSongFourInputFilter : LanSongThreeInputFilter
{
    LanSongFramebuffer *fourthInputFramebuffer;

    GLint filterFourthTextureCoordinateAttribute;
    GLint filterInputTextureUniform4;
    LanSongRotationMode inputRotation4;
    GLuint filterSourceTexture4;
    CMTime fourthFrameTime;
    
    BOOL hasSetThirdTexture, hasReceivedFourthFrame, fourthFrameWasVideo;
    BOOL fourthFrameCheckDisabled;
}

- (void)disableFourthFrameCheck;

@end
