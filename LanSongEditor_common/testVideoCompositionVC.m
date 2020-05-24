//
//  testVideoCompositionVC.m
//  LanSongEditor_all
//
//  Created by sno on 2020/3/22.
//  Copyright © 2020 sno. All rights reserved.
//

#import "testVideoCompositionVC.h"
#import "DemoUtils.h"

#import "DemoProgressHUD.h"
//LSDELETE暂时不清楚为什么;
//  _videoComposition = [[LSOVideoComposition alloc] initWithCompositionSize:self.compositionView.bounds.size];


@interface testVideoCompositionVC ()
{
    LSOVideoComposition *videoComposition;
    
    LSOCompositionView *compositionView;
    LSOBitmapPen *bmpPen;
    CGSize compSize;
    
    UILabel *labProgress;
    
    //-------Ae中的素材
    
    DemoProgressHUD *hud;
    
    //-----------各种素材
    LSOMaskAnimation *maskAnimation1;
    LSOMaskAnimation *maskAnimation2;
    
    UISlider *progressSlider;
    
    UISlider *testSlider;
    LSOConcatLayer *concatLayer2;
    LSOConcatLayer *imageConcatLayer;
    
    //叠加层;
    LSOVideoLayer *videoLayer;
    LSOAudioLayer *audioLayer;
    LSOImageLayer *imageLayer;
    LSOMVLayer *mvLayer;
    LSOImageArrayLayer *imageArrayLayer;
    LSOGifLayer *gifLayer;
    LSOConcatLayer *insertLayer;
    
    
    NSMutableArray *imageArray;
    int bgIndex;  //lsdelete测试;
    
}
@end


@implementation testVideoCompositionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    
    hud=[[DemoProgressHUD alloc] init];
    
    compSize=CGSizeMake(720, 1280);
    
    compositionView=[DemoUtils createLSOCompositionView:self.view.frame.size drawpadSize:compSize];
    [self.view addSubview:compositionView];
    
    
    progressSlider=[self createSlide:compositionView min:0.0f max:1.0f value:0.5f tag:101 labText:@"容器seek"];
    
    UIView *view=[self newButton:progressSlider leftView:self.view index:201 hint:@"插入声音"];
    view=[self newButton:progressSlider leftView:view index:202 hint:@"暂停"];
    view=[self newButton:progressSlider leftView:view index:203 hint:@"继续"];
     UIView *topView=[self newButton:progressSlider leftView:view index:204 hint:@"分割"];
    
    view=[self newButton:topView leftView:self.view index:206 hint:@"声音增删"];
    view=[self newButton:topView leftView:view index:207 hint:@"图片增删"];
    view=[self newButton:topView leftView:view index:208 hint:@"mv增删"];
    view=[self newButton:topView leftView:view index:209 hint:@"gif增删"];
    
    topView=view;
    view=[self newButton:topView leftView:self.view index:210 hint:@"叠加视频"];
    view=[self newButton:topView leftView:view index:211 hint:@"序图增删"];
    view=[self newButton:topView leftView:view index:212 hint:@"美颜"];
    view=[self newButton:topView leftView:view index:213 hint:@"滤镜"];
    
     topView=view;
     view=[self newButton:topView leftView:self.view index:214 hint:@"替换视频"];
    
    
    view= [self newButton:view leftView:self.view index:302 hint:@"后台处理(导出)"];
    testSlider= [self createSlide:view min:0.0f max:8.0f value:0.5f tag:102 labText:@"测试"];
    
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
    bgIndex=0;
}
#pragma mark- 前后台事件处理

- (void)applicationDidEnterBackground:(NSNotification *)info {
    LSDELETE(@"-----applicationDidEnterBackground>>>>>> 进入后台....")
    [videoComposition applicationDidEnterBackground];
}

