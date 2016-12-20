#import "DrawPadRealTimeVC.h"
#import "VideoPlayViewController.h"

@implementation DrawPadRealTimeVC
{
    int frameCount;
        
        DrawPadView *drawpad;
        NSTimer * timer;
    VideoPen *mainVideoPen;
    NSString *dstPath;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"ping20s" withExtension:@"mp4"];
    
    //获取一个临时文件
   dstPath = [SDKFileUtil genTmpMp4Path];
   
    
    drawpad =[[DrawPadView alloc] initWithWidth:480 height:480];
    //设置实时录制
    [drawpad setEncodeRealTime:dstPath width:480 height:480];
    
    //增加一个View用来显示效果.
    GPUImageView *filterView=[[GPUImageView alloc] initWithFrame:CGRectMake(0, 80, 320,320)];
    
    [self.view addSubview: filterView];
    
    //设置显示的view
    [drawpad setDrawPadPreView:filterView];
    
    //增加一个视频画笔,并给画笔增加滤镜.
    GPUImageSepiaFilter *filter=[[GPUImageSepiaFilter alloc] init];
    mainVideoPen=[drawpad addVideoPen:[SDKFileUtil urlToFileString:sampleURL] filter:filter];
    
    //设置进度
    __weak typeof(self) weakSelf = self;
    [drawpad setOnProgressBlock:^(CGFloat sampleTime) {
          dispatch_async(dispatch_get_main_queue(), ^{
              weakSelf.progressLabel.text = [NSString stringWithFormat:@"%f",sampleTime];  //后面更改为weak版本的self
          });
      }];
    
    //设置完成后的回调
    [drawpad setOnCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.progressLabel.text=@"完成";  //后面更改为weak版本的self
            [weakSelf showIsPlayDialog];
            
        });
    }];
    
    //开始drawpad
    
    if (_isAddUIPen) {
        UIView *mainView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 240.0f, 320.0f)];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0f, 60.0f)];
        timeLabel.font = [UIFont systemFontOfSize:17.0f];
        timeLabel.text = @"Time: 0.0 s";
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor whiteColor];
        
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0,80, 100.0f, 60.0f)];
        [btn setTitle:@"按钮" forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor redColor];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        [mainView addSubview:timeLabel];
        [mainView addSubview:btn];
        
        [self.view addSubview:mainView];
        
        [drawpad addUIPen:mainView fromUI:NO];
    }
    
     [drawpad startDrawPad];
}

- (void)retrievingProgress
{
//    self.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(movieDecoder.progress * 100)];
}

- (void)viewDidUnload
{
    [self setProgressLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)updatePixelWidth:(id)sender
{
    //暂时没有效果.
}

- (void)dealloc {
//    [_progressLabel release];
//    [super dealloc];
}
//------------------------提示是否要播放.
-(void)showIsPlayDialog
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"视频已经处理完毕,是否需要预览" delegate:self cancelButtonTitle:@"预览" otherButtonTitles:@"返回", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"当前是否需要预览:%d",buttonIndex);
    if (buttonIndex==0) {  //修改延时
        [self startVideoPlayerVC];
    }else {  //返回
        
    }
}
-(void)startVideoPlayerVC
{
    if ([SDKFileUtil fileExist:dstPath]) {
        VideoPlayViewController *videoVC=[[VideoPlayViewController alloc] initWithNibName:@"VideoPlayViewController" bundle:nil];
        videoVC.videoPath=dstPath;
        [self.navigationController pushViewController:videoVC animated:YES];
    }
}
@end
