//#import "LanSongOutput.h"

#import "LanSongOutput.h"


#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

#define LanSongHashIdentifier #
#define LanSongWrappedLabel(x) x
#define LanSongEscapedHashIdentifier(a) LanSongWrappedLabel(LanSongHashIdentifier)a

extern NSString *const kLanSongVertexShaderString;
extern NSString *const kLanSongPassthroughFragmentShaderString;

struct LanSongVector4 {
    GLfloat one;
    GLfloat two;
    GLfloat three;
    GLfloat four;
};
typedef struct LanSongVector4 LanSongVector4;

struct LanSongVector3 {
    GLfloat one;
    GLfloat two;
    GLfloat three;
};
typedef struct LanSongVector3 LanSongVector3;

struct LanSongMatrix4x4 {
    LanSongVector4 one;
    LanSongVector4 two;
    LanSongVector4 three;
    LanSongVector4 four;
};
typedef struct LanSongMatrix4x4 LanSongMatrix4x4;

struct LanSongMatrix3x3 {
    LanSongVector3 one;
    LanSongVector3 two;
    LanSongVector3 three;
};
typedef struct LanSongMatrix3x3 LanSongMatrix3x3;


/// 所有的滤镜的父类;
@interface LanSongFilter : LanSongOutput <LanSongInput>
{
    LanSongFramebuffer *firstInputFramebuffer;
    
    LanSongProgram *filterProgram;
    GLint filterPositionAttribute, filterTextureCoordinateAttribute;
    GLint filterInputTextureUniform;
    GLfloat backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha;
    
    BOOL isEndProcessing;

    CGSize currentFilterSize;
    LanSongRotationMode inputRotation;
    
    BOOL currentlyReceivingMonochromeInput;
    
    NSMutableDictionary *uniformStateRestorationBlocks;
    dispatch_semaphore_t imageCaptureSemaphore;
}

/// 是否支持调节;
@property(readwrite, nonatomic) BOOL isSupportAdjust;



/*******************************一下是内部使用*********************************************************/
/**
 内部使用;
 */
@property(readwrite, nonatomic) BOOL disableFilter;
@property(readonly) CVPixelBufferRef renderTarget;
@property(readwrite, nonatomic) BOOL preventRendering;  //是否阻止渲染;
@property(readwrite, nonatomic) BOOL currentlyReceivingMonochromeInput;
- (id)initWithVertexShaderFromString:(NSString *)vertexShaderString fragmentShaderFromString:(NSString *)fragmentShaderString;
- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString;
- (id)initWithFragmentShaderFromFile:(NSString *)fragmentShaderFilename;
- (void)initializeAttributes;
- (void)setupFilterForSize:(CGSize)filterFrameSize;
- (CGSize)rotatedSize:(CGSize)sizeToRotate forIndex:(NSInteger)textureIndex;
- (CGPoint)rotatedPoint:(CGPoint)pointToRotate forRotation:(LanSongRotationMode)rotation;
- (CGSize)sizeOfFBO;
+ (const GLfloat *)textureCoordinatesForRotation:(LanSongRotationMode)rotationMode;
- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
- (void)informTargetsAboutNewFrameAtTime:(CMTime)frameTime;
- (CGSize)outputFrameSize;
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;
- (void)setInteger:(GLint)newInteger forUniformName:(NSString *)uniformName;
- (void)setFloat:(GLfloat)newFloat forUniformName:(NSString *)uniformName;
- (void)setSize:(CGSize)newSize forUniformName:(NSString *)uniformName;
- (void)setPoint:(CGPoint)newPoint forUniformName:(NSString *)uniformName;
- (void)setFloatVec3:(LanSongVector3)newVec3 forUniformName:(NSString *)uniformName;
- (void)setFloatVec4:(LanSongVector4)newVec4 forUniform:(NSString *)uniformName;
- (void)setFloatArray:(GLfloat *)array length:(GLsizei)count forUniform:(NSString*)uniformName;

- (void)setMatrix3f:(LanSongMatrix3x3)matrix forUniform:(GLint)uniform program:(LanSongProgram *)LanSongProgram;
- (void)setMatrix4f:(LanSongMatrix4x4)matrix forUniform:(GLint)uniform program:(LanSongProgram *)LanSongProgram;
- (void)setFloat:(GLfloat)floatValue forUniform:(GLint)uniform program:(LanSongProgram *)LanSongProgram;
- (void)setPoint:(CGPoint)pointValue forUniform:(GLint)uniform program:(LanSongProgram *)LanSongProgram;
- (void)setSize:(CGSize)sizeValue forUniform:(GLint)uniform program:(LanSongProgram *)LanSongProgram;
- (void)setVec3:(LanSongVector3)vectorValue forUniform:(GLint)uniform program:(LanSongProgram *)LanSongProgram;
- (void)setVec4:(LanSongVector4)vectorValue forUniform:(GLint)uniform program:(LanSongProgram *)LanSongProgram;
- (void)setFloatArray:(GLfloat *)arrayValue length:(GLsizei)arrayLength forUniform:(GLint)uniform program:(LanSongProgram *)LanSongProgram;
- (void)setInteger:(GLint)intValue forUniform:(GLint)uniform program:(LanSongProgram *)LanSongProgram;

- (void)setAndExecuteUniformStateCallbackAtIndex:(GLint)uniform forProgram:(LanSongProgram *)LanSongProgram toBlock:(dispatch_block_t)uniformStateBlock;
- (void)setUniformsForProgramAtIndex:(NSUInteger)programIndex;

@end
