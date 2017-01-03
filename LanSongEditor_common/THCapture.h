//
//  THCapture.h
//  ScreenCaptureViewTest
//
//  Created by wayne li on 11-8-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BlazeiceCommon.h"
#import "BlazeiceDEBUG.h"

@protocol THCaptureDelegate;
@interface THCapture : NSObject{
    
    AVAssetWriter *videoWriter;
	AVAssetWriterInput *videoWriterInput;
	AVAssetWriterInputPixelBufferAdaptor *avAdaptor;
    //recording state
	BOOL           _recording;     //正在录制中
    BOOL           _writing;       //正在将帧写入文件
	NSDate         *startedAt;     //录制的开始时间
    CGContextRef   context;        //绘制layer的context
    NSTimer        *timer;         //按帧率写屏的定时器
    
    //Capture Layer
    CALayer *_captureLayer;              //要绘制的目标layer
    NSUInteger  _frameRate;              //帧速
    id<THCaptureDelegate> _delegate;     //代理
}
@property(assign) NSUInteger frameRate;
@property(assign) float spaceDate;//秒
@property(nonatomic, strong) CALayer *captureLayer;
@property(nonatomic, strong) id<THCaptureDelegate> delegate;

//开始录制
- (bool)startRecording1;
//结束录制
- (void)stopRecording;

@end


@protocol THCaptureDelegate <NSObject>

- (void)recordingFinished:(NSString*)outputPath;
- (void)recordingFaild:(NSError *)error;

@end
