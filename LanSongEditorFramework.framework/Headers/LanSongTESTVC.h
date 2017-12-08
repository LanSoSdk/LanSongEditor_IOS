//
//  LanSongTESTVC.h
//  LanSongEditorFramework
//
//  Created by sno on 20/11/2017.
//  Copyright © 2017 sno. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 用来开发测试用, 外界请不要使用.
 */
@interface LanSongTESTVC : UIViewController

@end
//{
//
//    [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
//
//    NSURL *inputUrl = [NSURL fileURLWithPath:inputPath isDirectory:NO];
//    AVURLAsset *inputAsset = [AVURLAsset URLAssetWithURL:inputUrl options:nil];
//
//    NSArray *videoTracks = [inputAsset tracksWithMediaType:AVMediaTypeVideo];
//    if (videoTracks.count<1) {
//        NSLog(@"输入文件中 无视频轨道....");
//        return;
//    }
//
//    //创建线程.
//    NSString *reverseQueueDescription = [NSString stringWithFormat:@"%@ reverse queue", self];
//
//    // create main serialization queue
//    dispatch_queue_t reverseQueue = dispatch_queue_create([reverseQueueDescription UTF8String], NULL);
//
//
//    // let's reverse this many frames in each pass
//    int numSamplesInPass = 100; // write to output in <numSamplesInPass> frame increments
//
//    dispatch_async(reverseQueue, ^{
//        NSError *error = nil;
//
//        // for timing if desired
//        NSDate *methodStart;
//
//        // Initialize the reader
//        assetReader = [[AVAssetReader alloc] initWithAsset:inputAsset error:&error];
//        AVAssetTrack *videoTrack = [[inputAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//
//        float fps = videoTrack.nominalFrameRate;
//
//
//        //输出选项设置.
//        readerOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey, nil];
//
//
//        assetReaderOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:videoTrack outputSettings:readerOutputSettings];
//        assetReaderOutput.supportsRandomAccess = YES;  //这里很重要!!!
//        [assetReader addOutput:assetReaderOutput];
//        [assetReader startReading];
//
//
//        CGFloat outputWidth = videoTrack.naturalSize.width;
//        CGFloat outputHeight = videoTrack.naturalSize.height;
//
//        // main array to hold presentation times
//        NSMutableArray *revSampleTimes = [[NSMutableArray alloc] init];
//
//        // for timing
//        methodStart = [NSDate date];
//
//        // now go through the reader output to get some recon on frame presentation times
//        CMSampleBufferRef sample;
//        int localCount = 0;
//        while((sample = [assetReaderOutput copyNextSampleBuffer])) {
//
//            //只是统计时间戳.
//            CMTime presentationTime = CMSampleBufferGetPresentationTimeStamp(sample);
//            NSValue *presentationValue = [NSValue valueWithBytes:&presentationTime objCType:@encode(CMTime)];
//            [revSampleTimes addObject:presentationValue];
//
//
//            CFRelease(sample);
//            sample = NULL;
//
//            localCount++;
//        }
//
//
//
//        // if no frames, format the error and return
//        if (revSampleTimes.count<1) {
//            NSString *msg = [NSString stringWithFormat:@"no video frames found in: %@", inputPath];
//            NSLog(@"%@",msg);
//            return;
//        }
//
//        // create pass info since the reversal may be too large to be achieved in one pass
//
//        // each pass is defined by a time range which we can specify each time we re-init the asset reader
//
//        // array that holds the pass info
//        NSMutableArray *passDicts = [[NSMutableArray alloc] init];
//
//        NSValue *initEventValue = [revSampleTimes objectAtIndex:0];
//        CMTime initEventTime = [initEventValue CMTimeValue];
//
//        CMTime passStartTime = [initEventValue CMTimeValue];
//        CMTime passEndTime = [initEventValue CMTimeValue];
//
//        int timeStartIndex = -1;
//        int timeEndIndex = -1;
//        int frameStartIndex = -1;
//        int frameEndIndex = -1;
//
//        NSValue *timeEventValue, *frameEventValue;
//        NSValue *passStartValue, *passEndValue;
//        CMTime timeEventTime, frameEventTime;
//
//        int totalPasses = (int)ceil((float)revSampleTimes.count / (float)numSamplesInPass);
//
//        BOOL initNewPass = NO;
//        for (NSInteger i=0; i<revSampleTimes.count; i++) {
//
//            timeEventValue = [revSampleTimes objectAtIndex:i];
//            timeEventTime = [timeEventValue CMTimeValue];
//
//            frameEventValue = [revSampleTimes objectAtIndex:(revSampleTimes.count - 1 - i)];
//            frameEventTime = [frameEventValue CMTimeValue];
//
//            passEndTime = timeEventTime;
//            timeEndIndex = (int)i;
//            frameEndIndex = (int)(revSampleTimes.count - 1 - i);
//
//            // if this is a pass border
//            if (i%numSamplesInPass == 0) {
//                // record new pass
//                if (i>0) {
//                    passStartValue = [NSValue valueWithBytes:&passStartTime objCType:@encode(CMTime)];
//                    passEndValue = [NSValue valueWithBytes:&passEndTime objCType:@encode(CMTime)];
//                    NSDictionary *dict = @{
//                                           @"passStartTime": passStartValue,
//                                           @"passEndTime": passEndValue,
//                                           @"timeStartIndex" : [NSNumber numberWithLong:timeStartIndex],
//                                           @"timeEndIndex": [NSNumber numberWithLong:timeEndIndex],
//                                           @"frameStartIndex" : [NSNumber numberWithLong:frameStartIndex],
//                                           @"frameEndIndex": [NSNumber numberWithLong:frameEndIndex]
//                                           };
//                    [passDicts addObject:dict];
//                }
//                initNewPass = YES;
//            }
//
//            // if new pass then init the main vars
//            if (initNewPass) {
//                passStartTime = timeEventTime;
//                timeStartIndex = (int)i;
//                frameStartIndex = (int)(revSampleTimes.count - 1 - i);
//                initNewPass = NO;
//            }
//        }
//
//        // handle last pass
//        if ((passDicts.count < totalPasses) || revSampleTimes.count%numSamplesInPass != 0) {
//            passStartValue = [NSValue valueWithBytes:&passStartTime objCType:@encode(CMTime)];
//            passEndValue = [NSValue valueWithBytes:&passEndTime objCType:@encode(CMTime)];
//            NSDictionary *dict = @{
//                                   @"passStartTime": passStartValue,
//                                   @"passEndTime": passEndValue,
//                                   @"timeStartIndex" : [NSNumber numberWithLong:timeStartIndex],
//                                   @"timeEndIndex": [NSNumber numberWithLong:timeEndIndex],
//                                   @"frameStartIndex" : [NSNumber numberWithLong:frameStartIndex],
//                                   @"frameEndIndex": [NSNumber numberWithLong:frameEndIndex]
//                                   };
//            [passDicts addObject:dict];
//        }
//
//        //// writer setup
//
//        // set the desired output URL for the file created by the export process
//        NSURL *outputURL = [NSURL fileURLWithPath:outputPath isDirectory:NO];
//
//        // initialize the writer -- NOTE: this assumes a QT output file type
//        assetWriter = [[AVAssetWriter alloc] initWithURL:outputURL
//                                                fileType:AVFileTypeQuickTimeMovie // AVFileTypeMPEG4
//                                                   error:&error];
//        NSDictionary *writerOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
//                                              AVVideoCodecH264, AVVideoCodecKey,
//                                              [NSNumber numberWithInt:outputWidth], AVVideoWidthKey,
//                                              [NSNumber numberWithInt:outputHeight], AVVideoHeightKey,
//                                              nil];
//
//        assetWriterInput = [AVAssetWriterInput
//                            assetWriterInputWithMediaType:AVMediaTypeVideo
//                            outputSettings:writerOutputSettings];
//
//        [assetWriterInput setExpectsMediaDataInRealTime:NO];
//        [assetWriterInput setTransform:[videoTrack preferredTransform]];
//
//        // create the pixel buffer adaptor needed to add presentation time to output frames
//        AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
//                                                         assetWriterInputPixelBufferAdaptorWithAssetWriterInput:assetWriterInput
//                                                         sourcePixelBufferAttributes:nil];
//        [assetWriter addInput:assetWriterInput];
//
//        [assetWriter startWriting];
//        [assetWriter startSessionAtSourceTime:initEventTime];
//
//        int frameCount = 0; // master frame counter
//        int fpsInt = (int)(fps + 0.5);
//
//
//        // now go through the read passes and write to output
//        for (NSInteger z=passDicts.count-1; z>=0; z--) {
//            NSDictionary *dict = [passDicts objectAtIndex:z];
//
//            passStartValue = dict[@"passStartTime"];
//            passStartTime = [passStartValue CMTimeValue];
//
//            passEndValue = dict[@"passEndTime"];
//            passEndTime = [passEndValue CMTimeValue];
//
//            CMTime passDuration = CMTimeSubtract(passEndTime, passStartTime);
//
//            //            int timeStartIx = (int)[dict[@"timeStartIndex"] longValue];
//            //            int timeEndIx = (int)[dict[@"timeEndIndex"] longValue];
//            //
//            //            int frameStartIx = (int)[dict[@"frameStartIndex"] longValue];
//            //            int frameEndIx = (int)[dict[@"frameEndIndex"] longValue];
//
//
//            CMTimeRange localRange = CMTimeRangeMake(passStartTime,passDuration);
//            NSValue *localRangeValue = [NSValue valueWithBytes:&localRange objCType:@encode(CMTimeRange)];
//            NSMutableArray *localRanges = [[NSMutableArray alloc] init];
//            [localRanges addObject:localRangeValue];
//
//            // make sure we have no remaining samples from last time range
//            while((sample = [assetReaderOutput copyNextSampleBuffer])) {
//                CFRelease(sample);
//            }
//
//
//            // reset the reader to the range of the pass
//            [assetReaderOutput resetForReadingTimeRanges:localRanges];
//
//            // read in the samples of the pass  设置了读取段后,才增加这一段的视频帧数据.
//            NSMutableArray *samples = [[NSMutableArray alloc] init];
//            while((sample = [assetReaderOutput copyNextSampleBuffer])) {
//                [samples addObject:(__bridge id)sample];
//                CFRelease(sample);
//            }
//
//            // append samples to output using the recorded frame times
//            for (NSInteger i=0; i<samples.count; i++) {
//                // make sure we have valid event time
//                if (frameCount >= revSampleTimes.count) {
//                    NSLog(@"%s pass %ld: more samples than recorded frames! %d >= %lu ", __FUNCTION__, (long)z, frameCount, (unsigned long)revSampleTimes.count);
//                    break;
//                }
//
//                // get the orig presentation time (from start to end)
//                NSValue *eventValue = [revSampleTimes objectAtIndex:frameCount];
//                CMTime eventTime = [eventValue CMTimeValue];
//
//                // take the image/pixel buffer from tail end of the array
//                //拿到PixelBuffer,填入到编码器中.
//                CVPixelBufferRef imageBufferRef = CMSampleBufferGetImageBuffer((__bridge CMSampleBufferRef)samples[samples.count - i - 1]);
//
//                // append frames to output
//                BOOL append_ok = NO;
//                int j = 0;
//                while (!append_ok && j < fpsInt) {
//
//                    if (adaptor.assetWriterInput.readyForMoreMediaData) {
//                        append_ok = [adaptor appendPixelBuffer:imageBufferRef withPresentationTime:eventTime];
//                        if (!append_ok)
//                            NSLog(@"%s Problem appending frame at time: %lld", __FUNCTION__, eventTime.value);
//                    }
//                    else {
//                        // adaptor not ready
//                        [NSThread sleepForTimeInterval:0.05];
//                    }
//
//                    j++;
//                }
//
//                if (!append_ok)
//                    NSLog(@"%s error appending frame %d; times %d", __FUNCTION__, frameCount, j);
//
//                frameCount++;
//            }
//            samples = nil;
//        }
//
//        [assetWriterInput markAsFinished];
//
//        [assetWriter finishWritingWithCompletionHandler:^(){
//            NSLog(@"写入完毕.....");
//        }];
//    });
//
//}
