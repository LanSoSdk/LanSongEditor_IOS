//
//  SRScreenRecorder.h
//  ScreenRecorder
//
//  Created by kishikawa katsumi on 2012/12/26.
//  Copyright (c) 2012年 kishikawa katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <TargetConditionals.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BlazeiceCommon.h"
#import "BlazeiceDEBUG.h"

typedef NSString *(^SRScreenRecorderOutputFilenameBlock)();

@interface SRScreenRecorder : NSObject

@property (assign, nonatomic) NSInteger frameInterval;
@property (assign, nonatomic) NSUInteger autosaveDuration; // in second, default value is 600 (10 minutes).
@property (assign, nonatomic) BOOL showsTouchPointer;
@property (copy, nonatomic) SRScreenRecorderOutputFilenameBlock filenameBlock;
@property(strong, nonatomic) UIView *disPlayView;
@property(strong, nonatomic) NSString * savePath;

+ (SRScreenRecorder *)sharedInstance;
- (void)startRecording;
- (void)stopRecording;


@end
