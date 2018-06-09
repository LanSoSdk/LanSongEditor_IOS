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

/** LanSong's base filter class
 
 Filters and other subsequent elements in the chain conform to the LanSongInput protocol, which lets them take in the supplied or processed texture from the previous link in the chain and do something with it. Objects one step further down the chain are considered targets, and processing can be branched by adding multiple targets to a single output or filter.
 */
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

@property(readonly) CVPixelBufferRef renderTarget;
@property(readwrite, nonatomic) BOOL preventRendering;
@property(readwrite, nonatomic) BOOL currentlyReceivingMonochromeInput;

/// @name Initialization and teardown

/**
 Initialize with vertex and fragment shaders
 
 You make take advantage of the SHADER_STRING macro to write your shaders in-line.
 @param vertexShaderString Source code of the vertex shader to use
 @param fragmentShaderString Source code of the fragment shader to use
 */
- (id)initWithVertexShaderFromString:(NSString *)vertexShaderString fragmentShaderFromString:(NSString *)fragmentShaderString;

/**
 Initialize with a fragment shader
 
 You may take advantage of the SHADER_STRING macro to write your shader in-line.
 @param fragmentShaderString Source code of fragment shader to use
 */
- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString;
/**
 Initialize with a fragment shader
 @param fragmentShaderFilename Filename of fragment shader to load
 */
- (id)initWithFragmentShaderFromFile:(NSString *)fragmentShaderFilename;
- (void)initializeAttributes;
- (void)setupFilterForSize:(CGSize)filterFrameSize;
- (CGSize)rotatedSize:(CGSize)sizeToRotate forIndex:(NSInteger)textureIndex;
- (CGPoint)rotatedPoint:(CGPoint)pointToRotate forRotation:(LanSongRotationMode)rotation;

/// @name Managing the display FBOs
/** Size of the frame buffer object
 */
- (CGSize)sizeOfFBO;

/// @name Rendering
+ (const GLfloat *)textureCoordinatesForRotation:(LanSongRotationMode)rotationMode;
- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
- (void)informTargetsAboutNewFrameAtTime:(CMTime)frameTime;
- (CGSize)outputFrameSize;

/// @name Input parameters
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
