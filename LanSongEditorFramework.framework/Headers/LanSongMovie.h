#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LanSongContext.h"
#import "LanSongOutput.h"
#import "LSOMediaInfo.h"

/** Protocol for getting Movie played callback.
 */
@protocol LanSongMovieDelegate <NSObject>

- (void)didCompletePlayingMovie;
@end







@interface LanSongMovie : LanSongOutput



@property (readwrite, retain) AVAsset *asset;
@property (readwrite, retain) AVPlayerItem *playerItem;
@property(readwrite, retain) NSURL *url;

@property(readonly, nonatomic)LSOMediaInfo *mediaInfo;
/**
 解码的开始时间
 只使用在后台
 */
@property(readwrite, nonatomic) float startTimeS;

/**
 解码的裁剪时长;
 只使用在后台
 */
@property(readwrite, nonatomic) float durationTimeS;


@property(readwrite, nonatomic) BOOL runBenchmark;

@property(readwrite, nonatomic) BOOL playAtActualSpeed;

@property(readwrite, nonatomic) BOOL shouldRepeat;

@property(readonly, nonatomic) float progress;

@property (readwrite, nonatomic, assign) id <LanSongMovieDelegate>delegate;

@property (readonly, nonatomic) AVAssetReader *assetReader;
@property (readonly, nonatomic) BOOL audioEncodingIsFinished;
@property (readonly, nonatomic) BOOL videoEncodingIsFinished;

/// @name Initialization and teardown
- (id)initWithAsset:(AVAsset *)asset;
- (id)initWithPlayerItem:(AVPlayerItem *)playerItem;
- (id)initWithURL:(NSURL *)url;
- (void)yuvConversionSetup;

/// @name Movie processing
- (void)enableSynchronizedEncodingUsingMovieWriter:(LanSongMovieWriter *)movieWriter;
- (BOOL)readNextVideoFrameFromOutput:(AVAssetReaderOutput *)readerVideoTrackOutput;
- (BOOL)readNextAudioSampleFromOutput:(AVAssetReaderOutput *)readerAudioTrackOutput;
- (void)startProcessing;
- (void)endProcessing;

- (void)cancelProcessing;
- (void)processMovieFrame:(CMSampleBufferRef)movieSampleBuffer; 

@end
