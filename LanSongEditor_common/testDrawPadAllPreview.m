//
//  testDrawPadAllPreview.m
//  LanSongEditor_all
//
//  Created by sno on 2019/10/22.
//  Copyright © 2019 sno. All rights reserved.
//

#import "testDrawPadAllPreview.h"
#import "DemoUtils.h"

#import "DemoProgressHUD.h"

@interface testDrawPadAllPreview ()
{
    DrawPadAllPreview *allPreview;
    DrawPadAllExecute *allExecute;
    
    LanSongView2 *lansongView;
    LSOBitmapPen *bmpPen;
    CGSize drawpadSize;
    
    UILabel *labProgress;
    
    //-------Ae中的素材
    
    
    DemoProgressHUD *hud;
    
    //-----------各种素材
    LSOVideoAsset *asset1;
    LSOVideoAsset *asset2;
    LSOVideoAsset *asset3;
    
    LSOMaskAnimation *maskAnimation1;
    LSOMaskAnimation *maskAnimation2;
    
    UISlider *progressSlider;
}
@end


@implementation testDrawPadAllPreview

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self prepareAsset];
    
    
    hud=[[DemoProgressHUD alloc] init];
    
    [self startAllPreview];
    
    [self createSlide:lansongView min:0.0f max:1.0f value:0.5f tag:101 labText:@"容器seek"];
    
    UIView *view=[self newButton:progressSlider index:201 hint:@"替换图片"];
    view=[self newButton:view index:202 hint:@"后台处理(导出)"];
    
    //显示进度;
    labProgress=[[UILabel alloc] init];
    labProgress.textColor=[UIColor redColor];
    [self.view addSubview:labProgress];
    
    CGSize size=self.view.frame.size;
    [labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom);
        make.left.mas_equalTo(view.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self stopAllExecute];
    [self stopAllPreview];
    
    asset1=nil;
    asset2=nil;
    asset3=nil;
    
    
}

/// 准备各种素材资源;
-(void)prepareAsset
{
    // asset1=[LSOVideoAsset assetWithURL:[LSOFileUtil filePathToURL:LSOBundlePath(@"dy_xialu2.mp4")]];
    
    asset1=[LSOVideoAsset assetWithURL:[LSOFileUtil filePathToURL:LSOBundlePath(@"IMG_1652.MOV")]];
    asset2=[LSOVideoAsset assetWithURL:[LSOFileUtil filePathToURL:LSOBundlePath(@"IMG_1646_iphoneXR.MOV")]];
    asset3=[LSOVideoAsset assetWithURL:[LSOFileUtil filePathToURL:LSOBundlePath(@"iphone180du.MOV")]];
    
    maskAnimation1=[LSOAeAnimation animationWithAEJson:LSOBundlePath(@"mask_animation_xing_out.json") durationS:1.0f];
    maskAnimation2=[LSOAeAnimation animationWithAEJson:LSOBundlePath(@"mask_animation_cycle_out.json") durationS:1.0f];
}

-(void)startAllPreview
{
    if(allPreview.isRunning){
        return;
    }
    [self stopAllPreview];
    [self stopAllExecute];
    
    //----------------------start------------------------
    allPreview=[[DrawPadAllPreview alloc] initWithDrawPadSize:CGSizeMake(540, 960) durationS:11];
    
    
    
    LSOVideoOption *option1=[[LSOVideoOption alloc] init];
    option1.cutStartS=5;
    option1.cutEndS=11;
    
    LSOVideoFramePen2 *frame1=[allPreview concatVideoFramePen2:asset1 option:option1];
  
    //有问题;
    [frame1 addAeAnimationAtTimeS:maskAnimation1 atTimeS:9];
    
    
   
    LSOVideoOption *option2=[[LSOVideoOption alloc] init];
    option2.cutStartS=3;
    option2.cutEndS=8;
    option2.audioVolume=1;
    option2.overLapTimeS=0;

    [allPreview concatVideoFramePen2:asset3 option:option2];
    
    //    //容器大小,在增加图层后获取;
    drawpadSize=allPreview.drawpadSize;
    if(lansongView==nil){
        lansongView=[DemoUtils createLanSongView:self.view.frame.size drawpadSize:drawpadSize];
        [self.view addSubview:lansongView];
    }
    
    allPreview.backgroundColor=[UIColor yellowColor];
    
    [allPreview addLanSongView:lansongView];
    [allPreview setLoopPreview:YES];
    
    
    //    //增加回调
    __weak typeof(self) weakSelf = self;
    [allPreview setProgressBlock:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadProgress:progress];
        });
    }];
    //
    //    //开始执行,
    //
    [hud showProgress:[NSString stringWithFormat:@"请稍等..."]];
    [allPreview prepareDrawPad:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];
            [allPreview start];
        });
    }];
}
/**
 后台执行
 */
