
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
    
    
   // videoCamera = [[LanSongVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    videoCamera=[[CameraPen alloc] init:AVCaptureSessionPreset1280x720 position:AVCaptureDevicePositionFront drawpadSize:CGSizeMake(720, 1280) drawpadTarget:nil];
    
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    [videoCamera addAudioInputsAndOutputs];
    
    [videoCamera startCameraCapture];
    
    
    
    previewView = [[LanSongView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [videoCamera addTarget:previewView];
    
    
    [self addSomeView];
    
    segmentArray=[[NSMutableArray alloc] init];
    
    isRecording=NO;
    
    focusLayer=nil;
    
    //增加点击preview的点击事件
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraViewTapAction:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    [previewView addGestureRecognizer:singleFingerOne];
    [self addSubview:previewView];
    return self;
}
-(void)stopCameraCapture
{
    if(videoCamera!=nil){
        [videoCamera stopCameraCapture];
        videoCamera=nil;
    }
}
-(void)dealloc
{
    NSLog(@"SegmentRecordFullView alloc ....");
    previewView=nil;
    movieWriter=nil;
    if(videoCamera!=nil){
        [videoCamera stopCameraCapture];
        videoCamera=nil;
    }
    if(myTimer!=nil)
    {
        [myTimer invalidate];
        myTimer = nil;
    }
}


/**
 录制完成的监听
 
 @param sender <#sender description#>
 */
- (IBAction)concatRecording:(id)sender {
    
    if(isRecording)
    {
        [self segmentStop];
    }
    
    if(segmentArray.count>0)
    {
        [self segmentFinish];
    }
}

/**
 录制按钮 sender
 
 @param sender <#sender description#>
 */
- (IBAction)startRecording:(id)sender {
    
    if(isRecording){
        
        [self segmentStop];
        
    }else{
        [self segmentStart];
    }
}
/**
 开始一段的录制
 */
-(void)segmentStart
{
    if(isRecording)
        return ;
    
    currentSegment=[SDKFileUtil genTmpMp4Path];
    
    unlink([currentSegment UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:currentSegment];
    
    movieWriter = [[LanSongMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(360.0, 640.0)];
    movieWriter.encodingLiveVideo = YES;
    movieWriter.shouldPassthroughAudio = NO;//录制Camera的时候, 要编码, 不能 -acodec copy
    
    
    [videoCamera addTarget:movieWriter];
    
    videoCamera.audioEncodingTarget = movieWriter;
    
    [movieWriter startRecording];
    [btnRecord setTitle:@"录制中....." forState:UIControlStateNormal];
    
    NSTimeInterval timeInterval =1.0;
    fromdate = [NSDate date];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                               target:self
                                             selector:@selector(updateTimer:)
                                             userInfo:nil
                                              repeats:YES];
    isRecording=YES;
    
}
/**
 录制停止
 */
-(void)segmentStop
{
    [btnRecord setTitle:@"开始/暂停" forState:UIControlStateNormal];
    videoCamera.audioEncodingTarget = nil;
    
    [movieWriter finishRecording];
    
    [segmentArray addObject:currentSegment];
    
    [videoCamera removeTarget:movieWriter];
    
    timeLabel.text = @"00:00:00";
    if(myTimer!=nil)
    {
        [myTimer invalidate];
        myTimer = nil;
    }
    
    isRecording=NO;
    movieWriter=nil;
}

/**
 录制完成,
 合成和播放
 */
-(void)segmentFinish
{
    NSLog(@"文件是的个数是:%ld",segmentArray.count);
    
    //        NSString *dstPath=(NSString *)segmentArray[0];  //ok
    //         [LanSongUtils startVideoPlayerVC:mUINavigationController dstPath:dstPath];
    
    
    NSString *dstPath=[SDKFileUtil genTmpMp4Path];
    
    [VideoEditor executeConcatMP4:segmentArray dstFile:dstPath];
    
    if([SDKFileUtil fileExist:dstPath]){
        [LanSongUtils startVideoPlayerVC:mUINavigationController dstPath:dstPath];
    }else{
        [LanSongUtils showHUDToast:@"抱歉,文件合成失败!,请联系我们"];
    }
    
}

/**
 增加聚焦图片
 */
- (void)addfocusImage{
    UIImage *focusImage = [UIImage imageNamed:@"focusimg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, focusImage.size.width, focusImage.size.height)];
    imageView.image = focusImage;
    CALayer *layer = imageView.layer;
    layer.hidden = YES;
    
    //增加layer
    [previewView.layer addSublayer:layer];
    focusLayer = layer;
}

/**
 消失
 */
- (void)focusLayerNormal {
    previewView.userInteractionEnabled = YES;
    focusLayer.hidden = YES;
}


/**
 点击画面,开始聚集
 
 @param tgr <#tgr description#>
 */
-(void)cameraViewTapAction:(UITapGestureRecognizer *)tgr
{
    if (tgr.state == UIGestureRecognizerStateRecognized && (focusLayer == nil || focusLayer.hidden)) {
        CGPoint location = [tgr locationInView:previewView];
        [self addfocusImage];
        [self layerAnimationWithPoint:location];
        
        
        
        AVCaptureDevice *device = videoCamera.inputCamera;
        CGPoint pointOfInterest = CGPointMake(0.5f, 0.5f);
        CGSize frameSize = [previewView frame].size;
        
        //当前是前置的话, 宽度对调
        if ([videoCamera cameraPosition] == AVCaptureDevicePositionFront) {
            location.x = frameSize.width - location.x;
        }
        
        pointOfInterest = CGPointMake(location.y / frameSize.height, 1.f - (location.x / frameSize.width));
        if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
        {
            NSError *error;
            if ([device lockForConfiguration:&error]) {
                [device setFocusPointOfInterest:pointOfInterest];  //聚焦点
                
                [device setFocusMode:AVCaptureFocusModeAutoFocus];  //自动聚焦
                
                if([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
                {
                    [device setExposurePointOfInterest:pointOfInterest];
                    [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];  //自动曝光
                }
                
                [device unlockForConfiguration];
                
                NSLog(@"FOCUS OK");
            } else {
                NSLog(@"ERROR = %@", error);
            }
        }
    }
}

/**
 其他的一些界面控件
 */
- (void) addSomeView{
    
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60.0, 100, 30.0)];
    timeLabel.font = [UIFont systemFontOfSize:15.0f];
    timeLabel.text = @"00:00:00";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor whiteColor];
    [previewView addSubview:timeLabel];
    
    
    btnRecord = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnRecord.layer setCornerRadius:8];
    btnRecord.frame = CGRectMake(100,mainScreenFrame.size.height - 70.0,
                                 100.0, 40.0);
    btnRecord.backgroundColor = [UIColor whiteColor];
    [btnRecord setTitle:@"开始/暂停" forState:UIControlStateNormal];
    btnRecord.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [btnRecord addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
    [btnRecord setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [previewView addSubview:btnRecord];
    
    //完成按钮
    UIButton *btnOk  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnOk.layer setCornerRadius:8];
    btnOk.frame = CGRectMake(mainScreenFrame.size.width - 150, mainScreenFrame.size.height - 70.0, 100.0, 40.0);
    btnOk.backgroundColor = [UIColor whiteColor];
    [btnOk setTitle:@"录制结束" forState:UIControlStateNormal];
    btnOk.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [btnOk addTarget:self action:@selector(concatRecording:) forControlEvents:UIControlEventTouchUpInside];
    [btnOk setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [previewView addSubview:btnOk];
    
}

/**
 聚焦的UI动画
 
 @param point 聚焦点
 */
- (void)layerAnimationWithPoint:(CGPoint)point {
    if (focusLayer) {
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

/**
 定时器相应 sender
 
 @param sender <#sender description#>
 */
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
-(void)setNav:(UINavigationController*)nav
{
    mUINavigationController=nav;
}
@end
