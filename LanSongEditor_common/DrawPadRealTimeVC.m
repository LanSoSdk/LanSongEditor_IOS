#import "DrawPadRealTimeVC.h"

@implementation DrawPadRealTimeVC
{
    int frameCount;
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
    
   
    NSString *pathToMovie = [SDKFileUtil genTmpMp4Path];

   
    
    drawpad =[[DrawPadView alloc] initWithPath:[SDKFileUtil urlToFileString:sampleURL] dstPath:pathToMovie];
    
    GPUImageFilter *filter= (GPUImageFilter *)[[GPUImageSepiaFilter alloc] init];
    
    [drawpad setDrawPadPreView:self.view filter:filter];
    
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
//    [(GPUImageUnsharpMaskFilter *)filter setIntensity:[(UISlider *)sender value]];
//    [(GPUImagePixellateFilter *)filter setFractionalWidthOfAPixel:[(UISlider *)sender value]];
}

- (void)dealloc {
//    [_progressLabel release];
//    [super dealloc];
}
@end
