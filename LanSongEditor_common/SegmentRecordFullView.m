
#import "SegmentRecordFullView.h"

@interface SegmentRecordFullView ()
{
    BOOL isRecording;
    NSMutableArray  *segmentArray;
    UINavigationController* mUINavigationController;
}
@end

@implementation SegmentRecordFullView

- (instancetype) initWithFrame:(CGRect)frame{
    if (!(self = [super initWithFrame:frame]))
    {
        return nil;
    }
    mainScreenFrame = frame;
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    [videoCamera addAudioInputsAndOutputs];
    
    filter = [[GPUImageSaturationFilter alloc] init];
    filteredVideoView = [[GPUImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [videoCamera addTarget:filter];
    [filter addTarget:filteredVideoView];
    
    [videoCamera startCameraCapture];
    
    [self addSomeView];
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraViewTapAction:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    [filteredVideoView addGestureRecognizer:singleFingerOne];
    [self addSubview:filteredVideoView];
    
    segmentArray=[[NSMutableArray alloc] init];
    
    isRecording=NO;
    return self;
}
- (void) addSomeView{
    UISlider *filterSettingsSlider = [[UISlider alloc] initWithFrame:CGRectMake(25.0, 30.0, mainScreenFrame.size.width - 50.0, 40.0)];
    [filterSettingsSlider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
    filterSettingsSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    filterSettingsSlider.minimumValue = 0.0;
    filterSettingsSlider.maximumValue = 2.0;
    filterSettingsSlider.value = 1.0;
    [filteredVideoView addSubview:filterSettingsSlider];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60.0, 100, 30.0)];
    timeLabel.font = [UIFont systemFontOfSize:15.0f];
    timeLabel.text = @"00:00:00";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor whiteColor];
    [filteredVideoView addSubview:timeLabel];
    
    
    photoCaptureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [photoCaptureButton.layer setCornerRadius:8];
    photoCaptureButton.frame = CGRectMake(100,
                                          mainScreenFrame.size.height - 70.0,
                                          100.0, 40.0);
    photoCaptureButton.backgroundColor = [UIColor whiteColor];
    [photoCaptureButton setTitle:@"开始/暂停" forState:UIControlStateNormal];
    photoCaptureButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [photoCaptureButton addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
    [photoCaptureButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [filteredVideoView addSubview:photoCaptureButton];
    
    UIButton *cameraChangeButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cameraChangeButton.layer setCornerRadius:8];
    cameraChangeButton.frame = CGRectMake(mainScreenFrame.size.width - 150, mainScreenFrame.size.height - 70.0, 100.0, 40.0);
    cameraChangeButton.backgroundColor = [UIColor whiteColor];
    [cameraChangeButton setTitle:@"录制结束" forState:UIControlStateNormal];
    cameraChangeButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [cameraChangeButton addTarget:self action:@selector(concatRecording:) forControlEvents:UIControlEventTouchUpInside];
    [cameraChangeButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [filteredVideoView addSubview:cameraChangeButton];

}

- (IBAction)updateSliderValue:(id)sender
{
    [(GPUImageSaturationFilter *)filter setSaturation:[(UISlider *)sender value]];
}
-(void)setNav:(UINavigationController*)nav
{
    mUINavigationController=nav;
}
- (IBAction)concatRecording:(id)sender {
    if(isRecording)
    {
        isRecording=NO;
        videoCamera.audioEncodingTarget = nil;
       
        [movieWriter finishRecording];
        
        [segmentArray addObject:pathToMovie];
        
        
        [filter removeTarget:movieWriter];
        timeLabel.text = @"00:00:00";
        [myTimer invalidate];
        myTimer = nil;
    }
    
    if(segmentArray.count>0){
        NSLog(@"文件是的个数是:%ld",segmentArray.count);
        NSString *dstPath=[SDKFileUtil genTmpMp4Path];
        
        [VideoEditor executeConcatMP4:segmentArray dstFile:dstPath];
        
        if([SDKFileUtil fileExist:dstPath]){
            [LanSongUtils startVideoPlayerVC:mUINavigationController dstPath:dstPath];
        }
        [SDKFileUtil deleteAllFiles:segmentArray];
        
    }
}

- (IBAction)startRecording:(id)sender {
    //pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    
    if(isRecording){
        
            [photoCaptureButton setTitle:@"开始/暂停" forState:UIControlStateNormal];
            videoCamera.audioEncodingTarget = nil;
            
            [movieWriter finishRecording];
            
            [segmentArray addObject:pathToMovie];
            
            
            [filter removeTarget:movieWriter];
            timeLabel.text = @"00:00:00";
            [myTimer invalidate];
            myTimer = nil;
            isRecording=NO;
    }else{
         [photoCaptureButton setTitle:@"录制中....." forState:UIControlStateNormal];
        pathToMovie=[SDKFileUtil genTmpMp4Path];
        
        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(360.0, 640.0)];
        movieWriter.encodingLiveVideo = YES;
        movieWriter.shouldPassthroughAudio = NO;//录制Camera的时候, 要编码, 不能 -acodec copy
        [filter addTarget:movieWriter];
        videoCamera.audioEncodingTarget = movieWriter;
        
        [movieWriter startRecording];
        NSTimeInterval timeInterval =1.0;
        fromdate = [NSDate date];
        myTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                   target:self
                                                 selector:@selector(updateTimer:)
                                                 userInfo:nil
                                                  repeats:YES];
        isRecording=YES;
    }
}
- (void)updateTimer:(NSTimer *)sender{
    NSDateFormatter *dateFormator = [[NSDateFormatter alloc] init];
    dateFormator.dateFormat = @"HH:mm:ss";
    NSDate *todate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:fromdate toDate:todate options:NSCalendarWrapComponents];
    //NSInteger hour = [comps hour];
    //NSInteger min = [comps minute];
    //NSInteger sec = [comps second];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *timer = [gregorian dateFromComponents:comps];
    NSString *date = [dateFormator stringFromDate:timer];
    timeLabel.text = date;
}