- (void)applicationDidBecomeActive:(NSNotification *)info {
    LSDELETE(@"--applicationDidBecomeActive....");
    [videoComposition applicationDidBecomeActive];
    LSDELETE(@"-----applicationDidBecomeActive>>>>>>")
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserver];
    [self startVideoComposition];
    LSDELETE(@"--viewWillAppear....")
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
-(void)startVideoComposition
{
    if(videoComposition.isRunning){
        return;
    }
    
    //----------------------start------------------------
    videoComposition=[[LSOVideoComposition alloc] initWithCompositionSize:compSize];
    
    
    NSMutableArray *array=[[NSMutableArray alloc] init];
    //    [array addObject:LSOBundleURL(@"iphone180du.MOV")];
    //    [array addObject:LSOBundleURL(@"IMG_1652.MOV")];
    //        [array addObject:LSOBundleURL(@"kuaishou_H31.mp4")];
    
    [array addObject:LSOBundleURL(@"dy_xialu2.mp4")];
    
    
        [array addObject:LSOBundleURL(@"1-1.mp4")];
//        [array addObject:LSOBundleURL(@"p580x389.jpg")];
//        [array addObject:LSOBundleURL(@"img_0.png")];
    //    [array addObject:IMAGE2_URL];
        [array addObject:LSOBundleURL(@"2-1.mp4")];
        [array addObject:LSOBundleURL(@"3-1.mp4")];
    
    //异步的形式增加视频
    WS(weakSelf)
    [videoComposition addConcatLayerWithArray:array completedHandler:^(NSArray * _Nonnull layerAray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            concatLayer2=[layerAray objectAtIndex:0];
            
//            for (LSOLayer *layer in layerAray) {
//                ((LSOConcatLayer *)layer).scaleFactor=0.5f;
//            }
            [weakSelf addOtherLayer];
        });
    }];
}
- (void)addOtherLayer
{
    ///--------------------------------测试各个叠加层--------------------------------
    
    //    LSOImageLayer  *imageLaye=[[LSOImageLayer alloc] initWithImage:[UIImage imageNamed:@"gaussianBlur_img_0"]];
    UIImage *image=[UIImage imageNamed:@"gaussianBlur_img_0"];
    [videoComposition setBackGroundImageLayerWithImage:image];
    
    
    //    UIImage *image=[UIImage imageWithContentsOfFile:IMAGE1_PATH];
    //    imageConcatLayer=[videoComposition addConcatLayerWithUIImage:image];
    //    [imageConcatLayer setLayerDurationS:10.0f];
    
    
    LSOImageLayer *layer=[videoComposition addImageLayerWithImage:[UIImage imageNamed:@"small"] atTime:5.0];
    layer.positionType=kLSOPositionLeftTop;
    
    

    [videoComposition setCompositionView:compositionView];
   
    
    //    mvLayer= [videoComposition addMVLayerWithColorURL:LSOBundleURL(@"yelang_mvColor.mp4") maskUrl:LSOBundleURL(@"yelang_mvMask.mp4") atTime:0];
    //    mvLayer.layerDurationS=20.0f;
    
    //audioLayer= [videoComposition addAudioLayerWithURL:LSOBundleURL(@"hongdou10s.mp3") atTime:0];
    //audioLayer.looping=YES;
    
    
    //    LSDELETE(@"---开始增加 转场---->  ")
    //    LSOTransition *transition=[[LSOTransition alloc] initWithMaskJsonURL:LSOBundleURL(@"mask_animation_cycle_out.json") duration:1.0f];
    //    [videoComposition setTransitionAtIndex:transition nodeIndex:0];
    //    transition.lsoTag=@"T1";
    //
    //    LSOTransition *transition2=[[LSOTransition alloc] initWithMaskJsonURL:LSOBundleURL(@"mask_animation_cycle_out.json") duration:1.0f];
    //    [videoComposition setTransitionAtIndex:transition2 nodeIndex:0];
    //    transition2.lsoTag=@"T2";
    
    //打印各种图层信息;
    [videoComposition printCurrentLayerInfo];
    
    
    //    测试声音, 测试图片,测试mv,测试gif, 测试多图片;
    //    2. 调试变速;
    
    //增加回调
    __weak typeof(self) weakSelf = self;
    [videoComposition setProgressBlock:^(CGFloat progress, CGFloat percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf playProgressBlock:progress];
        });
    }];
    [videoComposition setExportProgressBlock:^(CGFloat progress, CGFloat percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf exportProgressBlock:progress];
        });
    }];

    [videoComposition setCompletionBlock:^(NSString * _Nonnull dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadCompleted: dstPath];
        });
    }];
    [videoComposition startPreview];
}
- (void)stopVideoComposition
{
    if (videoComposition!=nil) {
        [videoComposition cancel];
        videoComposition=nil;
    }
}
-(void)playProgressBlock:(CGFloat) progress
{
    //    LSDELETE(@"-----播放进度--progress is :%f",progress);
    int percent=(int)(progress*100/videoComposition.durationS);
    labProgress.text=[NSString stringWithFormat:@"当前进度 %f,百分比是:%d",progress,percent];
    progressSlider.value=progress/videoComposition.durationS;
}

