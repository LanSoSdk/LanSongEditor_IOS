//
//  CameraPenFullLandscapeVC.m
//  LanSongEditor_all
//
//  Created by sno on 2017/9/23.
//  Copyright © 2017年 sno. All rights reserved.
//

#import "CameraPenFullLandscapeVC.h"
#import "LanSongUtils.h"
#import "BlazeiceDooleView.h"
#import "FilterTpyeList.h"
#import <LanSongEditorFramework/MyEncoder3.h>
#import <LanSongEditorFramework/DrawPadCamera.h>

// 定义录制的时间,这里是15秒
#define  CAMERAPEN_RECORD_MAX_TIME 2

@interface CameraPenFullLandscapeVC ()
{
    
    NSString *dstPath;
    
    Pen *operationPen;  //当前操作的图层
    
    
    FilterTpyeList *filterListVC;
    BOOL  isSelectFilter;
    
    DrawPadView *filterView;
    DrawPadCamera *camDrawPad;
    BOOL isPaused;
    
    CGFloat screenWidth, screenHeight;
    
}
@end

@implementation CameraPenFullLandscapeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
     [LanSongUtils setViewControllerLandscape];
    
    /*
     step1:第一步: 创建画板(尺寸,编码后的目标文件路径,增加一个预览view)
     */
    CGFloat padWidth=960;
    CGFloat padHeight=540;
    
    camDrawPad=[[DrawPadCamera alloc] initWithPadSize:CGSizeMake(padWidth, padHeight)];
    
    //因为是横屏, 宽高调换.
    screenWidth=self.view.bounds.size.height;
    screenHeight=self.view.bounds.size.width;
    
    /*
     step2:第二步: 增加一个显示View
     */
    filterView =[[DrawPadView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.view addSubview: filterView];
    [camDrawPad setDrawPadDisplay:filterView];
    
    
    //增加一个图片, 默认xy居中, 这里设置x在最右边.
    UIImage *image=[UIImage imageNamed:@"small"];
    BitmapPen *bmpPen=    [camDrawPad addBitmapPen:image];
    bmpPen.positionX=bmpPen.drawPadSize.width-bmpPen.penSize.width/2;

    
    /*
     step3:  开始预览
     */
    [camDrawPad startPreview];
    
    __weak typeof(self) weakSelf = self;
    [camDrawPad setOnProgressBlock:^(CGFloat currentPts) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"progressBlock is:%f", currentPts);
            weakSelf.labProgress.text=[NSString stringWithFormat:@"当前进度 %f",currentPts];
        });
    }];
    
    [self initView];
    
}
-(void)doButtonClicked:(UIView *)sender
{
    switch (sender.tag) {
        case 101 :  //filter
            isSelectFilter=YES;
            [self.navigationController pushViewController:filterListVC animated:YES];
            
            
            //            isPaused=!isPaused;
            //            [camDrawPad pauseRecord:isPaused];
            
            break;
        case  102:  //btnStart;
            dstPath=[SDKFileUtil genTmpMp4Path];  //这里创建一个路径.
            
            [camDrawPad startRecordWithPath:dstPath];
            
            break;
        case  103:  //btnOK;
//            [camDrawPad stopPreview];
            [camDrawPad stopRecord];
            [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
            break;
        default:
            break;
    }
}
-(void)stopDrawPad
{
    //    [drawpad stopDrawPad];
}

-(void)viewDidAppear:(BOOL)animated
{
    isSelectFilter=NO;
    [LanSongUtils setViewControllerLandscape];
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


-(void)showIsPlayDialog
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"视频已经处理完毕,是否需要预览" delegate:self cancelButtonTitle:@"预览" otherButtonTitles:@"返回", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
    }else {  //返回
        
    }
}
-(void)initView
{
    CGFloat padding=screenHeight*0.01;
    CGFloat  layHeight=screenHeight*0.5;
    
    _labProgress=[[UILabel alloc] init];
    _labProgress.textColor=[UIColor redColor];
    
    [self.view addSubview:_labProgress];
    
    [_labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(layHeight);
        make.centerX.mas_equalTo(filterView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(screenWidth, 40));
    }];
    
    UISlider *slide=[self createSlide:_labProgress min:0.0f max:1.0f value:0.5f tag:101 labText:@"效果调节 "];
    
    UIButton *btnFilter=[[UIButton alloc] init];
    [btnFilter setTitle:@"滤镜" forState:UIControlStateNormal];
    [btnFilter setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnFilter.backgroundColor=[UIColor whiteColor];
    btnFilter.tag=101;
    
    
    UIButton *btnStart=[[UIButton alloc] init];
    [btnStart setTitle:@"开始" forState:UIControlStateNormal];
    [btnStart setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnStart.backgroundColor=[UIColor whiteColor];
    btnStart.tag=102;
    
    
    UIButton *btnOK=[[UIButton alloc] init];
    [btnOK setTitle:@"停止" forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnOK.backgroundColor=[UIColor whiteColor];
    btnOK.tag=103;
    
    
    [btnStart addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnOK addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnFilter addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:btnFilter];
    [self.view addSubview:btnStart];
    [self.view addSubview:btnOK];
    
    
    
    [btnStart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(slide.mas_bottom).offset(padding);
        make.left.mas_equalTo(filterView.mas_left).offset(padding);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    [btnOK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(slide.mas_bottom).offset(padding);
        make.left.mas_equalTo(btnStart.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [btnFilter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(slide.mas_bottom).offset(padding);
        make.left.mas_equalTo(btnOK.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    filterListVC=[[FilterTpyeList alloc] initWithNibName:nil bundle:nil];
    filterListVC.filterSlider=slide;
    filterListVC.filterPen=operationPen;
}

-(void)dealloc
{
    operationPen=nil;
    camDrawPad=nil;
    if([SDKFileUtil fileExist:dstPath]){
        [SDKFileUtil deleteFile:dstPath];
    }
    NSLog(@"CameraPenDemoVC  dealloc");
}
/**
 滑动 效果调节后的相应
 
 */
- (void)slideChanged:(UISlider*)sender
{
    switch (sender.tag) {
        case 101:  //weizhi
            [filterListVC updateFilterFromSlider:sender];
            break;
        default:
            break;
    }
}
/**
 初始化一个slide 返回这个UISlider对象
 */
-(UISlider *)createSlide:(UIView *)topView  min:(CGFloat)min max:(CGFloat)max  value:(CGFloat)value tag:(int)tag labText:(NSString *)text;
{
    UILabel *labPos=[[UILabel alloc] init];
    labPos.text=text;
    
    UISlider *slideFilter=[[UISlider alloc] init];
    
    slideFilter.maximumValue=max;
    slideFilter.minimumValue=min;
    slideFilter.value=value;
    slideFilter.continuous = YES;
    slideFilter.tag=tag;
    
    [slideFilter addTarget:self action:@selector(slideChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    [self.view addSubview:labPos];
    [self.view addSubview:slideFilter];
    
    
    [labPos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(padding);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [slideFilter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(labPos.mas_centerY);
        make.left.mas_equalTo(labPos.mas_right).offset(padding);
        make.right.mas_equalTo(self.view.mas_right).offset(-padding);
    }];
    return slideFilter;
}

@end