- (void)setfocusImage{
    UIImage *focusImage = [UIImage imageNamed:@"focusimg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, focusImage.size.width, focusImage.size.height)];
    imageView.image = focusImage;
    CALayer *layer = imageView.layer;
    layer.hidden = YES;
    [filteredVideoView.layer addSublayer:layer];
    _focusLayer = layer;
    
}

- (void)layerAnimationWithPoint:(CGPoint)point {
    if (_focusLayer) {
        CALayer *focusLayer = _focusLayer;
        focusLayer.hidden = NO;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [focusLayer setPosition:point];
        focusLayer.transform = CATransform3DMakeScale(2.0f,2.0f,1.0f);
        [CATransaction commit];
        
        
        CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
        animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0f,1.0f,1.0f)];
        animation.delegate = self;
        animation.duration = 0.3f;
        animation.repeatCount = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [focusLayer addAnimation: animation forKey:@"animation"];
        
        // 0.5秒钟延时
        [self performSelector:@selector(focusLayerNormal) withObject:self afterDelay:0.5f];
    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
}


- (void)focusLayerNormal {
    filteredVideoView.userInteractionEnabled = YES;
    _focusLayer.hidden = YES;
}


-(void)cameraViewTapAction:(UITapGestureRecognizer *)tgr
{
    if (tgr.state == UIGestureRecognizerStateRecognized && (_focusLayer == NO || _focusLayer.hidden)) {
        CGPoint location = [tgr locationInView:filteredVideoView];
        [self setfocusImage];
        [self layerAnimationWithPoint:location];
        AVCaptureDevice *device = videoCamera.inputCamera;
        CGPoint pointOfInterest = CGPointMake(0.5f, 0.5f);
//        NSLog(@"taplocation x = %f y = %f", location.x, location.y);
        CGSize frameSize = [filteredVideoView frame].size;
        
        if ([videoCamera cameraPosition] == AVCaptureDevicePositionFront) {
            location.x = frameSize.width - location.x;
        }
        
        pointOfInterest = CGPointMake(location.y / frameSize.height, 1.f - (location.x / frameSize.width));
        
        
        if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            NSError *error;
            if ([device lockForConfiguration:&error]) {
                [device setFocusPointOfInterest:pointOfInterest];
                
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
                
                if([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
                {
                    [device setExposurePointOfInterest:pointOfInterest];
                    [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
                }
                
                [device unlockForConfiguration];
                
                NSLog(@"FOCUS OK");
            } else {
                NSLog(@"ERROR = %@", error);
            }
        }
    }
}
@end
