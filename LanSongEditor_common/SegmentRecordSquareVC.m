//
//

#import "SegmentRecordSquareVC.h"
#import <QuartzCore/QuartzCore.h>
#import "ProgressBar.h"
#import "LanSongUtils.h"
#import "SegmentRecorder.h"
#import "DeleteButton.h"
#import "MBProgressHUD.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>

#define TIMER_INTERVAL 0.05f

#define TAG_ALERTVIEW_CLOSE_CONTROLLER 10086

@interface SegmentRecordSquareVC ()
{
    CGFloat  nvheight;
}
@property (strong, nonatomic) SegmentRecorder *recorder;

@property (strong, nonatomic) ProgressBar *progressBar;

@property (strong, nonatomic) DeleteButton *deleteButton;
@property (strong, nonatomic) UIButton *okButton;

@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *settingButton;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) UIButton *flashButton;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (assign, nonatomic) BOOL initalized;
@property (assign, nonatomic) BOOL isProcessingData;

@property (strong, nonatomic) UIView *preview;
@property (strong, nonatomic) UIImageView *focusRectView;

@end




/**
 最小的视频时长,如果小于这个, 则视频认为没有录制.
 */
#define MIN_VIDEO_DURATION 2.0f


/**
 定义视频录制的最长时间, 如果超过这个时间,则默认为视频录制已经完成.

 */
#define MAX_VIDEO_DURATION 8.0f

@implementation SegmentRecordSquareVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = color(16, 16, 16, 1);
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_initalized) {
        return;
    }
    
     nvheight=    self.navigationController.navigationBar.frame.size.height;
    
    [self initPreview];
    [LanSongUtils createVideoFolderIfNotExist];
    [self initProgressBar];
    [self initRecordButton];
    [self initDeleteButton];
    [self initOKButton];
    [self initTopLayout];
    
    
    self.initalized = YES;
}

- (void)initPreview
{
    self.preview = [[UIView alloc] initWithFrame:CGRectMake(0, nvheight, DEVICE_SIZE.width, DEVICE_SIZE.width)];
    _preview.clipsToBounds = YES;
    [self.view addSubview:_preview ];
    
    
    self.recorder = [[SegmentRecorder alloc] init];
    _recorder.delegate = self;
    _recorder.preViewLayer.frame = CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.width); //正方形.
    
    [self.preview.layer addSublayer:_recorder.preViewLayer];
    
    self.recorder.settingMaxDuration=MAX_VIDEO_DURATION;  //设置最大时间.
}

- (void)initProgressBar
{
    self.progressBar = [ProgressBar getInstance];
    [LanSongUtils setView:_progressBar toOriginY:(DEVICE_SIZE.width+nvheight)];

    [self.view addSubview:_progressBar ];
    [_progressBar startShining];
}

- (void)initDeleteButton
{
    if (_isProcessingData) {
        return;
    }
    
    self.deleteButton = [DeleteButton getInstance];
    [_deleteButton setButtonStyle:DeleteButtonStyleDisable];
    
    [LanSongUtils setView:_deleteButton toOrigin:CGPointMake(15, self.view.frame.size.height - _deleteButton.frame.size.height - 10-nvheight)];
   
    [_deleteButton addTarget:self action:@selector(pressDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGPoint center = _deleteButton.center;
    center.y = _recordButton.center.y;
    _deleteButton.center = center;
    
    [self.view addSubview:_deleteButton];
    
}

- (void)initRecordButton
{
    CGFloat buttonW = 80.0f;
    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(
                                                                   (DEVICE_SIZE.width - buttonW) / 2.0,
                                                                   _progressBar.frame.origin.y + _progressBar.frame.size.height + 10,
                                                                   buttonW, buttonW)];
    
    
    [_recordButton setImage:[UIImage imageNamed:@"video_longvideo_btn_shoot.png"] forState:UIControlStateNormal];
    _recordButton.userInteractionEnabled = NO;
    [self.view addSubview:_recordButton];
}

- (void)initOKButton
{
    CGFloat okButtonW = 50;
    self.okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, okButtonW, okButtonW)];
    _okButton.enabled = NO;
    
    [_okButton setBackgroundImage:[UIImage imageNamed:@"record_icon_hook_normal_bg.png"] forState:UIControlStateNormal];
    [_okButton setBackgroundImage:[UIImage imageNamed:@"record_icon_hook_highlighted_bg.png"] forState:UIControlStateHighlighted];
    
    [_okButton setImage:[UIImage imageNamed:@"record_icon_hook_normal.png"] forState:UIControlStateNormal];
    
    [LanSongUtils setView:_okButton toOrigin:CGPointMake(self.view.frame.size.width - okButtonW - 10, self.view.frame.size.height - okButtonW - 10)];
    
    [_okButton addTarget:self action:@selector(pressOKButton) forControlEvents:UIControlEventTouchUpInside];
    
    CGPoint center = _okButton.center;
    center.y = _recordButton.center.y;
    _okButton.center = center;
    
    [self.view addSubview:_okButton];
}

