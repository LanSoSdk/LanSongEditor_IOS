#import "LanSongContext.h"
#import "LanSongFramebuffer.h"
#import "LSOObject.h"

#import <UIKit/UIKit.h>

dispatch_queue_attr_t LanSongDefaultQueueAttribute(void);
void runOnMainQueueWithoutDeadlock(void (^block)(void));
void runSynchronouslyOnVideoProcessQueue(void (^block)(void));
void runAsynchronouslyOnVideoProcessQueue(void (^block)(void));


void runSyncOnContextQueue(LanSongContext *context, void (^block)(void));
void runAsyncOnContextQueue(LanSongContext *context, void (^block)(void));
void runAsyncOnNewQueue(void (^block)(void));

@class LanSongMovieWriter;

@interface LanSongOutput : LSOObject
{
    //当前图层的纹理对象
    LanSongFramebuffer *outputFramebuffer;
    LanSongFramebuffer *outputFramebufferRotation;  //有角度旋转的;
    
    NSMutableArray *targets, *targetTextureIndices;
    
    
    CGSize inputTextureSize, cachedMaximumOutputSize, forcedMaximumSize;
    
    //覆盖输入尺寸,强制下发对target的尺寸
    BOOL overrideInputSize;
    
    BOOL allTargetsWantMonochromeData;
    BOOL usingNextFrameForImageCapture;
}

/**
 当执行到这个滤镜时, 是否要设置画面缩放;
 默认是不缩放;
 */
@property(readwrite, nonatomic) CGSize outputScaleSize;


@property(readwrite, nonatomic) BOOL shouldSmoothlyScaleOutput;
@property(readwrite, nonatomic) BOOL shouldIgnoreUpdatesToThisTarget;
@property(readwrite, nonatomic, retain) LanSongMovieWriter *audioEncodingTarget;
@property(readwrite, nonatomic, unsafe_unretained) id<LanSongInput> targetToIgnoreForUpdates;
@property(nonatomic, copy) void(^frameProcessingCompletionBlock)(LanSongOutput*, CMTime);
@property(nonatomic) BOOL enabled;
@property(readwrite, nonatomic) LSOTextureOptions outputTextureOptions;

- (void)setInputFramebufferForTarget:(id<LanSongInput>)target atIndex:(NSInteger)inputTextureIndex;
- (LanSongFramebuffer *)framebufferForOutput;
- (void)removeOutputFramebuffer;
- (void)notifyTargetsAboutNewOutputTexture;

- (NSArray*)targets;
- (void)addTarget:(id<LanSongInput>)newTarget;

- (void)addTarget:(id<LanSongInput>)newTarget atTextureLocation:(NSInteger)textureLocation;
- (void)removeTarget:(id<LanSongInput>)targetToRemove;
- (void)removeAllTargets;

- (void)forceProcessingAtSize:(CGSize)frameSize;
- (void)forceProcessingAtSizeRespectingAspectRatio:(CGSize)frameSize;

- (void)useNextFrameForImageCapture;
- (CGImageRef)newCGImageFromCurrentlyProcessedOutput;
- (CGImageRef)newCGImageByFilteringCGImage:(CGImageRef)imageToFilter;

- (UIImage *)imageFromCurrentFramebuffer;
- (UIImage *)imageFromCurrentFramebufferWithOrientation:(UIImageOrientation)imageOrientation;
- (UIImage *)imageByFilteringImage:(UIImage *)imageToFilter;
- (CGImageRef)newCGImageByFilteringImage:(UIImage *)imageToFilter;

- (BOOL)providesMonochromeOutput;

@end
