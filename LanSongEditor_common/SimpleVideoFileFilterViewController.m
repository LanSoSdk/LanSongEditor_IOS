#import "SimpleVideoFileFilterViewController.h"

@implementation SimpleVideoFileFilterViewController
{
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
    
    dstPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([dstPath UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:dstPath];
    
    
    
    movieFile = [[LanSongMovie alloc] initWithURL:sampleURL];
    movieFile.runBenchmark = NO;
    movieFile.playAtActualSpeed = YES;
    
    LanSongView *filterView = (LanSongView *)self.view;
    movieWriter = [[LanSongMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 480.0)];
    
    
    filter = [[LanSongPixellateFilter alloc] init];
    
    //传递关系
    [movieFile addTarget:filter];
    [filter addTarget:filterView];
    [filter addTarget:movieWriter];
    
    
    //视频关系
    movieWriter.shouldPassthroughAudio = YES;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    
    
    //开始.
    [movieWriter startRecording];
    [movieFile startProcessing];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                             target:self
                                           selector:@selector(retrievingProgress)
                                           userInfo:nil
                                            repeats:YES];
    
    [movieWriter setCompletionBlock:^{
        [filter removeTarget:movieWriter];
        [movieWriter finishRecording];
        
        NSLog(@"处理完毕....");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [timer invalidate];
            self.progressLabel.text = @"100%";
            [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
        });
    }];

    
    //------------------------一下是OK的
//    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"ping20s" withExtension:@"mp4"];
//    
//    dstPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
//    unlink([dstPath UTF8String]);
//    NSURL *movieURL = [NSURL fileURLWithPath:dstPath];
//
//    
//    
//    movieFile = [[LanSongMovie alloc] initWithURL:sampleURL];
//    movieFile.runBenchmark = NO;
//    movieFile.playAtActualSpeed = YES;
//    
//    LanSongView *filterView = (LanSongView *)self.view;
//    movieWriter = [[LanSongMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 480.0)];
//    
//    
//    filter = [[LanSongPixellateFilter alloc] init];
//    
//    //传递关系
//    [movieFile addTarget:filter];
//    [filter addTarget:filterView];
//    [filter addTarget:movieWriter];
//
//    
//    //视频关系
//    movieWriter.shouldPassthroughAudio = YES;
//    movieFile.audioEncodingTarget = movieWriter;
//    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
//    
//    
//    //开始.
//    [movieWriter startRecording];
//    [movieFile startProcessing];
//    
//    timer = [NSTimer scheduledTimerWithTimeInterval:0.3f
//                                             target:self
//                                           selector:@selector(retrievingProgress)
//                                           userInfo:nil
//                                            repeats:YES];
//    
//    [movieWriter setCompletionBlock:^{
//        [filter removeTarget:movieWriter];
//        [movieWriter finishRecording];
//        
//        NSLog(@"处理完毕....");
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [timer invalidate];
//            self.progressLabel.text = @"100%";
//             [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
//        });
//    }];
}

- (void)retrievingProgress
{
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(movieFile.progress * 100)];
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
    [(LanSongPixellateFilter *)filter setFractionalWidthOfAPixel:[(UISlider *)sender value]];
}

- (void)dealloc {
    
}
@end
