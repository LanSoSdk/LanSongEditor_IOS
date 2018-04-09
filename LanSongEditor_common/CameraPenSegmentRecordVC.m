//
//  CameraPenSegmentRecordVC.m
//  LanSongEditor_all
//
//  Created by sno on 2017/9/26.
//  Copyright © 2017年 sno. All rights reserved.
//

#import "CameraPenSegmentRecordVC.h"

#import "LanSongUtils.h"
#import "BlazeiceDooleView.h"
#import "FilterTpyeList.h"
#import "SegmentRecordProgressView.h"
#import "DeleteButton.h"
#import "Demo3PenFilterVC.h"



/**
 最小的视频时长,如果小于这个, 则视频认为没有录制.
 */
#define MIN_VIDEO_DURATION 2.0f


/**
 定义视频录制的最长时间, 如果超过这个时间,则默认为视频录制已经完成.
 
 */
#define MAX_VIDEO_DURATION 15.0f

@interface SegmentFile: NSObject

@property (assign, nonatomic) CGFloat duration;
@property (strong, nonatomic) NSString *segmentPath;

@end

@implementation SegmentFile

@end

@interface CameraPenSegmentRecordVC ()
{
    
    NSString *dstPath;
    
    Pen *operationPen;  //当前操作的图层
    
    
    FilterTpyeList *filterListVC;
    BOOL  isSelectFilter;
    
    
    DrawPadCamera *camDrawPad;
    BOOL isPaused;
    
    
    NSMutableArray  *segmentArray;  //存放的是当前段的SegmentFile对象.
    
    NSString * segmentPath;
    CGFloat  nvheight;
    CGFloat  totalDuration; //总时长.
    CGFloat  currentSegmentDuration; //当前段的时长;
    
    
    UISegmentedControl *segmentSpeed;
    float recordSpeed;  //录制的速度
    BeautyManager *beautyMng;
    float beautyLevel;
}
@property (strong, nonatomic) SegmentRecordProgressView *progressBar;


@property (strong, nonatomic) DeleteButton *deleteButton;
@property (strong, nonatomic) UIButton *okButton;

@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *settingButton;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) UIButton *flashButton;
@end

@implementation CameraPenSegmentRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    /*
     创建容器(尺寸,码率,编码后的目标文件路径,增加一个预览view)
     */
    CGFloat padWidth=540;
    CGFloat padHeight=960;
    camDrawPad=[[DrawPadCamera alloc] initWithPadSize:CGSizeMake(padWidth, padHeight) isFront:NO];
    
    /*
     增加一个显示view
     */
    DrawPadView *filterView=[[DrawPadView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview: filterView];
    [camDrawPad setDrawPadDisplay:filterView];
    
    /*
     设置进度回调
     */
    __weak typeof(self) weakSelf = self;
    [camDrawPad setOnProgressBlock:^(CGFloat currentPts) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf padProgress:currentPts];
        });
    }];
    beautyMng=[[BeautyManager alloc] init];
    segmentArray=[[NSMutableArray alloc] init];
    totalDuration=0;
    currentSegmentDuration=0;
    segmentPath=nil;
    beautyLevel=0;
    
    [self initView];
}
-(void)padProgress:(CGFloat)currentPts
{
    //更新时间戳.
    if(self.progressBar!=nil){
        [self.progressBar setLastSegmentPts:currentPts];
    }
    
    //走过最小
    if( (totalDuration+ currentPts)>=MIN_VIDEO_DURATION){
        self.okButton.enabled=YES;
        [self.deleteButton setButtonStyle:DeleteButtonStyleNormal];
    }
    //走过最大.则停止.
    if((totalDuration + currentPts)>=MAX_VIDEO_DURATION){
        [self finishSegment];
    }
    
    currentSegmentDuration=currentPts;
}
/**
 开始分段录制
 */
-(void)startSegmentRecord
{
    [_progressBar addNewSegment];
    currentSegmentDuration=0;
    segmentPath=[SDKFileUtil genTmpMp4Path];  //这里创建一个路径.
    
    [beautyMng addBeauty:camDrawPad.cameraPen];
    
    NSLog(@"当前的速度是:%f", recordSpeed);
    [camDrawPad startRecordWithPath:segmentPath speedRate: recordSpeed];
}