- (void)initTopLayout
{
    CGFloat buttonW = 35.0f;
    
    //前后摄像头转换
    self.switchButton = [[UIButton alloc] initWithFrame:CGRectMake(
                                                                   self.view.frame.size.width - (buttonW + 10) * 2 - 10, 5+nvheight,
                                                                   buttonW, buttonW)];
    
    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_normal.png"] forState:UIControlStateNormal];
    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_disable.png"] forState:UIControlStateDisabled];
    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_highlighted.png"] forState:UIControlStateSelected];
    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_highlighted.png"] forState:UIControlStateHighlighted];
    [_switchButton addTarget:self action:@selector(pressSwitchButton) forControlEvents:UIControlEventTouchUpInside];
    _switchButton.enabled = [_recorder isFrontCameraSupported];
    [self.view addSubview:_switchButton];
    

    self.flashButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (buttonW + 10),
                                                                  5+nvheight,
                                                                  buttonW, buttonW)];
    
    [_flashButton setImage:[UIImage imageNamed:@"record_flashlight_normal.png"] forState:UIControlStateNormal];
    [_flashButton setImage:[UIImage imageNamed:@"record_flashlight_disable.png"] forState:UIControlStateDisabled];
    [_flashButton setImage:[UIImage imageNamed:@"record_flashlight_highlighted.png"] forState:UIControlStateHighlighted];
    [_flashButton setImage:[UIImage imageNamed:@"record_flashlight_highlighted.png"] forState:UIControlStateSelected];
    _flashButton.enabled = _recorder.isTorchSupported;
    [_flashButton addTarget:self action:@selector(pressFlashButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_flashButton];
    
    //focus rect view
    self.focusRectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    _focusRectView.image = [UIImage imageNamed:@"touch_focus_not.png"];
    _focusRectView.alpha = 0;
    [self.preview addSubview:_focusRectView];
}



- (void)pressSwitchButton
{
    _switchButton.selected = !_switchButton.selected;
    if (_switchButton.selected) {//换成前摄像头
        if (_flashButton.selected) {
            [_recorder openTorch:NO];
            _flashButton.selected = NO;
            _flashButton.enabled = NO;
        } else {
            _flashButton.enabled = NO;
        }
    } else {
        _flashButton.enabled = [_recorder isFrontCameraSupported];
    }
    
    [_recorder switchCamera];
}

- (void)pressFlashButton
{
    _flashButton.selected = !_flashButton.selected;
    [_recorder openTorch:_flashButton.selected];
}

- (void)pressDeleteButton
{
    if (_deleteButton.style == DeleteButtonStyleNormal) {//第一次按下删除按钮
        [_progressBar setLastProgressToStyle:ProgressBarProgressStyleDelete];
        [_deleteButton setButtonStyle:DeleteButtonStyleDelete];
    } else if (_deleteButton.style == DeleteButtonStyleDelete) {//第二次按下删除按钮
        [self deleteLastVideo];
        [_progressBar deleteLastProgress];
        
        if ([_recorder getVideoCount] > 0) {
            [_deleteButton setButtonStyle:DeleteButtonStyleNormal];
        } else {
            [_deleteButton setButtonStyle:DeleteButtonStyleDisable];
        }
    }
}

- (void)pressOKButton
{
    if (_isProcessingData) {
        return;
    }
    
    if (!self.hud) {
        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.labelText = @"努力处理中";
    }
    [_hud show:YES];
    [self.view addSubview:_hud];
    
    [_recorder mergeVideoFiles];
    self.isProcessingData = YES;
}


/**
 关闭
 */
