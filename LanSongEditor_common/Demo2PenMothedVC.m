//
//  Demo2PenMothedVC.m
//  LanSongEditor_all
//
//  Created by sno on 2019/5/10.
//  Copyright © 2019 sno. All rights reserved.
//

#import "Demo2PenMothedVC.h"
#import "DemoUtils.h"
#import "VideoPlayViewController.h"
#import "LSDrawView.h"

@interface Demo2PenMothedVC ()
{
    DrawPadVideoPreview *drawpadPreview;
    
    LanSongView2 *lansongView;
    LSOBitmapPen *bmpPen;
    CGSize drawpadSize;
    LSOVideoPen *videoPen;
    
    UILabel *_labProgress;
    UISlider *videoProgress;
    
    //--------------演示后台执行...
    
    UIButton *btnExecute;
    DrawPadVideoExecute *videoExecute;
    CGFloat visibleSumX;
    CGFloat visibleSumY;
}

@property (nonatomic,assign) NSString *dstPath;
@property (nonatomic) DemoProgressHUD *hud;
@end

@implementation Demo2PenMothedVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"图层基本方法 展示2";
    self.view.backgroundColor=[UIColor blackColor];
    
    
    //-------------以下是ui操作-----------------------
    CGSize size=self.view.frame.size;
    lansongView=[DemoUtils createLanSongView:size drawpadSize:[AppDelegate getInstance].currentEditVideoAsset.videoSize];
    [self.view addSubview:lansongView];
    
    
    CGFloat padding=size.height*0.01;
    
    _labProgress=[[UILabel alloc] init];
    _labProgress.textColor=[UIColor redColor];
    [self.view addSubview:_labProgress];
    
    [_labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lansongView.mas_bottom).offset(padding);
        make.centerX.mas_equalTo(lansongView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
     _hud=[[DemoProgressHUD alloc] init];
    videoProgress=  [self createSlide:_labProgress min:0.0f max:1.0f value:0.5f tag:201 labText:@"播放进度:"];
    UISlider *currentSlide=  [self createSlide:videoProgress min:0.0f max:1.0f value:0.5f tag:101 labText:@"左侧递进"];
    currentSlide= [self createSlide:currentSlide min:0.0f max:1.0f value:0.5f tag:102 labText:@"展开合拢:"];
    currentSlide= [self createSlide:currentSlide min:0.0f max:1.0f value:1.0f tag:103 labText:@"中间四周:"];
    currentSlide=[self createSlide:currentSlide min:0.0f max:1.0f value:0 tag:104 labText:@"圆形展开:"];
    [self addButton:currentSlide];
}
- (void)viewDidAppear:(BOOL)animated
{
    [self startPreview];
}
-(void)startPreview
{
    [self stopPreview];
    
    //创建容器
    NSString *video=[AppDelegate getInstance].currentEditVideoAsset.videoPath;
    drawpadPreview=[[DrawPadVideoPreview alloc] initWithPath:video];
    drawpadSize=drawpadPreview.drawpadSize;
    
    
    //增加显示窗口
    [drawpadPreview addLanSongView:lansongView];
    
    __weak typeof(self) weakSelf = self;
    [drawpadPreview setProgressBlock:^(CGFloat progress) {
        [weakSelf progressBlock:progress];
    }];
    
    videoPen=drawpadPreview.videoPen;
    videoPen.loopPlay=YES;
    
    UIImage *uiimage=[UIImage imageNamed:@"cover1"];
    LSOBitmapPen *bmpPen=[drawpadPreview addBitmapPen:uiimage];   //lSTODO 图片图层有全屏的方法;
    bmpPen.fillScale=YES; //背景图片让它填满整个容器;
    [drawpadPreview setPenPosition:bmpPen index:0];  //放到最底层;
    
    //开始执行,并编码
    [drawpadPreview start];
}
-(void)progressBlock:(CGFloat)progress
{
    if(videoProgress!=nil){
        videoProgress.value=progress/drawpadPreview.duration;
    }
}
-(void)stopPreview
{
    if (drawpadPreview!=nil) {
        [drawpadPreview cancel];
        drawpadPreview=nil;
    }
}
- (void)slideChanged:(UISlider*)sender
{
    if(videoPen==nil){
        return ;
    }
    
    CGFloat val=[(UISlider *)sender value];
    switch (sender.tag) {
        case 201:  //进度
            {
                [videoPen seekToPercent:val];
            }
            break;
        case 101:  //左侧递进
            {
                [videoPen setVisibleRectBorder:0.02f red:1.0f green:0.0f blue:0.0f alpha:1.0f];  //增加一个外边框颜色
                [videoPen setVisibleRectWithX:0.0 endX:sender.value startY:0.0 endY:1.0f];
            }
            break;
        case 102:  //展开合拢
            {
                [videoPen setVisibleRectBorder:0.00f red:1.0f green:0.0f blue:0.0f alpha:1.0f];  //不显示边框.
                [videoPen setVisibleRectWithX:(0.5 - sender.value/2) endX:(0.5+sender.value/2) startY:0.0 endY:1.0];
            }
            break;
        case 103:  //中间四周
            {
//                CGFloat width2=videoPen.penSize.width/2;
//                CGFloat vWidth=videoPen.penSize.width *(1.0f -sender.value);
//
//                CGFloat height2=videoPen.penSize.height/2;
//                CGFloat vheight=videoPen.penSize.height *(1.0f -sender.value);
                [videoPen setVisibleRectBorder:0.00f red:1.0f green:0.0f blue:0.0f alpha:1.0f];  //不显示边框.
                 [videoPen setVisibleRectWithX:(0.5 - sender.value/2) endX:(0.5+sender.value/2) startY:(0.5 - sender.value/2)  endY:(0.5 + sender.value/2) ];
            }
            break;
        case 104:  //圆形展开
           {
               CGFloat radius=sender.value;
               [videoPen setVisibleCircle:radius center:CGPointMake(0.5f, 0.5f)];
               [videoPen setVisibleCircleBorder:0.02 red:1.0f green:0.0f blue:0.0 alpha:1.0];
           }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 初始化一个slide
 */
-(UISlider *)createSlide:(UIView *)parentView  min:(CGFloat)min max:(CGFloat)max  value:(CGFloat)value tag:(int)tag labText:(NSString *)text;
{
    UILabel *labPos=[[UILabel alloc] init];
    labPos.text=text;
    labPos.textColor=[UIColor whiteColor];
    
    UISlider *slidePos=[[UISlider alloc] init];
    
    slidePos.maximumValue=max;
    slidePos.minimumValue=min;
    slidePos.value=value;
    slidePos.continuous = YES;
    slidePos.tag=tag;
    [slidePos addTarget:self action:@selector(slideChanged:) forControlEvents:UIControlEventValueChanged];
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    [self.view addSubview:labPos];
    [self.view addSubview:slidePos];
    
    [labPos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(parentView.mas_bottom).offset(padding);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    [slidePos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(labPos.mas_centerY);
        make.left.mas_equalTo(labPos.mas_right);
        make.size.mas_equalTo(CGSizeMake(size.width-80, 15));
    }];
    return slidePos;
}
-(void)addButton:(UIView *)parentView
{
    btnExecute=[[UIButton alloc] init];
    [btnExecute setTitle:@"后台执行演示" forState:UIControlStateNormal];
    [btnExecute setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btnExecute.titleLabel.font=[UIFont systemFontOfSize:22];
    btnExecute.tag=101;
    [btnExecute addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnExecute];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    [btnExecute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(parentView.mas_bottom).offset(padding);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width*0.7, 60));
    }];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self stopPreview];
}

