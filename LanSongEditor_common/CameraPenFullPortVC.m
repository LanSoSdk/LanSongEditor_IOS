//
//  TestCameraBeautyVC.m
//  LanSongEditor_all
//
//  Created by sno on 07/03/2018.
//  Copyright © 2018 sno. All rights reserved.
//

#import "CameraPenFullPortVC.h"

#import "LanSongUtils.h"
#import "BlazeiceDooleView.h"
#import "FilterTpyeList.h"
#import "YXLabel.h"
#import "Demo3PenFilterVC.h"


@interface CameraPenFullPortVC ()
{
    
    NSString *dstPath;
    
    FilterTpyeList *filterListVC;
    BOOL  isSelectFilter;
    
    UISegmentedControl *segmentSpeed;
    UISlider *filterSlider;
    DrawPadCamera *drawPad;
    CameraPen  *cameraPen;
    DrawPadView *filterView;
    BitmapPen *bmpPen;
    YXLabel *label; //test
    
    BOOL isPaused;
    CGFloat padWidth;
    CGFloat padHeight;
    
    BeautyManager *beautyMng;
}
@end

@implementation CameraPenFullPortVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    /*
     step1:第一步: 创建容器(尺寸,码率,编码后的目标文件路径,增加一个预览view)
     */
    padWidth=540;
    padHeight=960;
    
    filterView=[[DrawPadView alloc] initWithFrame:self.view.frame];
    [self.view addSubview: filterView];
    filterView.tag=222;
    
    
    beautyMng=[[BeautyManager alloc] init];
    
    //初始化其他UI界面.
    [self initView];
    
    filterListVC=[[FilterTpyeList alloc] initWithNibName:nil bundle:nil];
    filterListVC.filterSlider=filterSlider;
    
    drawPad=[[DrawPadCamera alloc] initWithPadSize:CGSizeMake(padWidth, padHeight) isFront:YES sessionPreset:AVCaptureSessionPreset1280x720];
    
    [drawPad setDrawPadDisplay:filterView];
    
    //获得摄像头图层
    cameraPen=drawPad.cameraPen;
    filterListVC.filterPen=drawPad.cameraPen;
    
    //进度显示.
    __weak typeof(self) weakSelf = self;
    [drawPad setOnProgressBlock:^(CGFloat currentPts) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf progressBlock:currentPts];
        });
    }];
    
}
-(void)progressBlock:(CGFloat)currentPts
{
    _labProgress.text=[NSString stringWithFormat:@"当前进度 %f",currentPts];
    //    if(cameraPen!=nil){
    //        LSLog(@"camera pen size is:%d,%d",cameraPen.pixelWidth,cameraPen.pixelheight);
    //    }
}
-(void)doButtonClicked:(UIView *)sender
{
    switch (sender.tag) {
        case 101 :  //filter
            isSelectFilter=YES;
            [self.navigationController pushViewController:filterListVC animated:YES];
            break;
        case  102:  //btnStart;
            if(drawPad.isRecording==NO){
                dstPath=[SDKFileUtil genTmpMp4Path];  //这里创建一个路径.
                [drawPad startRecordWithPath:dstPath];
            }
            [label startAnimation];
            break;
        case  103:  //btnOK;
            if(drawPad.isRecording){
                [drawPad stopRecord];
                [drawPad stopPreview];  //停止预览
                
                EditFileBox *box=[[EditFileBox alloc] initWithPath:dstPath];
                [AppDelegate getInstance].currentEditBox=box;
                [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
            }
            break;
        case  104:
            if(cameraPen!=nil){
                [cameraPen rotateCamera];
            }
            break;
        case 201:  //美颜
            if(beautyMng.isBeauting){
                [beautyMng deleteBeauty:cameraPen];
            }else{
                [beautyMng addBeauty:cameraPen];
            }
            segmentSpeed.enabled= !segmentSpeed.enabled;
            break;
        case 301:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
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
    if(drawPad!=nil){
        [drawPad startPreview];
        [beautyMng addBeauty:cameraPen];
    }
    isSelectFilter=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc
{
    cameraPen=nil;
    
    if(drawPad!=nil){
        [drawPad stopPreview];
        drawPad=nil;
    }
    filterListVC=nil;
    filterView=nil;
    dstPath=nil;
    NSLog(@"CameraPenDemoVC  dealloc");
}
/**
 滑动 效果调节后的相应
 
 */
- (void)slideChanged:(UISlider*)sender
{
     //float value=[sender value];
    switch (sender.tag) {
        case 101:
            //            [beautyMng setWarmCoolEffect:value];  //对美颜的调节;
            [filterListVC updateFilterFromSlider:sender];
            break;
        default:
            break;
    }
}
-(void)initView
{
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    CGFloat  layHeight=self.view.frame.size.height*3/4;
    
    _labProgress=[[UILabel alloc] init];
    _labProgress.textColor=[UIColor redColor];
    
    [self.view addSubview:_labProgress];
    
    //显示进度;
    [_labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(layHeight);
        make.centerX.mas_equalTo(filterView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
    //滑动按钮
    filterSlider=[self createSlide:_labProgress min:0.0f max:1.0f value:0.5f tag:101 labText:@"效果调节 "];
    
    
    
    
    //点击按钮;
    UIButton *btnFilter=[[UIButton alloc] init];
    [btnFilter setTitle:@"滤镜" forState:UIControlStateNormal];
    [btnFilter setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnFilter.titleLabel.font=[UIFont systemFontOfSize:25];
    btnFilter.tag=101;
    
    
    UIButton *btnStart=[[UIButton alloc] init];
    [btnStart setTitle:@"开始" forState:UIControlStateNormal];
    [btnStart setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnStart.titleLabel.font=[UIFont systemFontOfSize:25];
    btnStart.tag=102;
    
    UIButton *btnOK=[[UIButton alloc] init];
    [btnOK setTitle:@"停止" forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    btnOK.titleLabel.font=[UIFont systemFontOfSize:25];
    btnOK.tag=103;
    
    UIButton *btnSelect=[[UIButton alloc] init];
    [btnSelect setTitle:@"前置" forState:UIControlStateNormal];
    [btnSelect setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnSelect.titleLabel.font=[UIFont systemFontOfSize:25];
    btnSelect.tag=104;
    
    
    
    UIButton *btnBeauty=[[UIButton alloc] init];
    [btnBeauty setTitle:@"美颜" forState:UIControlStateNormal];
    [btnBeauty setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btnBeauty.titleLabel.font=[UIFont systemFontOfSize:25];
    btnBeauty.tag=201;
    
    
    UIButton *btnClose=[[UIButton alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
    [btnClose setTitle:@"关闭" forState:UIControlStateNormal];
    [btnClose setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnClose.titleLabel.font=[UIFont systemFontOfSize:20];
    btnClose.tag=301;
    [btnClose addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];
    
    
    
    
    [btnStart addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnOK addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnFilter addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnSelect addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnBeauty addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:btnFilter];
    [self.view addSubview:btnStart];
    [self.view addSubview:btnOK];
    [self.view addSubview:btnSelect];
    
    [self.view addSubview:btnBeauty];
    
    CGFloat btnWH=60;
    [btnStart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(filterSlider.mas_bottom).offset(padding);
        make.left.mas_equalTo(filterView.mas_left).offset(padding);
        make.size.mas_equalTo(CGSizeMake(btnWH, btnWH));
    }];
    [btnOK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(filterSlider.mas_bottom).offset(padding);
        make.left.mas_equalTo(btnStart.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(btnWH, btnWH));
    }];
    
    [btnFilter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(filterSlider.mas_bottom).offset(padding);
        make.left.mas_equalTo(btnOK.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(btnWH, btnWH));
    }];
    
    [btnSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(filterSlider.mas_bottom).offset(padding);
        make.left.mas_equalTo(btnFilter.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(btnWH, btnWH));
    }];
    
    
    [btnBeauty mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-btnWH);
        make.centerX.mas_equalTo(self.view.mas_right).offset(-btnWH);
        make.size.mas_equalTo(CGSizeMake(btnWH, btnWH));
    }];
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

