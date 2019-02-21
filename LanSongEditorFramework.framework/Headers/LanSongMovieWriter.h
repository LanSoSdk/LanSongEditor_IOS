#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LanSongContext.h"

#import "LanSongContext.h"
#import "LanSongProgram.h"
#import "LanSongFilter.h"

extern NSString *const kLanSongColorSwizzlingFragmentShaderString;

@protocol LanSongMovieWriterDelegate <NSObject>

@optional
- (void)movieRecordingCompleted;
- (void)movieRecordingFailedWithError:(NSError*)error;

@end

@interface LanSongMovieWriter : NSObject <LanSongInput>
{
    BOOL alreadyFinishedRecording;
    
    NSURL *movieURL;
    NSString *fileType;
	AVAssetWriter *assetWriter;
	AVAssetWriterInput *assetWriterAudioInput;
	AVAssetWriterInput *assetWriterVideoInput;
    AVAssetWriterInputPixelBufferAdaptor *assetWriterPixelBufferInput;
    
    LanSongContext *_movieWriterContext;
    CVPixelBufferRef renderTarget;
    CVOpenGLESTextureRef renderTexture;

    CGSize videoSize;
    LanSongRotationMode inputRotation;
    
    
    //move here
    GLuint movieFramebuffer, movieRenderbuffer;
    
    LanSongProgram *colorSwizzlingProgram;
    GLint colorSwizzlingPositionAttribute, colorSwizzlingTextureCoordinateAttribute;
    GLint colorSwizzlingInputTextureUniform;
    
    LanSongFramebuffer *firstInputFramebuffer;
    
    BOOL discont;
    CMTime startTime, previousFrameTime, previousAudioTime;
    CMTime offsetTime;
    
    dispatch_queue_t audioQueue, videoQueue;
    BOOL audioEncodingIsFinished, videoEncodingIsFinished;
    
    BOOL isRecording;
    int   encodeBitrate;  //新增码率设置.
}

@property(readwrite, nonatomic) BOOL hasAudioTrack;
@property(readwrite, nonatomic) BOOL shouldPassthroughAudio;
@property(readwrite, nonatomic) BOOL shouldInvalidateAudioSampleWhenDone;

/**
 忽略endproceing的回调.
 */
@property(nonatomic, copy) void(^ingoreEndProcessingBlock)(void);
@property(nonatomic, copy) void(^completionBlock)(void);
@property(nonatomic, copy) void(^failureBlock)(NSError*);
@property(nonatomic, assign) id<LanSongMovieWriterDelegate> delegate;
@property(readwrite, nonatomic) BOOL encodingLiveVideo;
@property(nonatomic, copy) BOOL(^videoInputReadyCallback)(void);
@property(nonatomic, copy) BOOL(^audioInputReadyCallback)(void);
@property(nonatomic, copy) void(^audioProcessingCallback)(SInt16 **samplesRef, CMItemCount numSamplesInBuffer);
@property(nonatomic) BOOL enabled;
@property(nonatomic, readonly) AVAssetWriter *assetWriter;
@property(nonatomic, readonly) CMTime duration;
@property(nonatomic, assign) CGAffineTransform transform;
@property(nonatomic, copy) NSArray *metaData;
@property(nonatomic, assign, getter = isPaused) BOOL paused;
@property(nonatomic, retain) LanSongContext *movieWriterContext;

//lanso++
@property(nonatomic, copy) void(^videoProgressBlock)(CGFloat progess);

/**
 当有别的target调用到这里后, 是否忽略endProcessing这个方法
 在多个视频拼接的时候, 前几个视频要忽略这个方法;
 */
@property(nonatomic, assign) BOOL isIngoreEndProcessing;


- (id)initWithMovieURL:(NSURL *)newMovieURL size:(CGSize)newSize;
//lanso++
- (id)initWithMovieURL:(NSURL *)newMovieURL size:(CGSize)newSize bitrate:(int)bitrate;

- (id)initWithMovieURL:(NSURL *)newMovieURL size:(CGSize)newSize fileType:(NSString *)newFileType outputSettings:(NSDictionary *)outputSettings;

- (void)setHasAudioTrack:(BOOL)hasAudioTrack audioSettings:(NSDictionary *)audioOutputSettings;

// Movie recording
- (void)startRecording;
- (void)startRecordingInOrientation:(CGAffineTransform)orientationTransform;
- (void)finishRecording;
- (void)finishRecordingWithCompletionHandler:(void (^)(void))handler;
- (void)cancelRecording;
- (void)processAudioBuffer:(CMSampleBufferRef)audioBuffer;
- (void)enableSynchronizationCallbacks;


//move here
// Movie recording
- (void)initializeMovieWithOutputSettings:(NSMutableDictionary *)outputSettings;

// Frame rendering
- (void)createDataFBO;
- (void)destroyDataFBO;
- (void)setFilterFBO;

- (void)renderAtInternalSizeUsingFramebuffer:(LanSongFramebuffer *)inputFramebufferToUse;
@end