/**
 结束 当前段录制.
 */
-(void)stopSegment
{
    if(camDrawPad.isRecording && currentSegmentDuration>0)
    {
        [camDrawPad stopRecord];
        
        if([SDKFileUtil fileExist:segmentPath])
        {
            SegmentFile *file=[[SegmentFile alloc] init];
            file.segmentPath=segmentPath;
            file.duration=currentSegmentDuration;
            
            [segmentArray addObject:file];
            totalDuration+=currentSegmentDuration;
        }else{
            LSLog(@"当前段文件不存在....");
        }
        //增加完毕, 要复位.
        segmentPath=nil;
    }
}

/**
 删除 最后一段.
 */
-(void)deleteLastSegment
{
    if(segmentArray.count>0){  //删除最后一个.
        SegmentFile *path=[segmentArray objectAtIndex:segmentArray.count-1];
        
        [segmentArray removeObject:path];
        [SDKFileUtil deleteFile:path.segmentPath];
        
        if(totalDuration>=path.duration){
            totalDuration-=path.duration;
        }
        [_progressBar deleteLastSegment];//删除对应的界面.
    }
    if (segmentArray.count > 0) {
        [_deleteButton setButtonStyle:DeleteButtonStyleNormal];
    } else {
        [_deleteButton setButtonStyle:DeleteButtonStyleDisable];
    }
}
/**
 结束分段录制,
 
 拼接在一起然后播放;
 */
