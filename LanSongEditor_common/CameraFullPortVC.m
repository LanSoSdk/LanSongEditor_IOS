//
//  CameraFullPortVC.m
//  LanSongEditor_all
//
//  Created by sno on 2018/6/6.
//  Copyright © 2018年 sno. All rights reserved.
//

#import "CameraFullPortVC.h"

#import "FilterTpyeList.h"
#import "BeautyManager.h"

@interface CameraFullPortVC ()
{
    FilterTpyeList *filterListVC;
    BOOL  isSelectFilter;
    
    UISegmentedControl *segmentSpeed;
    UISlider *filterSlider;
    BitmapPen *bmpPen;
    
    BOOL isPaused;
    CGFloat padWidth;
    CGFloat padHeight;
    
    LanSongView2  *lansongView;
    DrawPadCameraPreview *drawPadCamera;
    
    BeautyManager *beautyMng;
    float beautyLevel;
}
@end

@implementation CameraFullPortVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    [LanSongUtils setViewControllerPortrait];
    
    beautyLevel=0;
    beautyMng=[[BeautyManager alloc] init];
    
    
    lansongView = [[LanSongView2 alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:lansongView];
    
    drawPadCamera=[[DrawPadCameraPreview alloc] initFullScreen:lansongView isFrontCamera:YES];
    
    
    drawPadCamera.cameraPen.horizontallyMirrorFrontFacingCamera=YES;
    
    //增加图片图层
    UIImage *image=[UIImage imageNamed:@"small"];
    BitmapPen *bmpPen=    [drawPadCamera addBitmapPen:image];
    bmpPen.positionX=bmpPen.drawPadSize.width-bmpPen.penSize.width/2;
    bmpPen.positionY=bmpPen.penSize.height/2;
    
    
    /*
     再增加UI图层;
     先创建一个和lansongview一样的UIView,背景设置为透明,然后在这个view中增加其他view
     */
    UIView *view=[[UIView alloc] initWithFrame:lansongView.frame];
    view.backgroundColor=[UIColor clearColor];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 80)];
    label.text=@"UI图层演示";
    label.textColor=[UIColor redColor];
    label.font = [UIFont systemFontOfSize:28.0f];
    [view addSubview:label];
    [drawPadCamera addViewPen:view isFromUI:NO];
    
    
    //增加mv图层
    NSURL *colorPath = [[NSBundle mainBundle] URLForResource:@"mei" withExtension:@"mp4"];
    NSURL *maskPath = [[NSBundle mainBundle] URLForResource:@"mei_b" withExtension:@"mp4"];
    [drawPadCamera addMVPen:colorPath withMask:maskPath];
    
    //开始预览
    [drawPadCamera startPreview];
    [beautyMng addBeauty:drawPadCamera.cameraPen];
    
//    LSLog(@"scale %f x %f",drawPadCamera.cameraPen.scaleWidth, drawPadCamera.cameraPen.scaleHeight);
    
    drawPadCamera.cameraPen.scaleWidth *=0.75;  //LSTODO
    drawPadCamera.cameraPen.scaleHeight *=0.75; //LSTODO
    
    
//    SubPen *pen=[drawPadCamera.cameraPen addSubPen];
//    pen.scaleWidth=0.5f;
//    pen.scaleHeight=0.5;
//
//    pen.positionX=pen.scaleWidthValue/2;
//    pen.positionY=pen.scaleHeightValue/2;
//    LSLog(@"pen x%f, y:%f",pen.positionX,pen.positionY);
    
    
    
    //初始化其他UI界面.
    [self initView];
    
    filterListVC=[[FilterTpyeList alloc] initWithNibName:nil bundle:nil];
    filterListVC.filterSlider=filterSlider;
    filterListVC.filterPen=drawPadCamera.cameraPen;
}
-(void)progressBlock:(CGFloat)currentPts
{
    dispatch_async(dispatch_get_main_queue(), ^{
          _labProgress.text=[NSString stringWithFormat:@"当前进度 %f",currentPts];
    });
}
-(void)doButtonClicked:(UIView *)sender
{
     __weak typeof(self) weakSelf = self;
        switch (sender.tag) {
            case 101 :  //filter
                isSelectFilter=YES;
                [self.navigationController pushViewController:filterListVC animated:YES];
                break;
            case  102:  //btnStart;
                if(drawPadCamera.isRecording==NO){
                    [drawPadCamera startRecord];
                    [drawPadCamera setProgressBlock:^(CGFloat progess) {
                        [weakSelf progressBlock:progess];
                    }];
                }else{
                    LSLog(@" is recording....");
                }
                break;
            case  103:  //btnOK;
                if(drawPadCamera.isRecording){
                    //停止,开始播放;
                    [drawPadCamera stopRecord:^(NSString *path) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:path];
                        });
                    }];
                }
                break;
            case  104:
                if(drawPadCamera!=nil){
                    [drawPadCamera.cameraPen rotateCamera];
                }
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
    if(drawPadCamera!=nil){
        [drawPadCamera startPreview];
    }
    isSelectFilter=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc
{
    if(drawPadCamera!=nil){
        [drawPadCamera stopPreview];
        drawPadCamera=nil;
    }
    filterListVC=nil;
    lansongView=nil;
    LSLog(@"CameraPenDemoVC  dealloc");
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
        make.centerX.mas_equalTo(lansongView.mas_centerX);
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
    [btnBeauty setTitle:@"美颜+/-" forState:UIControlStateNormal];
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
        make.left.mas_equalTo(lansongView.mas_left).offset(padding);
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
        make.size.mas_equalTo(CGSizeMake(btnWH*2, btnWH));
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

