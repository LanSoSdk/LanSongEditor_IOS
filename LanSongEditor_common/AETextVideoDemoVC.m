//
//  AETextVideoDemoVC.m
//  LanSongEditor_all
//
//  Created by sno on 2018/11/21.
//  Copyright © 2018 sno. All rights reserved.
//

#import "AETextVideoDemoVC.h"

@interface AETextVideoDemoVC ()
{
    DrawPadAeText *aeTextPreview;
    DrawPadAeText *aeTextExecute;
    
    LanSongView2 *lansongView;
    CGSize drawpadSize;
    
    NSMutableArray *textArray;  //文字数组; LSOOneLineText类型的数组;
    
    UISlider *sliderProgress;
        BOOL isUpdateSlider;
    LSOProgressHUD *hud;
    UIButton *btnPause;
    float  aeSpeed;
    
    UILabel *labHint;
}
@end

@implementation AETextVideoDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    
    
    //演示每行的文字;
    textArray =[[NSMutableArray alloc] init];
    int i=0;
    for (; i<4; i++) {   //当前最大15行, 开放Ae原工程, 您可以任意修改;
        LSOOneLineText *text=[[LSOOneLineText alloc] init];
        text.textColor=[UIColor redColor];  //颜色是红色;
        text.text=[NSString stringWithFormat:@"这是第%d行文字",i];
        [textArray addObject:text];
    }
    
    //第5行
    LSOOneLineText *text=[[LSOOneLineText alloc] init];
    text.textColor=[UIColor greenColor];
    text.text=[NSString stringWithFormat:@"这是第%d行文字",i++];
    [textArray addObject:text];
    
    for(;i<10;i++){
        LSOOneLineText *text=[[LSOOneLineText alloc] init];
        text.textColor=[UIColor blueColor];
        text.text=[NSString stringWithFormat:@"这是第%d行文字",i];
        [textArray addObject:text];
    }
    for(;i<15;i++){
        LSOOneLineText *text=[[LSOOneLineText alloc] init];
        text.textColor=[UIColor yellowColor];
        text.text=[NSString stringWithFormat:@"这是第%d行文字",i];
        [textArray addObject:text];
    }
    aeSpeed=1.0;
    [self startAEPreview];
    
    UILabel *lab=[[UILabel alloc] init];
    [lab setTextColor:[UIColor redColor]];
    [self.view  addSubview:lab];
    
    lab.text=@"此代码用到的DrawPadAeText.m合作后开源,并开放Ae原工程;行数,颜色,动画等可自定义;";
    lab.numberOfLines=3;
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lansongView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    btnPause=[self newButton:lab index:201 hint:@"暂停"];
    UIView *view=[self newButton:btnPause index:202 hint:@"开始后台处理"];
    sliderProgress=[self createSlide:view tag:101 labText:@"进度"];
    view=[self createSlide:sliderProgress tag:102 labText:@"调速"];
    
    labHint=[[UILabel alloc] init];
    [labHint setTextColor:[UIColor redColor]];
    [self.view  addSubview:labHint];
    
    [labHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self stopAeExecute];
    [self stopAePreview];
}
-(void)startAEPreview
{
    [self stopAePreview];
    [self stopAeExecute];
    
    isUpdateSlider=YES;
    
    aeTextPreview=[[DrawPadAeText alloc] initAsPreview];
    drawpadSize=aeTextPreview.drawpadSize;
    
    
    CGSize size=self.view.frame.size;
    if(lansongView==nil){
        lansongView=[LanSongUtils createLanSongView:size drawpadSize:drawpadSize];
        [self.view addSubview:lansongView];  //显示窗口增加到ui上;
    }
    
    [aeTextPreview addLanSongView2:lansongView];
    aeTextPreview.textArray=textArray;
    
    
    [aeTextPreview addBackgroundImage:[UIImage imageNamed:@"t14.jpg"]];
    [aeTextPreview addLogoBitmap:[UIImage imageNamed:@"small.png"]];
    
    __weak typeof(self) weakSelf = self;
    [aeTextPreview setFrameProgressBlock:^(int frame) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadFrameProgress:frame];
        });
    }];
    
    [aeTextPreview setWillshowFrameBlock:^(int frame) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf willShowFrame:frame];
        });
    }];
    
    [aeTextPreview setCompletionBlock:^(NSString *path) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf startAEPreview];  //如果没有编码,则让他循环播放
        });
    }];
    
    [aeTextPreview setSpeed:aeSpeed];
    //6.开始执行,
    [aeTextPreview start];
}

