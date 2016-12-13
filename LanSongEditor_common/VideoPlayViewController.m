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

@interface VideoPlayViewController ()
{
    
}
//监控进度
@property (nonatomic,strong)NSTimer *avTimer;

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/**
 *  声明播放视频的控件属性[既可以播放视频也可以播放音频]
 */
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
    // Do any additional setup after loading the view, typically from a nib.
    
     NSString *playString=[SDKFileUtil copyAssetFile:@"ping20s" withSubffix:@"mp4" dstDir:[SDKFileUtil Path]];
     NSURL *url=[NSURL fileURLWithPath:playString];
    
//    NSString *playString = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
//    NSURL *url = [NSURL URLWithString:playString];
    
    
    //设置播放的项目
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
  
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];  //初始化player对象
  
    
    //设置播放页面
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    //设置播放页面的大小
    layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
    layer.backgroundColor = [UIColor cyanColor].CGColor;
    //设置播放窗口和当前视图之间的比例显示内容
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    //添加播放视图到self.view
    [self.view.layer addSublayer:layer];
    //设置播放进度的默认值
    self.progressSlider.value = 0;
    //设置播放的默认音量值
    self.player.volume = 1.0f;
    
    
   //增加一个定时器,监听播放进度.
    self.avTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
       self.isPlaying=NO;
    //可以设置:
    //设置最大值最小值音量
//    self.volume.maximumValue =10.0f;
//    self.volume.minimumValue =0.0f;
    
}
//监控播放进度方法
- (void)timer
{
    if (self.isPlaying==YES) {
        //浮点运算可以得到 秒后面的小数位.
        float  timepos= (float)self.player.currentItem.currentTime.value;
        timepos/=(float)self.player.currentItem.currentTime.timescale;  //timescale, 时间刻度.
        
//        NSLog(@"current time postion is:%f\n",timepos);
        
       self.progressSlider.value = CMTimeGetSeconds(self.player.currentItem.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
        

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)player:(id)sender {
     [self.player play];
    self.isPlaying=YES;
}
- (IBAction)pause:(id)sender {
    [self.player pause];
    self.isPlaying=NO;
    
}
- (IBAction)stop:(id)sender {
    //把当前播放Item设置为nil,这样就释放了资源.画面为空, 故可以停止播放,
    [self.player replaceCurrentItemWithPlayerItem:nil];
   
}
- (IBAction)changeProgress:(id)sender {
   
    NSLog(@"self.player.currentItem.duration.value:%lld\n",self.player.currentItem.duration.value);
    
    //总的时长.
    self.sumPlayOperation = self.player.currentItem.duration.value/self.player.currentItem.duration.timescale;
    
    [self.player seekToTime:CMTimeMakeWithSeconds(self.progressSlider.value*self.sumPlayOperation, self.player.currentItem.duration.timescale) completionHandler:^(BOOL finished) {
        [self.player play];
    }];
}

@end
