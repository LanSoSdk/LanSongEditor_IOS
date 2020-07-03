//
//  VideoEditorDemoVC.m
//
//
//  Created by sno on 2020/3/22.
//  Copyright © 2020 sno. All rights reserved.
//

#import "VideoEditorDemoVC.h"
#import "DemoUtils.h"

#import "DemoProgressHUD.h"

@interface VideoEditorDemoVC ()
{
    LSOConcatComposition *concatComposition;
    
    LSODisplayView *displayView;
    CGSize compSize;
    
    UILabel *labProgress;
    
    //-------Ae中的素材
    
    DemoProgressHUD *hud;
    
    //-----------各种素材
    
    UISlider *progressSlider;
    
    UISlider *testSlider;
    LSOLayer *concatLayer1;
    LSOLayer *concatLayer2;
    LSOLayer *concatLayer3;
    LSOLayer *concatLayer4;
    
    LSOLayer *imageConcatLayer;
    
    //叠加层;
    LSOLayer *videoLayer;
    LSOAudioLayer *audioLayer;
    LSOLayer *imageLayer;
    LSOLayer *imageArrayLayer;
    LSOLayer *gifLayer;
    LSOLayer *insertLayer;
    
    LSOLayer *imageLayer1;
    
    //测试动画
    LSOAnimation *inputAnimation;
    
    LSOAnimation *outputAnimation;
    LSOAnimation *animation3;
    
    //测试特效;
    LSOEffect *effect1;
    LSOEffect *effect2;
    LSOEffect *effect3;
    
    //-------------------------
    CGFloat testAngle;
    
    NSMutableArray *imageArray;
    LSOAudioRecorder *audioRecord;
    
}
@property (nonatomic, assign) CGPoint ori_center;
@property (nonatomic, assign) CGFloat curScale;
@end


@implementation VideoEditorDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    
    
    hud=[[DemoProgressHUD alloc] init];
    
    //设置容器大小
    compSize=CGSizeMake(720, 1280);
    
    //增加显示窗口
    displayView=[DemoUtils createLSOCompositionView:self.view.frame.size drawpadSize:compSize];
    [self.view addSubview:displayView];
    
    progressSlider=[self createSlide:displayView min:0.0f max:1.0f value:0.5f tag:101 labText:@"容器seek"];
    
    UIView *view=[self newButton:progressSlider leftView:self.view index:202 hint:@"暂停"];
    view=[self newButton:progressSlider leftView:view index:203 hint:@"继续"];
    view=[self newButton:progressSlider leftView:view index:204 hint:@"增删贴纸"];
    
    view= [self newButton:view leftView:self.view index:302 hint:@"后台处理(导出)"];
    
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
    
    
    UILabel *hint=[[UILabel alloc] init];
    hint.text=@"每个图层可:单指拖动,双指缩放和旋转";
    hint.textColor=[UIColor redColor];
    [self.view addSubview:hint];
    
    [hint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labProgress.mas_bottom);
        make.left.mas_equalTo(labProgress.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
}


#pragma mark- 前后台事件处理

- (void)applicationDidEnterBackground:(NSNotification *)info {
    LSDELETE(@"-----applicationDidEnterBackground>>>>>> 进入后台....")
    [concatComposition applicationDidEnterBackground];
}

- (void)applicationDidBecomeActive:(NSNotification *)info {
    LSDELETE(@"--applicationDidBecomeActive....");
    [concatComposition applicationDidBecomeActive];
    LSDELETE(@"-----applicationDidBecomeActive>>>>>>")
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserver];
    [self startConcatComposition];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self removeObserver];
    [super viewDidDisappear:animated];
    LSDELETE(@"---view did disappear....")
}