-(void)finishSegment
{
    if(camDrawPad.isRecording){  //如果正在录制, 结束当前段的录制.
        [self stopSegment];
    }
    if(segmentArray.count>1){  //合成在一起.
        dstPath=[SDKFileUtil genTmpMp4Path];
        
        
        NSMutableArray *fileArray = [[NSMutableArray alloc] init];
        for (SegmentFile *data in segmentArray) {
            [fileArray addObject:data.segmentPath];
        }
        
        //把数组中的各段视频都拼接在一起;
        [self concatVideoWithPath:fileArray dstPath:dstPath handle:^{
            //拼接后,跳入另一个VC中开始播放;
            dispatch_async(dispatch_get_main_queue(), ^{
                EditFileBox *box=[[EditFileBox alloc] initWithPath:dstPath];
                [AppDelegate getInstance].currentEditBox=box;
                
                Demo3PenFilterVC *videoVC=[[Demo3PenFilterVC alloc] init];
                [self.navigationController pushViewController:videoVC animated:YES];
            });
        }];
        
        
    }else if(segmentArray.count==1){
        SegmentFile *data=[segmentArray objectAtIndex:0];
        dstPath=data.segmentPath;
        
        if([SDKFileUtil fileExist:dstPath]){
            EditFileBox *box=[[EditFileBox alloc] initWithPath:dstPath];
            [AppDelegate getInstance].currentEditBox=box;
            
            
            //打开其他界面;
//            Demo3PenFilterVC *videoVC=[[Demo3PenFilterVC alloc] init];
//            [self.navigationController pushViewController:videoVC animated:YES];
            
                //直接预览界面;
               [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
        }
        
        
    }else{  //为空.
        NSLog(@"segment array is empty");
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    isSelectFilter=NO;
    
    if(camDrawPad!=nil){
        [camDrawPad startPreview];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    if (camDrawPad!=nil && isSelectFilter==NO) {
        [camDrawPad stopDrawPad];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)pressDeleteButton
{
    if (_deleteButton.style == DeleteButtonStyleNormal) {//第一次按下删除按钮
        [_progressBar setWillDeleteMode];
        [_deleteButton setButtonStyle:DeleteButtonStyleDelete];
    } else if (_deleteButton.style == DeleteButtonStyleDelete) {//第二次按下删除按钮
        [self deleteLastSegment];
    }
}
- (void)pressOKButton
{
    [self  finishSegment];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_deleteButton.style == DeleteButtonStyleDelete) {//取消删除
        [_deleteButton setButtonStyle:DeleteButtonStyleNormal];
        [_progressBar setNormalMode];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:_recordButton.superview];
    
    if (CGRectContainsPoint(_recordButton.frame, touchPoint)) {
        [self startSegmentRecord];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self stopSegment];
}
- (void)initView
{
    nvheight=    self.navigationController.navigationBar.frame.size.height;
    self.progressBar = [SegmentRecordProgressView getInstance];
    self.progressBar.maxDuration=MAX_VIDEO_DURATION;
    
    [LanSongUtils setView:_progressBar toOriginY:(DEVICE_SIZE.height*0.75f + nvheight)];
    
    [self.view addSubview:_progressBar ];
    [_progressBar start];
    
    //录制按钮
    CGFloat buttonW = 80.0f;
    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(
                                                                   (DEVICE_SIZE.width - buttonW) / 2.0,
                                                                   _progressBar.frame.origin.y + _progressBar.frame.size.height + 10,
                                                                   buttonW, buttonW)];
    
    
    [_recordButton setImage:[UIImage imageNamed:@"video_longvideo_btn_shoot.png"] forState:UIControlStateNormal];
    _recordButton.userInteractionEnabled = NO;
    [self.view addSubview:_recordButton];
    
    //ok按钮
    CGFloat okButtonW = 50;
    self.okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, okButtonW, okButtonW)];
    [_okButton setBackgroundImage:[UIImage imageNamed:@"record_icon_hook_normal_bg.png"] forState:UIControlStateNormal];
    [_okButton setBackgroundImage:[UIImage imageNamed:@"record_icon_hook_highlighted_bg.png"] forState:UIControlStateHighlighted];
    
    [_okButton setImage:[UIImage imageNamed:@"record_icon_hook_normal.png"] forState:UIControlStateNormal];
    
    [LanSongUtils setView:_okButton toOrigin:CGPointMake(self.view.frame.size.width - okButtonW - 10, self.view.frame.size.height - okButtonW - 10)];
    
    [_okButton addTarget:self action:@selector(pressOKButton) forControlEvents:UIControlEventTouchUpInside];
    
    CGPoint center = _okButton.center;
    center.y = _recordButton.center.y;
    _okButton.center = center;
    
    [self.view addSubview:_okButton];
    _okButton.enabled = NO; //刚开始的时候, 不能点击.
    
    //删除按钮
    self.deleteButton = [DeleteButton getInstance];
    [_deleteButton setButtonStyle:DeleteButtonStyleDisable];
    
    [LanSongUtils setView:_deleteButton toOrigin:CGPointMake(15, self.view.frame.size.height - _deleteButton.frame.size.height - 10-nvheight)];
    
    [_deleteButton addTarget:self action:@selector(pressDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGPoint center2 = _deleteButton.center;
    center2.y = _recordButton.center.y;
    _deleteButton.center = center2;
    [self.view addSubview:_deleteButton];
    //美颜按钮
    UIButton *btnBeauty=[[UIButton alloc] init];
    [btnBeauty setTitle:@"美颜+/-" forState:UIControlStateNormal];
    [btnBeauty setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnBeauty.titleLabel.font=[UIFont systemFontOfSize:25];
    btnBeauty.tag=201;
      [self.view addSubview:btnBeauty];
      [btnBeauty addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //前置
    UIButton *btnSelect=[[UIButton alloc] init];
    [btnSelect setTitle:@"前置" forState:UIControlStateNormal];
    [btnSelect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSelect.titleLabel.font=[UIFont systemFontOfSize:25];
    btnSelect.tag=202;
    [self.view addSubview:btnSelect];
    [btnSelect addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //--------------------
    //选择按钮
    recordSpeed=1.0;
    NSArray * _titles = @[@"极慢", @"慢",@"标准",@"快",@"极快"];
    segmentSpeed = [[UISegmentedControl alloc] initWithItems:_titles];
    segmentSpeed.selectedSegmentIndex = 2;
    segmentSpeed.autoresizingMask = UIViewAutoresizingFlexibleWidth;//可以自动flex宽度.
    [self.view addSubview:segmentSpeed];
    
    
    [btnBeauty mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(120, 60));
    }];
    [btnSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnBeauty.mas_bottom).offset(10);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [segmentSpeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.progressBar.mas_top).offset(-10);
        make.centerX.mas_equalTo(self.progressBar.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(300, 40));
    }];
    
    [segmentSpeed addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //关闭按钮
    UIButton *btnClose=[[UIButton alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
    [btnClose setTitle:@"关闭" forState:UIControlStateNormal];
    [btnClose setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnClose.titleLabel.font=[UIFont systemFontOfSize:20];
    btnClose.tag=301;
    [btnClose addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];
}
-(void)doButtonClicked:(UIView *)sender
{
    switch (sender.tag) {
        case 301:  //关闭
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 201:  //美颜
            if(beautyLevel==0){  //增加美颜
                [beautyMng addBeauty:camDrawPad.cameraPen];
                beautyLevel+=0.22;
            }else{
                 beautyLevel+=0.1;
                 [beautyMng setWarmCoolEffect:beautyLevel];
                if(beautyLevel>1.0){ //删除美颜
                     [beautyMng deleteBeauty:camDrawPad.cameraPen];
                     beautyLevel=0;
                }
            }
            break;
        case 202:
            if(camDrawPad!=nil){
                [camDrawPad.cameraPen rotateCamera];
            }
        default:
            break;
    }
}
//按钮点击事件
-(void)segmentValueChanged:(UISegmentedControl *)seg{
//    NSLog(@"seg.tag-->%ld",(long)seg.selectedSegmentIndex);
    switch (seg.selectedSegmentIndex) {
        case 0:
            recordSpeed=0.5;
            break;
        case 1:
            recordSpeed=0.75;
            break;
        case 2:
            recordSpeed=1.0;
            break;
        case 3:
            recordSpeed=1.5;
            break;
        case 4:
            recordSpeed=2.0;
            break;
        default:
            recordSpeed=1.0;
            break;
    }
    
}
-(void)dealloc
{
    operationPen=nil;
    
    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
    for (SegmentFile *data in segmentArray) {
        [fileArray addObject:data.segmentPath];
    }
    camDrawPad=nil;
    
    [SDKFileUtil deleteAllFiles:fileArray];
    segmentArray=nil;
    
    NSLog(@"CameraPenDemoVC  dealloc");
}
/**
 把多个视频合并
 
 @param filePathArray 视频数组, NSArray中的类型是 (NSString *)
 @param dstPath 用IOS中的AVAssetExportSession导出的.
 @param handler 异步导出的时候, 如果正常则打印
 */
- (void)concatVideoWithPath:(NSArray *)filePathArray dstPath:(NSString *)dstVideo handle:(void (^)(void))handler;
{
    NSError *error = nil;
    CMTime durationSum = kCMTimeZero;
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    //第一步:拿到所有的assetTrack,放到数组里.
    for (NSString *filePath in filePathArray)
    {
        AVAsset *asset = [AVAsset assetWithURL:[SDKFileUtil filePathToURL:filePath]];
        if (!asset) {
            continue;
        }
        //加音频
        AVMutableCompositionTrack *dstAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [dstAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                               ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                atTime:durationSum
                                 error:nil];
        //加视频
        AVMutableCompositionTrack *dstVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        
        [dstVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                               ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                atTime:durationSum
                                 error:&error];
        if(error!=nil){
            NSLog(@"error is :%@",error);
        }
        //总时间累积;
        durationSum = CMTimeAdd(durationSum, asset.duration);
    }
    
    //get save path
    NSURL *mergeFileURL =[SDKFileUtil filePathToURL:dstVideo];
    
    //export
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPreset960x540];
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = NO;
    [exporter exportAsynchronouslyWithCompletionHandler:^(void){
        switch (exporter.status)
        {
            case AVAssetExportSessionStatusCompleted:
            {
                
                if(handler!=nil){
                    handler();
                }
            }
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"ExportSessionError--Failed: %@", [exporter.error localizedDescription]);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"ExportSessionError--Cancelled: %@", [exporter.error localizedDescription]);
                break;
            default:
                NSLog(@"Export Failed: %@", [exporter.error localizedDescription]);
                break;
        }
    }];
}




@end