-(void)startAllExecute
{
    
    [self stopAllExecute];
    [self stopAllPreview];
    //1.创建对象;
    allExecute=[[DrawPadAllExecute alloc] initWithDrawPadSize:CGSizeMake(540, 960) durationS:(asset1.duration+10)];
    
    
    LSOVideoOption *option1=[[LSOVideoOption alloc] init];
    option1.audioVolume=0;
    LSOVideoFramePen2 *frame1=[allExecute concatVideoFramePen2:asset1 option:option1];
   
    
    LSOVideoOption *option2=[[LSOVideoOption alloc] init];
    option2.audioVolume=0;
    [allExecute concatVideoFramePen2:asset2 option:option2];
    
    //4.设置回调
    WS(weakSelf)
    [allExecute setProgressBlock:^(CGFloat progess) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadProgress:progess];
        });
    }];
    
    [allExecute setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadCompleted:dstPath];
        });
    }];
    
    //5.开始执行
    [allExecute start];
}

-(void)addBitmapPenPreview:(NSString *)path startS:(CGFloat)startS endS:(CGFloat)endS
{
    LSOBitmapAsset *asset1=[[LSOBitmapAsset alloc] initWithPath:path];
    [allPreview addBitmapPen:asset1 startPadTime:startS endPadTime:endS];
}


-(void)addBitmapPen:(NSString *)path startS:(CGFloat)startS endS:(CGFloat)endS
{
    LSOBitmapAsset *asset1=[[LSOBitmapAsset alloc] initWithPath:path];
    [allExecute addBitmapPen:asset1 startPadTime:startS endPadTime:endS];
}
-(void)stopAllPreview
{
    if (allPreview!=nil) {
        [allPreview cancel];
        allPreview=nil;
    }
}
-(void)stopAllExecute
{
    [hud hide];
    if (allExecute!=nil) {
        [allExecute cancel];
        allExecute=nil;
    }
}

-(void)drawpadProgress:(CGFloat) progress
{
    if(allPreview!=nil){
        int percent=(int)(progress*100/allPreview.durationS);
        labProgress.text=[NSString stringWithFormat:@"当前进度 %f,百分比是:%d",progress,percent];
        progressSlider.value=progress/allPreview.durationS;
    }else if(allExecute!=nil){
        int percent=(int)(progress*100/allExecute.durationS);
        [hud showProgress:[NSString stringWithFormat:@"进度:%d",percent]];
    }
}

-(void)drawpadCompleted:(NSString *)path
{
    allExecute=nil;
    VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
    vce.videoPath=path;
    [hud hide];
    [self.navigationController pushViewController:vce animated:NO];
}

-(UIButton *)newButton:(UIView *)topView index:(int)index hint:(NSString *)hint
{
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=index;
    
    [btn setTitle:hint forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor whiteColor];
    
    [btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.04;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 50));  //按钮的高度.
    }];
    
    return btn;
}
-(void)onClicked:(UIView *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    UIViewController *pushVC=nil;
    
    switch (sender.tag) {
        case 201:  //替换图片
            break;
        case 202:  //后台处理
            [self startAllExecute];
            break;
        default:
            break;
    }
    
    if (pushVC!=nil) {
        [self.navigationController pushViewController:pushVC animated:NO];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//--------------slide
- (void)slideChanged:(UISlider*)sender
{
    switch (sender.tag) {
        case 101:
        {
            CGFloat timeS=sender.value * allPreview.durationS;
            [allPreview seekPauseTo:timeS];
            
        }
            break;
        default:
            break;
    }
}
- (void)slideTouchUp:(UISlider*)sender
{
    //float value=[sender value];
    switch (sender.tag) {
        case 101:
        {
            [allPreview resumePreview];
        }
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
    labPos.textColor=[UIColor redColor];
    
    progressSlider=[[UISlider alloc] init];
    
    progressSlider.maximumValue=max;
    progressSlider.minimumValue=min;
    progressSlider.value=value;
    progressSlider.continuous = YES;
    progressSlider.tag=tag;
    
    [progressSlider addTarget:self action:@selector(slideChanged:) forControlEvents:UIControlEventValueChanged];
    [progressSlider addTarget:self action:@selector(slideTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [progressSlider addTarget:self action:@selector(slideTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    [self.view addSubview:labPos];
    [self.view addSubview:progressSlider];
    
    
    [labPos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(padding);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(labPos.mas_centerY);
        make.left.mas_equalTo(labPos.mas_right).offset(padding);
        make.right.mas_equalTo(self.view.mas_right).offset(-padding);
    }];
    return progressSlider;
}



-(void)dealloc
{
    [self stopAllExecute];
    [self stopAllPreview];
    
    NSLog(@"testDrawPadAllPreview  dealloc...");
}
@end