-(void)dealloc
{
    [self stopPreview];
    bmpPen=nil;
    drawpadPreview=nil;
    videoPen=nil;
    lansongView=nil;
    NSLog(@"Demo1PenMothedVC dealloc");
}
//----------演示后台执行
-(void)testVideoRectExecute
{
      NSString *video=[AppDelegate getInstance].currentEditVideoAsset.videoPath;
    videoExecute=[[DrawPadVideoExecute alloc] initWithPath:video];
     [self stopPreview];
    
    
    WS(weakSelf);
    //刚开始的时候,就区域显示;
    [videoExecute.videoPen setVisibleRectWithX:0.0 endX:1.0 startY:0.0 endY:1.0];
    [videoExecute.videoPen setVisibleRectBorder:0.02 red:1.0f green:0.0 blue:0.0 alpha:1.0f];
    
    
    //增加一个背景;
    UIImage *uiimage=[UIImage imageNamed:@"cover1"];
    LSOBitmapPen *bmpPen=[drawpadPreview addBitmapPen:uiimage];
    bmpPen.fillScale=YES;
    [drawpadPreview setPenPosition:bmpPen index:0];
    
    
    [videoExecute setProgressBlock:^(CGFloat progess) {
        NSLog(@"progress is ::%f",progess);
        [weakSelf setVisibleRect];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.hud showProgress:[NSString stringWithFormat:@"当前正在处理的时间戳是::%f",progess]];
        });
    }];
    [videoExecute setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.hud hide];
            [DemoUtils startVideoPlayerVC:weakSelf.navigationController dstPath:dstPath];
        });
    }];
    
    [videoExecute start];
}
-(void)doButtonClicked:(UIView *)sender
{
    [self testVideoRectExecute];
    
}
-(void)setVisibleRect
{
    visibleSumX+=0.005f;  //每次增加5个像素,效果是:从左上角出现呈现出来;
    visibleSumY+=0.005f;
//    [videoExecute.videoPen setVisibleRect:CGRectMake(0, 0, visibleSumX,visibleSumY)];
    [videoExecute.videoPen setVisibleRectWithX:0.0 endX:visibleSumX startY:0.0 endY:visibleSumY];
}
@end


