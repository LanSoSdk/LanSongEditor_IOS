//
//  CameraPenDemoVC.m
//  LanSongEditor_all
//
//  Created by sno on 17/1/7.
//  Copyright © 2017年 sno. All rights reserved.
//

#import "CameraPenDemoVC.h"

#import "LanSongUtils.h"
#import "BlazeiceDooleView.h"
#import "FilterTpyeList.h"


// 定义录制的时间,这里是15秒
#define  CAMERAPEN_RECORD_MAX_TIME 15

@interface CameraPenDemoVC ()
{
    DrawPadDisplay *drawpad;
    
    NSString *dstPath;
    
    Pen *operationPen;  //当前操作的画笔
    
    
    FilterTpyeList *filterListVC;
    BOOL  isSelectFilter;
}
@end

@implementation CameraPenDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
    dstPath = [SDKFileUtil genFileNameWithSuffix:@"mp4"];
    if ([SDKFileUtil fileExist:dstPath]) {
        [SDKFileUtil deleteFile:dstPath];
    }
    dstPath = [SDKFileUtil genFileNameWithSuffix:@"mp4"];
    
    /*
     
     step1:第一步: 创建画板(尺寸,码率,编码后的目标文件路径,增加一个预览view)
     
     */
        CGFloat drawPadWidth=480;
        CGFloat drawPadHeight=480;
        int drawPadBitRate=1000*1000;
    
    drawpad=[[DrawPadDisplay alloc] initWithWidth:drawPadWidth height:drawPadHeight bitrate:drawPadBitRate dstPath:dstPath];
    
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    DrawPadView *filterView=[[DrawPadView alloc] initWithFrame:CGRectMake(0, 60, size.width,size.width*(drawPadHeight/drawPadWidth))];
    
    [self.view addSubview: filterView];
    [drawpad setDrawPadPreView:filterView];
    
    
    /*
    
     step2:第二步: 增加一些画笔,当然您也可以在画板开始后增加
     
     */
    //摄像头的背景
    UIImage *imag=[UIImage imageNamed:@"p640x1136"];
    [drawpad addBitmapPen:imag];
    
    
    //增加摄像头画笔, 你可以认为是一个图层
    operationPen=  [drawpad addCameraPen:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    ((CameraPen *)operationPen).outputImageOrientation = UIInterfaceOrientationPortrait;  //设置当前手机屏幕是 横屏.
    
    
    /*
     
     step3:第三步, 设置 进度回调,完成回调, 开始执行.
     
     */
    __weak typeof(self) weakSelf = self;
    [drawpad setOnProgressBlock:^(CGFloat currentPts) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.labProgress.text=[NSString stringWithFormat:@"当前进度 %f",currentPts];
            if (currentPts>=CAMERAPEN_RECORD_MAX_TIME) {
                [weakSelf stopDrawPad];
            }
        });
    }];
    
    //设置完成后的回调
    [drawpad setOnCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf showIsPlayDialog];
            
        });
    }];
    
    // 开始工作
    [drawpad startDrawPad];
    
    
    //----一下是ui操作.
    _labProgress=[[UILabel alloc] init];
    _labProgress.textColor=[UIColor redColor];
    
    [self.view addSubview:_labProgress];
    
    [_labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(filterView.mas_bottom).offset(padding);
        make.centerX.mas_equalTo(filterView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
    
    UISlider *slide=[self createSlide:_labProgress min:0.0f max:1.0f value:0.5f tag:101 labText:@"效果调节 "];
    
    UIButton *btnFilter=[[UIButton alloc] init];
    
    
    [btnFilter setTitle:@"请选择滤镜效果" forState:UIControlStateNormal];
    [btnFilter setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnFilter.backgroundColor=[UIColor whiteColor];
    
    [btnFilter addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnFilter];
    
    [btnFilter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(slide.mas_bottom).offset(padding);
        make.centerX.mas_equalTo(filterView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(180, 80));
    }];
    
    
    filterListVC=[[FilterTpyeList alloc] initWithNibName:nil bundle:nil];
    filterListVC.filterSlider=slide;
    filterListVC.filterPen=operationPen;
    
}
-(void)stopDrawPad
{
    [drawpad stopDrawPad];
}
-(void)viewDidAppear:(BOOL)animated
{
    isSelectFilter=NO;
}
-(void)viewDidDisappear:(BOOL)animated
{
    if (drawpad!=nil && isSelectFilter==NO) {
        [drawpad stopDrawPad];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)doButtonClicked:(UIView *)sender
{
    isSelectFilter=YES;
    [self.navigationController pushViewController:filterListVC animated:YES];
}
-(void)dealloc
{
    operationPen=nil;
    drawpad=nil;
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

