//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class SegmentRecorder;
@protocol SegmentRecorderDelegate <NSObject>

@optional
/**
 开始录制一段视频的时候, 回调.

 @return
 */
- (void)videoRecorder:(SegmentRecorder *)videoRecorder didStartRecordingToOutPutFileAtURL:(NSURL *)fileURL;


//recorder完成一段视频的录制时

/**
 
  录制完一段视频的回调
 @param videoRecorder 对象
 @param outputFileURL 当前段录制的视频文件
 @param videoDuration 当前段的时长
 @param totalDur 已经录制好的总时长
 @param error
 */
- (void)videoRecorder:(SegmentRecorder *)videoRecorder didFinishRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration totalDur:(CGFloat)totalDur error:(NSError *)error;

/**
 正在录制一段

 @param videoRecorder <#videoRecorder description#>
 @param outputFileURL <#outputFileURL description#>
 @param videoDuration <#videoDuration description#>
 @param totalDur <#totalDur description#>
 */
- (void)videoRecorder:(SegmentRecorder *)videoRecorder didRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration recordedVideosTotalDur:(CGFloat)totalDur;


/**
 删除当前段的回调

 @param videoRecorder <#videoRecorder description#>
 @param fileURL <#fileURL description#>
 @param totalDur <#totalDur description#>
 @param error <#error description#>
 */
- (void)videoRecorder:(SegmentRecorder *)videoRecorder didRemoveVideoFileAtURL:(NSURL *)fileURL totalDur:(CGFloat)totalDur error:(NSError *)error;


/**
 视频最后合成完毕.

 @param videoRecorder 对象
 @param outputFileURL 合成后的输出文件.
 */
- (void)videoRecorder:(SegmentRecorder *)videoRecorder didFinishMergingVideosToOutPutFileAtURL:(NSURL *)outputFileURL ;

@end

@interface SegmentRecorder : NSObject <AVCaptureFileOutputRecordingDelegate>

@property (weak, nonatomic) id <SegmentRecorderDelegate> delegate;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preViewLayer;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureMovieFileOutput *movieFileOutput;

/**
 设置的最大录制的时长, 单位 秒.
 */
@property int settingMaxDuration;

- (CGFloat)getTotalVideoDuration;
- (void)stopCurrentVideoRecording;
- (void)startRecordingToOutputFileURL:(NSURL *)fileURL;


/**
 删除最后一段视频, 删除后, 会通过SegmentRecorderDelegate返回.
 */
- (void)deleteLastVideo;

/**
 删除所有视频, 删除后, 没有回调返回.
 */
- (void)deleteAllVideo;

- (NSUInteger)getVideoCount;

- (void)mergeVideoFiles;

- (BOOL)isCameraSupported;
- (BOOL)isFrontCameraSupported;
- (BOOL)isTorchSupported;

- (void)switchCamera;
- (void)openTorch:(BOOL)open;

- (void)focusInPoint:(CGPoint)touchPoint;

@end
