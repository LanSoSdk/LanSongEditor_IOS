//
//  CameraSegmentRecordVC.m
//  LanSongEditor_all
//
//  Created by sno on 2018/6/6.
//  Copyright © 2018年 sno. All rights reserved.
//

#import "CameraSegmentRecordVC.h"

#import "LanSongUtils.h"
#import "BlazeiceDooleView.h"
#import "FilterTpyeList.h"
#import "SegmentRecordProgressView.h"
#import "DeleteButton.h"
#import "BeautyManager.h"

#import "VideoPlayViewController.h"

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

//LSTODO 只是临时保留, 没有整理;
@interface CameraSegmentRecordVC ()
{
    
    NSString *dstPath;
    
    LSOPen *operationPen;  //当前操作的图层
    
    
    FilterTpyeList *filterListVC;
    
    
    LanSongView2  *lansongView;
    DrawPadCameraPreview *drawPadCamera;
    
    BOOL isPaused;
    
    
    NSMutableArray  *segmentArray;  //存放的是当前段的SegmentFile对象.
    
    CGFloat  nvheight;
    CGFloat  totalDuration; //总时长.
    CGFloat  currentSegmentDuration; //当前段的时长;
    
    
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

@implementation CameraSegmentRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blackColor];
    [LanSongUtils setViewControllerPortrait];
    
    beautyLevel=0;
    beautyMng=[[BeautyManager alloc] init];
    
    
    //    iphoneX Xs 375 x 812;  (0.5625 则是667);
    //    ihponeXs-r Xs-max  414 x 896 (0.5625 则是736);
    CGSize  fullSize=[[UIScreen mainScreen] bounds].size;
    CGFloat top=0;
    if(fullSize.width * fullSize.height ==375*812){
        fullSize.height=667;
        top=(812-667)/2;
    }else if(fullSize.width * fullSize.height==414*896){
        fullSize.height=736;
        top=(896-736)/2;
    }
    
    CGRect rect=CGRectMake(0, top, fullSize.width, fullSize.height);
    NSLog(@"full size is :%f %f, full radio:%f, 540 rect is:%f",fullSize.width,fullSize.height, fullSize.width/fullSize.height, rect.size.width/rect.size.height);
    
    lansongView = [[LanSongView2 alloc] initWithFrame:rect];
    [self.view addSubview:lansongView];
    
    drawPadCamera=[[DrawPadCameraPreview alloc] initFullScreen:lansongView isFrontCamera:YES];
    drawPadCamera.cameraPen.horizontallyMirrorFrontFacingCamera=YES;
    
    //增加图片图层
    UIImage *image=[UIImage imageNamed:@"small"];
    LSOBitmapPen *bmpPen=    [drawPadCamera addBitmapPen:image];
    bmpPen.positionX=bmpPen.drawPadSize.width-bmpPen.penSize.width/2;
    bmpPen.positionY=bmpPen.penSize.height/2;
    
    
    //增加mv图层
    NSURL *colorPath = [[NSBundle mainBundle] URLForResource:@"mei" withExtension:@"mp4"];
    NSURL *maskPath = [[NSBundle mainBundle] URLForResource:@"mei_b" withExtension:@"mp4"];
    [drawPadCamera addMVPen:colorPath withMask:maskPath];
    
    //开始预览
    [drawPadCamera startPreview];
    [beautyMng addBeauty:drawPadCamera.cameraPen];
    
    
    //初始化其他UI界面.
    [self initView];
    
    segmentArray=[[NSMutableArray alloc] init];
    totalDuration=0;
    currentSegmentDuration=0;
    beautyLevel=0;
    
    [self initView];
}
-(void)drawpadProgress:(CGFloat)currentPts
{
    LSOLog(@"录制进度...%f",currentPts);
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
        [self stopSegmentAndFinish];
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
    
    [beautyMng addBeauty:drawPadCamera.cameraPen];
    
    __weak typeof (self) weakSelf=self;
    [drawPadCamera setProgressBlock:^(CGFloat progess) {
        dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf drawpadProgress:progess];
        });
    }];
    [drawPadCamera startRecord];
}

/**
 结束 当前段录制.
 */
-(void)stopSegment
{
    if(drawPadCamera.isRecording && currentSegmentDuration>0)
    {
        [drawPadCamera stopRecord:^(NSString *path) {
            if([LSOFileUtil fileExist:path])
            {
                SegmentFile *file=[[SegmentFile alloc] init];
                file.segmentPath=path;
                file.duration=currentSegmentDuration;
                
                [segmentArray addObject:file];
                totalDuration+=currentSegmentDuration;
            }else{
                LSOLog(@"当前段文件不存在....");
            }
        }];
    }
}

/**
 停止当前段,并开始拼接;
 */
-(void)stopSegmentAndFinish
{
    if(drawPadCamera.isRecording && currentSegmentDuration>0)
    {
        __weak typeof (self) weakSelf=self;
        
        [drawPadCamera stopRecord:^(NSString *path) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if([LSOFileUtil fileExist:path])
                {
                    SegmentFile *file=[[SegmentFile alloc] init];
                    file.segmentPath=path;
                    file.duration=currentSegmentDuration;
                    
                    [segmentArray addObject:file];
                    totalDuration+=currentSegmentDuration;
                }else{
                    LSOLog(@"当前段文件不存在....");
                }
                [weakSelf concatVideos];
            });
           
        }];
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
        [LSOFileUtil deleteFile:path.segmentPath];
        
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
 工作在主线程;
 */