-(void)startAeExecute
{
    [self stopAePreview];
    [self stopAeExecute];
    
    hud=[[LSOProgressHUD alloc] init];
    
    aeTextExecute=[[DrawPadAeText alloc] initAsExecute];
   
    aeTextExecute.textArray=textArray;
    
    [aeTextExecute addBackgroundImage:[UIImage imageNamed:@"t14.jpg"]];
    [aeTextExecute addLogoBitmap:[UIImage imageNamed:@"small.png"]];
    
    __weak typeof(self) weakSelf = self;
    [aeTextExecute setFrameProgressBlock:^(int frame) {
        [weakSelf drawpadFrameProgress:frame];
    }];
    [aeTextExecute setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadCompleted:dstPath];
        });
    }];
    [aeTextExecute start];
}
-(void)stopAePreview
{
    if (aeTextPreview!=nil) {
        [aeTextPreview cancel];
        aeTextPreview=nil;
    }
}
-(void)stopAeExecute
{
    if (aeTextExecute!=nil) {
        [aeTextExecute cancel];
        aeTextExecute=nil;
    }
}
-(void)willShowFrame:(int) frame
{
    [labHint setText:[NSString stringWithFormat:@"即将显示第 %d 行.可以计算每一行的速度",frame]];
}
-(void)drawpadFrameProgress:(int) frame
{
    if(aeTextPreview!=nil){
        float percent=(float)frame/(float)aeTextPreview.totalFrames;
        if(isUpdateSlider){
             sliderProgress.value=percent;
        }
    }else if(aeTextExecute!=nil){
        int percent=frame*100/aeTextExecute.totalFrames;
        [hud showProgress:[NSString stringWithFormat:@"当前进度:%d",percent]];
    }
}

-(void)drawpadCompleted:(NSString *)path
{
    [hud hide];
    aeTextExecute=nil;
    VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
    vce.videoPath=path;
    [self.navigationController pushViewController:vce animated:NO];
}
-(void)onClicked:(UIView *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    UIViewController *pushVC=nil;
    
    switch (sender.tag) {
        case 201:  //替换图片
            if(aeTextPreview!=nil){
                if(aeTextPreview.isPaused){
                    aeTextPreview.pause=NO;
                    [btnPause setTitle:@"暂停" forState:UIControlStateNormal];
                }else{
                    aeTextPreview.pause=YES;
                    [btnPause setTitle:@"恢复" forState:UIControlStateNormal];
                }
            }
            break;
        case 202:  //后台处理
            [self startAeExecute];
            break;
        default:
            break;
    }
    if (pushVC!=nil) {
        [self.navigationController pushViewController:pushVC animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)slideChanged:(UISlider*)sender
{
    float value=[sender value];
    switch (sender.tag) {
        case 101:
            if(aeTextPreview!=nil){
                int frame=(int)(aeTextPreview.totalFrames*value+0.5);
                [aeTextPreview seekToFrame:frame];
            }
            break;
        case 102:
            if(aeTextPreview!=nil){
                float speed=value*5;  //速度举例是0.1--5.0
                aeSpeed=speed;
                [aeTextPreview setSpeed:speed];
            }
            break;
        default:
            break;
    }
}
- (void)slideTouchUp:(UISlider*)sender
{
    isUpdateSlider=YES;
}
- (void)slideTouchDown:(UISlider*)sender
{
    isUpdateSlider=NO;
}
-(UIButton *)newButton:(UIView *)topView index:(int)index hint:(NSString *)hint
{
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=index;
    [btn setTitle:hint forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:btn];
    CGSize size=self.view.frame.size;
    
    [btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).with.offset(5);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));  //按钮的高度.
    }];
    
    return btn;
}
-(UISlider *)createSlide:(UIView *)topView tag:(int)tag labText:(NSString *)text;
{
    UILabel *labPos=[[UILabel alloc] init];
    labPos.text=text;
    labPos.textColor=[UIColor redColor];
    UISlider *slider=[[UISlider alloc] init];
    slider.maximumValue=1.0;
    slider.minimumValue=0.0;
    slider.value=0.0;
    slider.continuous = YES;
    slider.tag=tag;
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    [self.view addSubview:labPos];
    [self.view addSubview:slider];
    
    [slider addTarget:self action:@selector(slideChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(slideTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(slideTouchDown:) forControlEvents:UIControlEventTouchDown];
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
    [self stopAeExecute];
    [self stopAePreview];
}
@end