- (void)addObserver {
    
    [self removeObserver];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    /*！
     这里不监听 UIApplicationWillEnterForegroundNotification 的原因是 app 返回前台的时候，
     UIApplicationWillEnterForegroundNotification 不一定有回调
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}
-(void)startConcatComposition
{
    if(concatComposition.isRunning){
        return;
    }
    
    //----------------------start------------------------
    concatComposition=[[LSOConcatComposition alloc] initWithCompositionSize:compSize];
    
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [array addObject:LSOBundleURL(@"dy_xialu2.mp4")];
    
    //异步的形式增加视频
    WS(weakSelf)
    [concatComposition addConcatLayerWithArray:array completedHandler:^(NSArray * _Nonnull layerAray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            concatLayer1=[layerAray objectAtIndex:0];
            [weakSelf addOtherLayer];
        });
    }];
    
}

- (void)addOtherLayer
{
    
    [concatComposition setCompositionView:displayView];
    //增加回调
    __weak typeof(self) weakSelf = self;
    
    [concatComposition setPlayProgressBlock:^(CGFloat progress, CGFloat percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf playProgressBlock:progress percent:percent];
        });
    }];
    
    [concatComposition setUserSelectedLayerBlock:^(LSOLayer * _Nonnull layer) {
        
    }];
    
    [concatComposition setPlayCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf playCompletedBlock];
        });
    }];
    
    [concatComposition setExportProgressBlock:^(CGFloat progress, CGFloat percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf exportProgressBlock:progress percent:percent];
        });
    }];
    
    [concatComposition setExportCompletionBlock:^(NSString * _Nonnull dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadCompleted: dstPath];
        });
    }];
    [concatComposition setCompositionDurationChangedBlock:^(CGFloat durationS) {
        LSDELETE(@"---总合成回调block: %f", durationS);
    }];
    
    [concatComposition startPreview];
}
- (void)stopConcatComposition
{
    if (concatComposition!=nil) {
        [concatComposition cancel];
        concatComposition=nil;
    }
}
-(void)playProgressBlock:(CGFloat) progress percent:(CGFloat)percent
{
    labProgress.text=[NSString stringWithFormat:@"当前进度 %f,百分比是:%f",progress,percent];
    progressSlider.value=progress/concatComposition.compDurationS;
}
-(void)playCompletedBlock
{
    [DemoUtils showDialog:@"播放完毕"];
}

-(void)exportProgressBlock:(CGFloat) progress percent:(CGFloat)percent
{
    NSString *str=[NSString stringWithFormat:@"当前进度 %f,百分比是:%f",progress,percent];;
    labProgress.text=str;
    progressSlider.value=progress/concatComposition.compDurationS;
    [hud showProgress:str];
}

-(void)drawpadCompleted:(NSString *)path
{
    VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
    vce.videoPath=path;
    [hud hide];
    [self.navigationController pushViewController:vce animated:NO];
}
-(UIButton *)newButton:(UIView *)topView leftView :(UIView *)leftView index:(int)index hint:(NSString *)hint
{
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=index;
    
    [btn setTitle:hint forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor whiteColor];
    
    [btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(onClickedDown:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:btn];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).with.offset(padding);
        if(leftView==self.view){
            make.left.mas_equalTo(leftView.mas_left).offset(padding);
        }else{
            make.left.mas_equalTo(leftView.mas_right).offset(10);
        }
        if(index==302){
            make.size.mas_equalTo(CGSizeMake(size.width, 50));
        }else{
            make.size.mas_equalTo(CGSizeMake(80, 40));  //按钮的高度.
        }
    }];
    
    return btn;
}


-(void)videoReverseProgress:(CGFloat)percent finish:(BOOL)finish
{
    if(!finish){
        NSString *str=[NSString stringWithFormat:@"正在倒序处理. 百分比是:%f",percent];;
        labProgress.text=str;
        [hud showProgress:str];
    }else{
        [hud hide];
        if(concatLayer1.isReverse){
            [DemoUtils showHUDToast:@"已倒序完毕,已是倒序状态"];
        }else{
            [DemoUtils showHUDToast:@"已是正常播放状态"];
        }
    }
}
-(void)onClickedDown:(UIView *)sender
{
}
-(void)onClicked:(UIView *)sender
{
    switch (sender.tag) {
        case 202:  //暂停
        {
            [concatComposition pause];
        }
            break;
        case 203:  //继续
            [concatComposition resume];
            break;
        case 204:
            if(imageLayer){
                [concatComposition removeLayer:imageLayer];
                imageLayer=nil;
            }else{
                UIImage *image=[UIImage imageNamed:@"necklace_019"];
                
                //增加图片,得到图层;
                imageLayer= [concatComposition addImageLayerWithImage:image atTime:0];
                imageLayer.looping=YES;
            }
            break;
        case 302:  //后台处理
            LSDELETE(@"------------> 开始后台导出------------------------>")
            [concatComposition startExport];
            break;
        default:
            break;
    }
}
- (void)setButtonName:(UIView *)view name:(NSString *)name
{
    UIButton *btn=(UIButton *)view;
    [btn setTitle:name forState:UIControlStateNormal];
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
            CGFloat timeS=sender.value * concatComposition.compDurationS;
            [concatComposition seekToTimeS:timeS];
        }
            break;
        default:
            break;
    }
}
- (void)slideTouchUp:(UISlider*)sender
{
    switch (sender.tag) {
        case 101:
        {
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
    
    UISlider *slider=[[UISlider alloc] init];
    
    slider.maximumValue=max;
    slider.minimumValue=min;
    slider.value=value;
    slider.continuous = YES;
    slider.tag=tag;
    
    [slider addTarget:self action:@selector(slideChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(slideTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(slideTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    [self.view addSubview:labPos];
    [self.view addSubview:slider];
    
    [labPos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).offset(padding);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(labPos.mas_centerY);
        make.left.mas_equalTo(labPos.mas_right).offset(padding);
        make.right.mas_equalTo(self.view.mas_right).offset(-padding);
    }];
    return slider;
}

-(void)dealloc
{
    [self stopConcatComposition];
    LSOLog_d(@"VideoEditorDemoVC  dealloc...");
}
@end



