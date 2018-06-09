#import "LanSongFilter.h"

@interface LanSongTwoPassFilter : LanSongFilter
{
    LanSongFramebuffer *secondOutputFramebuffer;

    LanSongProgram *secondFilterProgram;
    GLint secondFilterPositionAttribute, secondFilterTextureCoordinateAttribute;
    GLint secondFilterInputTextureUniform, secondFilterInputTextureUniform2;
    
    NSMutableDictionary *secondProgramUniformStateRestorationBlocks;
}

// Initialization and teardown
- (id)initWithFirstStageVertexShaderFromString:(NSString *)firstStageVertexShaderString firstStageFragmentShaderFromString:(NSString *)firstStageFragmentShaderString secondStageVertexShaderFromString:(NSString *)secondStageVertexShaderString secondStageFragmentShaderFromString:(NSString *)secondStageFragmentShaderString;
- (id)initWithFirstStageFragmentShaderFromString:(NSString *)firstStageFragmentShaderString secondStageFragmentShaderFromString:(NSString *)secondStageFragmentShaderString;
- (void)initializeSecondaryAttributes;

@end