-(void)concatVideos
{
    if(segmentArray.count>1){  //合成在一起.
        
        NSMutableArray *fileArray = [[NSMutableArray alloc] init];
        for (SegmentFile *data in segmentArray) {
            [fileArray addObject:data.segmentPath];
        }
        //开始拼接起来;
        
        dstPath=[LSOFileUtil genTmpMp4Path];
        [LSOVideoEditor executeConcatMP4:fileArray dstFile:dstPath];  //耗时很少;
        [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
    }else if(segmentArray.count==1){
        SegmentFile *data=[segmentArray objectAtIndex:0];
        dstPath=data.segmentPath;
        [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
    }else{  //为空.
        LSOLog(@"segment array is empty");
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
    if(drawPadCamera!=nil){
        [drawPadCamera startPreview];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    if (drawPadCamera!=nil) {
        [drawPadCamera stopPreview];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 回删按钮
 */
- (void)pressDeleteButton
{
    if (_deleteButton.style == DeleteButtonStyleNormal) {//第一次按下删除按钮
        [_progressBar setWillDeleteMode];
        [_deleteButton setButtonStyle:DeleteButtonStyleDelete];
    } else if (_deleteButton.style == DeleteButtonStyleDelete) {//第二次按下删除按钮
        [self deleteLastSegment];
    }
}

/**
 结束录制按钮
 */
- (void)pressOKButton
{
        [self  concatVideos];
}

/**
 按下录制开始

 @param touches <#touches description#>
 @param event <#event description#>
 */
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

/**
 松开,停止录制

 @param touches <#touches description#>
 @param event <#event description#>
 */
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
    
    
    //关闭按钮
    UIButton *btnClose=[[UIButton alloc] initWithFrame:CGRectMake(0, 10, 90, 90)];
    [btnClose setTitle:@"关闭" forState:UIControlStateNormal];
    [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
                [beautyMng addBeauty:drawPadCamera.cameraPen];
                beautyLevel+=0.22;
            }else{
                beautyLevel+=0.1;
                [beautyMng setWarmCoolEffect:beautyLevel];
                if(beautyLevel>1.0){ //删除美颜
                    [beautyMng deleteBeauty:drawPadCamera.cameraPen];
                    beautyLevel=0;
                }
            }
            break;
        case 202:
            if(drawPadCamera!=nil){
                [drawPadCamera.cameraPen rotateCamera];
            }
        default:
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
    drawPadCamera=nil;
    
    [LSOFileUtil deleteAllFiles:fileArray];
    segmentArray=nil;
    
    LSOLog(@"CameraPenDemoVC  dealloc");
}
///**
// 把多个视频合并
//
// @param filePathArray 视频数组, NSArray中的类型是 (NSString *)
// @param dstPath 用IOS中的AVAssetExportSession导出的.
// @param handler 异步导出的时候, 如果正常则打印
// */
//- (void)concatVideoWithPath:(NSArray *)filePathArray dstPath:(NSString *)dstVideo handle:(void (^)(void))handler;
//{
//    NSError *error = nil;
//    CMTime durationSum = kCMTimeZero;
//
//    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
//    //第一步:拿到所有的assetTrack,放到数组里.
//    for (NSString *filePath in filePathArray)
//    {
//        AVAsset *asset = [AVAsset assetWithURL:[LSOFileUtil filePathToURL:filePath]];
//        if (!asset) {
//            continue;
//        }
//        //加音频
//        AVMutableCompositionTrack *dstAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//        [dstAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
//                               ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
//                                atTime:durationSum
//                                 error:nil];
//        //加视频
//        AVMutableCompositionTrack *dstVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//
//
//        [dstVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
//                               ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
//                                atTime:durationSum
//                                 error:&error];
//        if(error!=nil){
//            LSOLog(@"error is :%@",error);
//        }
//        //总时间累积;
//        durationSum = CMTimeAdd(durationSum, asset.duration);
//    }
//
//    //get save path
//    NSURL *mergeFileURL =[LSOFileUtil filePathToURL:dstVideo];
//
//    //export
//    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPreset960x540];
//    exporter.outputURL = mergeFileURL;
//    exporter.outputFileType = AVFileTypeMPEG4;
//    exporter.shouldOptimizeForNetworkUse = NO;
//    [exporter exportAsynchronouslyWithCompletionHandler:^(void){
//        switch (exporter.status)
//        {
//            case AVAssetExportSessionStatusCompleted:
//            {
//
//                if(handler!=nil){
//                    handler();
//                }
//            }
//                break;
//            case AVAssetExportSessionStatusFailed:
//                LSOLog(@"ExportSessionError--Failed: %@", [exporter.error localizedDescription]);
//                break;
//            case AVAssetExportSessionStatusCancelled:
//                LSOLog(@"ExportSessionError--Cancelled: %@", [exporter.error localizedDescription]);
//                break;
//            default:
//                LSOLog(@"Export Failed: %@", [exporter.error localizedDescription]);
//                break;
//        }
//    }];
//}




@end

