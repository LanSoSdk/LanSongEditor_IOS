//
//  THCapture.m
//  ScreenCaptureViewTest
//
//  Created by wayne li on 11-8-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "THCapture.h"
//#import "BlazeiceAppDelegate.h"


@interface THCapture()

//录制每一帧
- (void)drawFrame;
@end

@implementation THCapture
@synthesize frameRate=_frameRate;
@synthesize captureLayer=_captureLayer;
@synthesize delegate=_delegate;

- (id)init
{
    self = [super init];
    if (self) {
        _frameRate=10;//默认帧率为10
    }
    
    return self;
}

- (void)dealloc {
}

#pragma mark -
#pragma mark CustomMethod

- (bool)startRecording1
{
    bool result = NO;
    if (! _recording && _captureLayer)
    {
            startedAt = [NSDate date];
            _spaceDate=0;
            _recording = true;
            _writing = false;
            //绘屏的定时器
            NSDate *nowDate = [NSDate date];
            timer = [[NSTimer alloc] initWithFireDate:nowDate interval:1.0/_frameRate target:self selector:@selector(drawFrame) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
	return result;
}

- (void)stopRecording
{
    if (_recording) {
         _recording = false;
        [timer invalidate];
        timer = nil;
    }
}
- (void)drawFrame
{
    if (!_writing) {
        [self performSelectorInBackground:@selector(getFrame) withObject:nil];
    }
}

- (void)getFrame
{
    if (!_writing) {
        _writing = true;
          CGSize size = self.captureLayer.frame.size;
        if (context== NULL)
        {
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            context = CGBitmapContextCreate (NULL,
                                             size.width,
                                             size.height,
                                             8,//bits per component
                                             size.width * 4,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipFirst);
            CGColorSpaceRelease(colorSpace);
            CGContextSetAllowsAntialiasing(context,NO);
            CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0,-1, 0, size.height);
            CGContextConcatCTM(context, flipVertical);
        }

        size_t width  = CGBitmapContextGetWidth(context);
        size_t height = CGBitmapContextGetHeight(context);
        @try {
            CGContextClearRect(context, CGRectMake(0, 0,width , height));
            [self.captureLayer renderInContext:context];
            
         //   NSLog(@"layer ..可以得到图片");
            
            self.captureLayer.contents=nil;
            CGImageRef cgImage = CGBitmapContextCreateImage(context);
            UIImage *viewImage=[[UIImage alloc] initWithCGImage:cgImage];
            UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片图
//            if (_recording) {
//                float millisElapsed = [[NSDate date] timeIntervalSinceDate:startedAt] * 1000.0-_spaceDate*1000.0;
//                //NSLog(@"millisElapsed = %f",millisElapsed);
//                [self writeVideoFrameAtTime:CMTimeMake((int)millisElapsed, 1000) addImage:cgImage];
//            }
            CGImageRelease(cgImage);
        }
        @catch (NSException *exception) {
            
        }
        _writing = false;
    }
}
@end
