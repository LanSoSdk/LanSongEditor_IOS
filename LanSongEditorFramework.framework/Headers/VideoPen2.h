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
#import "Pen.h"
#import "MediaInfo.h"


/**
 视频图层,
 用在视频后台处理;
 */
@interface VideoPen2 : Pen

@property (readwrite, assign) CGFloat offsetSendTimeS;
@property(nonatomic,readonly) MediaInfo *mediaInfo;
//----------------一下方法内部使用-----------------------------
@property (readwrite, retain) AVAsset *asset;
@property (readwrite, retain) AVPlayerItem *playerItem;
@property(readwrite, retain) NSURL *url;

@property(readwrite, nonatomic) BOOL shouldRepeat;

@property(readonly, nonatomic) float progress;

@property (readonly, nonatomic) AVAssetReader *assetReader;
@property (readonly, nonatomic) BOOL audioEncodingIsFinished;
@property (readonly, nonatomic) BOOL videoEncodingIsFinished;



/// @name Initialization and teardown
- (id)initWithPlayerItem:(AVPlayerItem *)playerItem;

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

@end
