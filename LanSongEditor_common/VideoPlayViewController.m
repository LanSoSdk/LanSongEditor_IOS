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
    
  [LanSongUtils setViewControllerPortrait];
    mInfo=[[MediaInfo alloc] initWithPath:self.videoPath];
    if (_videoPath!=nil && [mInfo prepare]) {
        
        NSLog(@"获取到的视频信息是:%@",mInfo);  //用中文,让您看到你您处理后的视频信息.
        
        NSString *str= [NSString stringWithFormat:@"宽度:%d"
                "高度:%d"
                "时长:%f"
               "旋转角度:%f"
                "音频采样率:%d"
                "音频通道:%d"
                ,mInfo.vWidth,mInfo.vHeight,mInfo.vDuration,mInfo.vRotateAngle,mInfo.aSampleRate,mInfo.aChannels];
        [self.libInfo setText:str];
        [self playVideo];
    }else{
        [LanSongUtils showHUDToast:@"当前视频错误, 退出"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    
}
-(void)playVideo
{
    NSURL *url=[NSURL fileURLWithPath:_videoPath];
    
    //设置播放的项目
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];  //初始化player对象
    
    //设置播放页面
    layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    
    layer.frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 300);
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
    
    //设置最大值最小值音量
    //    self.volume.maximumValue =10.0f;
    //    self.volume.minimumValue =0.0f;
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
    mInfo=nil;
    layer=nil;
}
//监控播放进度方法
- (void)timer
{
    if (self.isPlaying==YES) { //浮点运算可以得到 秒后面的小数位.
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
- (IBAction)changeProgress:(id)sender {
   
//    NSLog(@"self.player.currentItem.duration.value:%lld\n",self.player.currentItem.duration.value);
    //总的时长.
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
            NSLog(@"Video could not be saved");
            [LanSongUtils showHUDToast:@"错误! 导出相册错误,请联系我们!"];
        }else{
            [LanSongUtils showHUDToast:@"已导出到相册"];
        }
    }];
}



@end