-(void)exportProgressBlock:(CGFloat) progress
{
    int percent=(int)(progress*100/videoComposition.durationS);
    NSString *str=[NSString stringWithFormat:@"当前进度 %f,百分比是:%d",progress,percent];;
    labProgress.text=str;
    progressSlider.value=progress/videoComposition.durationS;
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
            make.left.mas_equalTo(leftView.mas_left);
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
-(void)onClickedDown:(UIView *)sender
{
}
-(void)onClicked:(UIView *)sender
{
    switch (sender.tag) {
        case 201:  //插入声音
            
            if(insertLayer==nil){
                NSMutableArray *array=[[NSMutableArray alloc] init];
                //    [array addObject:LSOBundleURL(@"iphone180du.MOV")];
                //    [array addObject:LSOBundleURL(@"IMG_1652.MOV")];
                [array addObject:LSOBundleURL(@"kuaishou_H31.mp4")];
                [videoComposition insertConcatLayerWithArray:array atTime:8.0 completedHandler:^(NSArray * _Nonnull layerArray) {
                    LSDELETE(@"---layer array is :%lu", (unsigned long)layerArray.count);
                    if(layerArray.count>0){
                        insertLayer= [layerArray objectAtIndex:0];
                    }
                }];
            }else{
                [videoComposition removeLayer:insertLayer];
                insertLayer=nil;
            }
            break;
        case 202:  //暂停
            [videoComposition pause];
            break;
        case 203:  //继续
            [videoComposition resume];
            break;
        case 204:  //分割
            LSDELETE(@"分割....")
            //[videoComposition splitConcatLayerByTime:30];
            bgIndex++;
            if(bgIndex==1){
                LSDELETE(@"--切换背景到-----kuaishou_H31-->")
                [videoComposition setBackGroundVideoLayerWithURL:LSOBundleURL(@"kuaishou_H31.mp4") completedHandler:^(LSOVideoLayer * _Nonnull videoLayer) {
                    
                    
                }];
            }else if(bgIndex==2){
                LSDELETE(@"--切换背景到-----IMG_1652-->")
                [videoComposition setBackGroundVideoLayerWithURL:LSOBundleURL(@"IMG_1652.MOV") completedHandler:^(LSOVideoLayer * _Nonnull videoLayer) {
                    
                    
                }];
            }else if(bgIndex ==3){
                LSDELETE(@"--切换背景到-----iphone180du-->")
                [videoComposition setBackGroundVideoLayerWithURL:LSOBundleURL(@"iphone180du.MOV") completedHandler:^(LSOVideoLayer * _Nonnull videoLayer) {
                    
                    
                }];
            }else if(bgIndex==4){
                LSDELETE(@"--切换背景到-----small-->")
                [videoComposition setBackGroundImageLayerWithImage:[UIImage imageNamed:@"small"]];
            }else {
                LSDELETE(@"--切换背景到-----无-->")
                [videoComposition removeBackGroundLayer];
                bgIndex=0;
            }
            
            break;
        case 205:  //裁剪
            LSDELETE(@"裁剪===>...")
            [videoComposition cutTimeFromStartWithLayer:concatLayer2 offsetTime:10];
            break;
            
        case 206:  //声音增删
            if(audioLayer!=nil){
                LSDELETE(@"--------删除一个 audio 图层")
                [videoComposition removeAudioLayer:audioLayer];
                audioLayer=nil;
            }else{
                LSDELETE(@"----增加 audio layer .....")
                audioLayer= [videoComposition addAudioLayerWithURL:LSOBundleURL(@"hongdou10s.mp3") atTime:0];
                audioLayer.cutStartTimeS=1.0f;
                audioLayer.cutEndTimeS=5.0f;
                audioLayer.looping=YES;
                audioLayer.audioVolume=1.0f;
            }
            break;
        case 207:  //图片增删
            if(imageLayer!=nil){
                LSDELETE(@"--------删除一个 imageLayer")
                [videoComposition removeLayer:imageLayer];
                imageLayer=nil;
            }else{
                LSDELETE(@"----增加imageLayer....:%f",videoComposition.currentTimeS)
                imageLayer= [videoComposition addImageLayerWithImage:[UIImage imageNamed:@"small"] atTime:videoComposition.currentTimeS];
                imageLayer.looping=YES;
                imageLayer.lsoTag=@"#1";
            }
            break;
            
        case 208:  //mv增删
            if(mvLayer!=nil){
                [videoComposition removeLayer:mvLayer];
                mvLayer=nil;
            }else {
                mvLayer = [videoComposition addMVLayerWithColorURL:LSOBundleURL(@"yelang_mvColor.mp4") maskUrl:LSOBundleURL(@"yelang_mvMask.mp4") atTime:0];
                mvLayer.layerDurationS=20.0f;
            }
            break;
        case 209:  //gif增删
            if(gifLayer!=nil){
                [videoComposition removeLayer:gifLayer];
                gifLayer=nil;
            }else{
                gifLayer=[videoComposition addGifLayerWithURL:LSOBundleURL(@"gif_g06.gif") atTime:0];
                gifLayer.looping=YES;
                gifLayer.positionType=kLSOPositionTop;
            }
            break;
            //-----------------------------------------------------
        case 210:
            LSDELETE(@"-----增加videolayer.....");
            if(videoLayer!=nil){
                [videoComposition removeLayer:videoLayer];
                videoLayer=nil;
            }else{
                videoLayer=[videoComposition addVideoLayerWithURL:LSOBundleURL(@"dy_xialu2.mp4") atTime:0];
                videoLayer.scaleFactor=0.5f;
                videoLayer.looping=YES;
            }
            break;
        case 211:
            LSDELETE(@"---切换多图图层")
            if(imageArrayLayer!=nil){
                [videoComposition removeLayer:imageArrayLayer];
                imageArrayLayer=nil;
            }else{
                if(imageArray==nil){
                    imageArray=[[NSMutableArray alloc] init];
                    for (int i=0; i<30; i++) {
                        NSString *imageName=[NSString stringWithFormat:@"necklace_%03d.png",i];
                        LSDELETE(@"---image name is :%@",imageName);
                        [imageArray addObject:[UIImage imageWithContentsOfFile:LSOBundlePath(imageName)]];
                    }
                }
                imageArrayLayer=[videoComposition addImageArrayLayerWithArray:imageArray intervalS:0.04 atTime:0];
                imageArrayLayer.looping=YES;
                imageArrayLayer.positionType=kLSOPositionBottom;
            }
            break;
        case 212:
            //                    view=[self newButton:topView leftView:view index:212 hint:@"美颜"];
            //                     view=[self newButton:topView leftView:view index:213 hint:@"滤镜"];
            //            [imageConcatLayer setFilter:[LanSongIFFilter alloc] ini]
        {
            LanSongIF1977Filter *filter=[[LanSongIF1977Filter alloc] init];
            [imageConcatLayer setFilter:filter];
        }
            break;
        case 213:
            break;
        case 302:  //后台处理
            LSDELETE(@"------------> 开始后台导出------------------------>")
            [videoComposition startExport];
            break;
        case 214:
            [videoComposition replaceConcatLayerWithLayer:concatLayer2 replaceUrl:LSOBundleURL(@"IMG_1652.MOV") completedHandler:^(LSOConcatLayer * _Nonnull replacedLayer) {
                //insertLayer= [layerArray objectAtIndex:0];
                LSDELETE(@"----替换 ok :%@",replacedLayer)
            }];
            break;
        default:
            break;
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
            CGFloat timeS=sender.value * videoComposition.durationS;
            [videoComposition seekToTimeS:timeS];
        }
            break;
        case 102:
        {
            //            concatLayer2.scaleFactor=sender.value;
            LSDELETE(@"--setBeautyLevel-sender  is :%f",sender.value);
            //            imageConcatLayer.layerDurationS=sender.value*10;
            
            
            concatLayer2.videoSpeed=sender.value;
            [imageConcatLayer setBeautyLevel:sender.value];
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
            LSDELETE(@"------------抬起");
            //            [videoComposition resume];
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
    [self stopVideoComposition];
    LSOLog_d(@"testVideoCompositionVC  dealloc...");
}
@end




