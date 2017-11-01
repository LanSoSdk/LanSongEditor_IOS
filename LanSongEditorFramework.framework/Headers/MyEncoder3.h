//
//  MyEncoder3.h
//  LanSongEditorFramework
//
//  Created by sno on 2017/9/11.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LanSongContext.h"
#import "Pen.h"
#import "ViewPen.h"
#import "CALayerPen.h"
#import "DrawPadView.h"


//不能相互导入,但可以申明一个外部类.

@class CameraPen;

@class BitmapPen;
@class ViewPen;

@class CALayerPen;



extern NSString *const kMyEncoder3LanSongColorSwizzlingFragmentShaderString;


/**
 此头文件为SDK内部使用, 其他地方请勿使用.
 此头文件为SDK内部使用, 其他地方请勿使用.
 此头文件为SDK内部使用, 其他地方请勿使用.
 此头文件为SDK内部使用, 其他地方请勿使用.
 */
@protocol MyEncoder3Delegate <NSObject>

@optional
- (void)movieRecordingCompleted;
- (void)movieRecordingFailedWithError:(NSError*)error;

@end

@interface MyEncoder3 : NSObject <LanSongInput>
{
    BOOL alreadyFinishedRecording;
    
    NSURL *movieURL;
    NSString *fileType;
    AVAssetWriter *assetWriter;
    AVAssetWriterInput *assetWriterAudioInput;  //音频写入对象.
    
    AVAssetWriterInput *assetWriterVideoInput;
    AVAssetWriterInputPixelBufferAdaptor *assetWriterPixelBufferInput;
    
    LanSongContext *_movieWriterContext;
    CVPixelBufferRef renderTarget;
    CVOpenGLESTextureRef renderTexture;
    
    CGSize videoSize;
    LanSongRotationMode inputRotation;
}

@property(readwrite, nonatomic) BOOL hasAudioTrack;
@property(readwrite, nonatomic) BOOL shouldPassthroughAudio;
@property(readwrite, nonatomic) BOOL shouldInvalidateAudioSampleWhenDone;
@property(nonatomic, copy) void(^completionBlock)(void);
@property(nonatomic, copy) void(^failureBlock)(NSError*);
@property(nonatomic, assign) id<MyEncoder3Delegate> delegate;
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

//- (id)initWithMovieURL:(NSURL *)newMovieURL size:(CGSize)newSize;
//- (id)initWithMovieURL:(NSURL *)newMovieURL size:(CGSize)newSize fileType:(NSString *)newFileType outputSettings:(NSDictionary *)outputSettings;

- (void)setHasAudioTrack:(BOOL)hasAudioTrack audioSettings:(NSDictionary *)audioOutputSettings;

// Movie recording
- (void)startRecording;
- (void)startRecordingInOrientation:(CGAffineTransform)orientationTransform;
- (void)finishRecording;
- (void)finishRecordingWithCompletionHandler:(void (^)(void))handler;
- (void)cancelRecording;
- (void)processAudioBuffer:(CMSampleBufferRef)audioBuffer;
- (void)enableSynchronizationCallbacks;


- (id)initWithPadSize:(CGSize)newSize;


/**
 编码参数

 @param newMovieURL 目标地址
 */
-(void)setEncodeParamWithURL:(NSURL *)newMovieURL;


- (void)addPen:(Pen *)pen;

-(void)removePen:(Pen *)pen;


/**
 内部使用.
 */
-(void)setDrawPadDisplay:(DrawPadView *)display;


/**
 内部使用.
 */
-(void)releaseEncoder;
@property(nonatomic, copy) void(^onProgressBlock)(CGFloat currentPts);  //这个只是回调, 直接执行.


/**
 camera录制暂时不清楚在哪里能使用.
 if (self.onCompletedBlock)
 {
 self.onCompletedBlock();
 self.onCompletedBlock=nil; //这里只调用一次.
 }
 */
@property(nonatomic, copy) void(^onCompletedBlock)(void);  //这个只是回调, 直接执行.



- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;
@end
