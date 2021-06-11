//
//  VideoPen2.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/6/21.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
#import "LanSongContext.h"
#import "LanSongOutput.h"
#import "LSOPen.h"


/**
 视频图层,
 用在视频后台处理;
 */
@interface LSOVideoPen2 : LSOPen

@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) CGFloat duration;



@property (readwrite, assign) CGFloat offsetSendTimeS;
//----------------一下方法内部使用-----------------------------
@property (readwrite, retain) AVAsset *asset;
@property (readwrite, retain) AVPlayerItem *playerItem;
@property(readwrite, retain) NSURL *url;

@property(readwrite, nonatomic) BOOL shouldRepeat;

@property(readonly, nonatomic) float progress;

@property (readonly, nonatomic) AVAssetReader *assetReader;
@property (readonly, nonatomic) BOOL audioEncodingIsFinished;
@property (readonly, nonatomic) BOOL videoEncodingIsFinished;



//lansong++
- (id)initWithURL:(NSURL *)url padSize:(CGSize)size;
- (id)initWithAsset:(AVAsset *)asset padSize:(CGSize)size;

- (void)yuvConversionSetup;

/// @name Movie processing
- (void)enableSynchronizedEncodingUsingMovieWriter:(LanSongMovieWriter *)movieWriter;
- (BOOL)readNextVideoFrameFromOutput:(AVAssetReaderOutput *)readerVideoTrackOutput;
- (BOOL)readNextAudioSampleFromOutput:(AVAssetReaderOutput *)readerAudioTrackOutput;
- (void)startProcessing;
- (void)endProcessing;

- (void)cancelProcessing;
- (void)processMovieFrame:(CMSampleBufferRef)movieSampleBuffer;



/**
 增加d第二个黑白动画视频
 [特定客户使用]
 
 @param secondVideo 第二个视频路径
 @param isLoop 是否循环
 @param volume 第二个视频如果有声音,则声音大小;
 @return 成功返回YES;
 */
-(BOOL)setSecondVideo:(NSURL *)secondVideo loop:(BOOL)isLoop volume:(float)volume;

/**
 [特定客户使用]
 */
-(void)removeSecondVideo;

@end
