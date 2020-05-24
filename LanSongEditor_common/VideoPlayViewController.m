//
//  VideoPlayViewController.m
//
//  Created by sno on 16/8/1.
//
//

#import "VideoPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <LanSongEditorFramework/LanSongEditor.h>

#import <AssetsLibrary/AssetsLibrary.h>

#import "DemoUtils.h"

@interface VideoPlayViewController ()
{
    LSOXAssetInfo *mInfo;
    AVPlayerLayer *layer;
      CGContextRef   context;        //绘制layer的context
    
    id _notificationToken;
    BOOL isUpdateSlider;
    AVPlayer *player;
    BOOL isPlaying;
    CGFloat sumPlayOperation;
}
//监控进度
@property (nonatomic,strong)NSTimer *avTimer;

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _notificationToken=0;
    
    
    NSLog(@"-----------start  VideoPlayViewController-------.");
    [DemoUtils setViewControllerPortrait];
    
    mInfo=[[LSOXAssetInfo alloc] initWithPath:self.videoPath];
    if (_videoPath!=nil && [mInfo prepare]) {
        NSLog(@"获取到的视频信息是:%@",mInfo);
        NSString *str= [NSString stringWithFormat:@"宽度:%f"
                "高度:%f"
                "时长:%f"
               "旋转角度:%d"
                "帧率是:%f"
                ,mInfo.width,mInfo.height,mInfo.duration,mInfo.videoAngle,mInfo.frameRate];
        [self.libInfo setText:str];
        [self playVideo];
        
        
//         //显示第一张图片
//        UIImage *image=[VideoEditor getVideoImageimageWithURL:[LSOFileUtil filePathToURL:self.videoPath]];
//        float ratio=[mInfo getHeight]*1.0/([mInfo getWidth]*1.0);
//        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 300, 100, 100*ratio)];
//        imgView.image=image;
//        [self.view addSubview:imgView];
    
    }else{
        [DemoUtils showHUDToast:@"当前视频错误, 退出"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    
}
//LSTODO: 有1%的几率不会被播放.但视频导出是好的.
-(void)playVideo
{
    
    NSURL *url=[NSURL fileURLWithPath:_videoPath];
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    player = [[AVPlayer alloc] initWithPlayerItem:item];
    layer = [AVPlayerLayer playerLayerWithPlayer:player];
    
    
    layer.frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 300);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:layer];
    
    self.progressSlider.value = 0;
    player.volume = 1.0f;
    self.avTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
    [player play];
    isPlaying=YES;
    [self setPlayerLoop];
    isUpdateSlider=YES;
    
}
- (void)setPlayerLoop
{
    if (_notificationToken)
        _notificationToken = nil;
    
    //设置播放结束后的动作
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    _notificationToken = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:player.currentItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [player.currentItem seekToTime:kCMTimeZero];  //这个是循环播放的.
    }];
}
-(void)viewDidDisappear:(BOOL)animated
{
    isUpdateSlider=NO;
    if (_notificationToken) {
        [[NSNotificationCenter defaultCenter] removeObserver:_notificationToken name:AVPlayerItemDidPlayToEndTimeNotification object:player.currentItem];
        _notificationToken = nil;
    }
    if (self.avTimer!=NULL) {
        [self.avTimer invalidate];
        self.avTimer=NULL;
    }
    if (isPlaying) {
        [player replaceCurrentItemWithPlayerItem:nil];
        player=nil;
    }
    mInfo=nil;
    layer=nil;
}
//监控播放进度方法
- (void)timer
{
    if (isPlaying && isUpdateSlider) {
        float  timepos= (float)player.currentItem.currentTime.value;
        timepos/=(float)player.currentItem.currentTime.timescale;  //timescale, 时间刻度.
       self.progressSlider.value = CMTimeGetSeconds(player.currentItem.currentTime) /  CMTimeGetSeconds(player.currentItem.duration);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)player:(id)sender {
    if (isPlaying==NO) {
        [player play];
        isPlaying=YES;
    }
}
- (IBAction)pause:(id)sender {
    if (isPlaying) {
        [player pause];
        isPlaying=NO;
    }
  }
- (IBAction)stop:(id)sender {
    
    if (isPlaying) {
        [player replaceCurrentItemWithPlayerItem:nil];
        isPlaying=NO;
    }
}
- (IBAction)slideTouchUp:(id)sender {
    isUpdateSlider=YES;
}
- (IBAction)slideTouchDown:(id)sender {
    isUpdateSlider=NO;
}
- (IBAction)changeProgress:(id)sender {
    CGFloat duration = player.currentItem.duration.value/player.currentItem.duration.timescale;
    
    
    [player seekToTime:CMTimeMakeWithSeconds(self.progressSlider.value*duration, player.currentItem.duration.timescale) completionHandler:^(BOOL finished) {
        [player play];
    }];
}
- (IBAction)saveToPhotoLibrary:(UIButton *)sender {
    NSURL *url=[NSURL fileURLWithPath:_videoPath];

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            NSLog(@"Video could not be saved");
            [DemoUtils showHUDToast:@"错误! 导出相册错误,请联系我们!"];
        }else{
            [DemoUtils showHUDToast:@"已导出到相册"];
        }
    }];
}
@end
