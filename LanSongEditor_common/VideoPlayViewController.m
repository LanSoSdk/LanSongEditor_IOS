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

#import "LanSongUtils.h"

@interface VideoPlayViewController ()
{
    MediaInfo *mInfo;
    AVPlayerLayer *layer;
      CGContextRef   context;        //绘制layer的context
    
    id _notificationToken;
    BOOL isUpdateSlider;
}
//监控进度
@property (nonatomic,strong)NSTimer *avTimer;

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (nonatomic,strong)AVPlayer *player;
@property BOOL isPlaying;
/**
 *  播放的总时长
 */
@property (nonatomic,assign)CGFloat sumPlayOperation;

@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    _notificationToken=0;
    
  [LanSongUtils setViewControllerPortrait];
    
    mInfo=[[MediaInfo alloc] initWithPath:self.videoPath];
    if (_videoPath!=nil && [mInfo prepare]) {
        
        LSLog(@"获取到的视频信息是:%@",mInfo);
        NSString *str= [NSString stringWithFormat:@"宽度:%d"
                "高度:%d"
                "时长:%f"
               "旋转角度:%f"
                "音频采样率:%d"
                "音频通道:%d"
                ,mInfo.getWidth,mInfo.getHeight,mInfo.vDuration,mInfo.vRotateAngle,mInfo.aSampleRate,mInfo.aChannels];
        [self.libInfo setText:str];
        [self playVideo];
        
//         //显示第一张图片
//        UIImage *image=[VideoEditor getVideoImageimageWithURL:[LanSongFileUtil filePathToURL:self.videoPath]];
//        float ratio=[mInfo getHeight]*1.0/([mInfo getWidth]*1.0);
//        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 300, 100, 100*ratio)];
//        imgView.image=image;
//        [self.view addSubview:imgView];
        
    }else{
        [LanSongUtils showHUDToast:@"当前视频错误, 退出"];
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
    
    //设置播放的项目
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];  //初始化player对象
    
    //设置播放页面
    layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    
    layer.frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 300);
//    layer.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-50);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:layer];
    
    //设置播放进度
    self.progressSlider.value = 0;
    //设置播放的音量
    self.player.volume = 1.0f;
    //增加一个定时器,监听播放进度.
    self.avTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
    [self.player play];
    self.isPlaying=YES;
    [self setPlayerLoop];
    isUpdateSlider=YES;
    //设置最大值最小值音量
    //    self.volume.maximumValue =10.0f;
    //    self.volume.minimumValue =0.0f;
}
- (void)setPlayerLoop
{
    if (_notificationToken)
        _notificationToken = nil;
    
    //设置播放结束后的动作
    _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    _notificationToken = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [_player.currentItem seekToTime:kCMTimeZero];  //这个是循环播放的.
    }];
}
-(void)viewDidDisappear:(BOOL)animated
{
    if (self.avTimer!=NULL) {
        [self.avTimer invalidate];
        self.avTimer=NULL;
    }
    if (self.isPlaying) {
        [self.player replaceCurrentItemWithPlayerItem:nil];
    }
    if (_notificationToken) {
        [[NSNotificationCenter defaultCenter] removeObserver:_notificationToken name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        _notificationToken = nil;
    }
    
    mInfo=nil;
    layer=nil;
}
//监控播放进度方法
- (void)timer
{
    if (self.isPlaying && isUpdateSlider) {
        float  timepos= (float)self.player.currentItem.currentTime.value;
        timepos/=(float)self.player.currentItem.currentTime.timescale;  //timescale, 时间刻度.
       self.progressSlider.value = CMTimeGetSeconds(self.player.currentItem.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)player:(id)sender {
    if (self.isPlaying==NO) {
       // [self.player seekToTime:kCMTimeZero];
        [self.player play];
        self.isPlaying=YES;
    }
}
- (IBAction)pause:(id)sender {
    if (self.isPlaying) {
        [self.player pause];
        self.isPlaying=NO;
    }
  }
- (IBAction)stop:(id)sender {
    
    if (self.isPlaying) {
        [self.player replaceCurrentItemWithPlayerItem:nil];
        self.isPlaying=NO;
    }
}
- (IBAction)slideTouchUp:(id)sender {
    isUpdateSlider=YES;
}
- (IBAction)slideTouchDown:(id)sender {
    isUpdateSlider=NO;
}
- (IBAction)changeProgress:(id)sender {
    LSLog(@"self.player.currentItem.duration.value:%lld\n",self.player.currentItem.duration.value);
    
    self.sumPlayOperation = self.player.currentItem.duration.value/self.player.currentItem.duration.timescale;
    [self.player seekToTime:CMTimeMakeWithSeconds(self.progressSlider.value*self.sumPlayOperation, self.player.currentItem.duration.timescale) completionHandler:^(BOOL finished) {
        [self.player play];
    }];
}
- (IBAction)saveToPhotoLibrary:(UIButton *)sender {
    NSURL *url=[NSURL fileURLWithPath:_videoPath];

//    [self snapshot];
    [self writeVideoToPhotoLibrary:url];
    
}
- (void)writeVideoToPhotoLibrary:(NSURL *)url
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            LSLog(@"Video could not be saved");
            [LanSongUtils showHUDToast:@"错误! 导出相册错误,请联系我们!"];
        }else{
            [LanSongUtils showHUDToast:@"已导出到相册"];
        }
    }];
}



@end
