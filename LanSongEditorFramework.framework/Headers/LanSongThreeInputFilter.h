#import "LanSongTwoInputFilter.h"

extern NSString *const kLanSongThreeInputTextureVertexShaderString;

@interface LanSongThreeInputFilter : LanSongTwoInputFilter
{
    LanSongFramebuffer *thirdInputFramebuffer;

    GLint filterThirdTextureCoordinateAttribute;
    GLint filterInputTextureUniform3;
    LanSongRotationMode inputRotation3;
    GLuint filterSourceTexture3;
    CMTime thirdFrameTime;
    
    BOOL hasSetSecondTexture, hasReceivedThirdFrame, thirdFrameWasVideo;
    BOOL thirdFrameCheckDisabled;
}

- (void)disableThirdFrameCheck;

@end
