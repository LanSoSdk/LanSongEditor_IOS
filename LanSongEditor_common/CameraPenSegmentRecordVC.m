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

#import <LanSongEditorFramework/DrawPadCamera.h>

/**
 最小的视频时长,如果小于这个, 则视频认为没有录制.
 */
#define MIN_VIDEO_DURATION 2.0f


/**
 定义视频录制的最长时间, 如果超过这个时间,则默认为视频录制已经完成.
 
 */
#define MAX_VIDEO_DURATION 8.0f

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
            
            NSLog(@"progressBlock is:%f", currentPts);
            weakSelf.labProgress.text=[NSString stringWithFormat:@"当前进度 %f",currentPts];
            
            //更新时间戳.
            if(weakSelf.progressBar!=nil){
                [weakSelf.progressBar setLastSegmentPts:currentPts];
            }
            
            //走过最小
            if( (totalDuration+ currentPts)>=MIN_VIDEO_DURATION){
                weakSelf.okButton.enabled=YES;
                [weakSelf.deleteButton setButtonStyle:DeleteButtonStyleNormal];
            }
            //走过最大.则停止.
            if((totalDuration + currentPts)>=MAX_VIDEO_DURATION){
                [weakSelf finishSegment];
            }
            
            currentSegmentDuration=currentPts;
            
        });
    }];
    
    
    /*
     开始预览
     */
    [camDrawPad startPreview];
    
    
    segmentArray=[[NSMutableArray alloc] init];
    totalDuration=0;
    currentSegmentDuration=0;
    segmentPath=nil;
    
    [self initView];
}

/**
 开始分段录制
 */
-(void)startSegment
{
    [_progressBar addNewSegment];
    currentSegmentDuration=0;
    segmentPath=[SDKFileUtil genTmpMp4Path];  //这里创建一个路径.
    [camDrawPad startRecordWithPath:segmentPath];
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
            
            NSLog(@"增加一个 segment:%lu",(unsigned long)segmentArray.count);
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
        
        [VideoEditor executeConcatMP4:fileArray dstFile:dstPath];
        if([SDKFileUtil fileExist:dstPath]==NO){
            [LanSongUtils showHUDToast:@"抱歉,文件合成失败!,请联系我们"];
        }
    }else if(segmentArray.count==1){
        SegmentFile *data=[segmentArray objectAtIndex:0];
        dstPath=data.segmentPath;
    }else{  //为空.
        NSLog(@"segment array is empty");
    }
    
    if([SDKFileUtil fileExist:dstPath]){
        [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    isSelectFilter=NO;
}
-(void)viewDidDisappear:(BOOL)animated
{
    //    if (drawpad!=nil && isSelectFilter==NO) {
    //        [drawpad stopDrawPad];
    //    }
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
        [self startSegment];
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
}
-(void)dealloc
{
    operationPen=nil;
    if([SDKFileUtil fileExist:dstPath]){
        [SDKFileUtil deleteFile:dstPath];
    }
    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
    for (SegmentFile *data in segmentArray) {
        [fileArray addObject:data.segmentPath];
    }
    
    [SDKFileUtil deleteAllFiles:fileArray];
    segmentArray=nil;
    
    NSLog(@"CameraPenDemoVC  dealloc");
}
@end