- (void)dropTheVideo
{
    [_recorder deleteAllVideo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 删除最后一段视频

 @return <#return value description#>
 */
- (void)deleteLastVideo
{
    if ([_recorder getVideoCount] > 0) {
        [_recorder deleteLastVideo];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)showFocusRectAtPoint:(CGPoint)point
{
    _focusRectView.alpha = 1.0f;
    _focusRectView.center = point;
    _focusRectView.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    [UIView animateWithDuration:0.2f animations:^{
        _focusRectView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.values = @[@0.5f, @1.0f, @0.5f, @1.0f, @0.5f, @1.0f];
        animation.duration = 0.5f;
        [_focusRectView.layer addAnimation:animation forKey:@"opacity"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3f animations:^{
                _focusRectView.alpha = 0;
            }];
        });
    }];
}

#pragma mark - SegmentRecorderDelegate
- (void)videoRecorder:(SegmentRecorder *)videoRecorder didStartRecordingToOutPutFileAtURL:(NSURL *)fileURL
{
    [self.progressBar addProgressView];
    [_progressBar stopShining];
    
    [_deleteButton setButtonStyle:DeleteButtonStyleNormal];
}

- (void)videoRecorder:(SegmentRecorder *)videoRecorder didFinishRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration totalDur:(CGFloat)totalDur error:(NSError *)error
{
    [_progressBar startShining];
    
    if (totalDur >= MAX_VIDEO_DURATION) {
        [self pressOKButton];
    }
}

- (void)videoRecorder:(SegmentRecorder *)videoRecorder didRemoveVideoFileAtURL:(NSURL *)fileURL totalDur:(CGFloat)totalDur error:(NSError *)error
{   
    if ([_recorder getVideoCount] > 0) {
        [_deleteButton setStyle:DeleteButtonStyleNormal];
    } else {
        [_deleteButton setStyle:DeleteButtonStyleDisable];
    }
    
    _okButton.enabled = (totalDur >= MIN_VIDEO_DURATION);
}

- (void)videoRecorder:(SegmentRecorder *)videoRecorder didRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration recordedVideosTotalDur:(CGFloat)totalDur
{
    [_progressBar setLastProgressToWidth:videoDuration / MAX_VIDEO_DURATION * _progressBar.frame.size.width];
    
    _okButton.enabled = (videoDuration + totalDur >= MIN_VIDEO_DURATION);
}

+(NSString *)urlToFileString:(NSURL *)url
{
    if (url!=nil) {
        NSString *str=[url path];
        if ([str hasPrefix:@"file://"]) {  //去掉开始的file://
            return [str substringFromIndex:7];
        }else{
            return str;
        }
    }
    return  nil;
}
- (void)videoRecorder:(SegmentRecorder *)videoRecorder didFinishMergingVideosToOutPutFileAtURL:(NSURL *)outputFileURL
{
    [_hud hide:YES];
    self.isProcessingData = NO;
    NSLog(@"录制和拼接完成..navigationController..");
    
    NSString *str=[SegmentRecordSquareVC urlToFileString:outputFileURL];
    
     [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:str];
    // UISaveVideoAtPathToSavedPhotosAlbum(str, nil, nil, nil);
    
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isProcessingData) {
        return;
    }
    
    if (_deleteButton.style == DeleteButtonStyleDelete) {//取消删除
        [_deleteButton setButtonStyle:DeleteButtonStyleNormal];
        [_progressBar setLastProgressToStyle:ProgressBarProgressStyleNormal];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:_recordButton.superview];
    if (CGRectContainsPoint(_recordButton.frame, touchPoint)) {
        NSString *filePath = [LanSongUtils getVideoSaveFilePathString];
        [_recorder startRecordingToOutputFileURL:[NSURL fileURLWithPath:filePath]];
    }
    
    touchPoint = [touch locationInView:self.view];//previewLayer 的 superLayer所在的view
    if (CGRectContainsPoint(_recorder.preViewLayer.frame, touchPoint)) {
        [self showFocusRectAtPoint:touchPoint];
        [_recorder focusInPoint:touchPoint];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isProcessingData) {
        return;
    }
    
    [_recorder stopCurrentVideoRecording];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case TAG_ALERTVIEW_CLOSE_CONTROLLER:
        {
            switch (buttonIndex) {
                case 0:
                {
                }
                    break;
                case 1:
                {
                    [self dropTheVideo];
                }
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ---------rotate(only when this controller is presented, the code below effect)-------------
//<iOS6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
//iOS6+
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	return UIInterfaceOrientationPortrait;
}
#endif


@end



















