//
//  BitmapPadPreviewDemoVC.m
//  LanSongEditor_all
//
//  Created by sno on 2018/10/20.
//  Copyright © 2018 sno. All rights reserved.
//

#import "BitmapPadPreviewDemoVC.h"


#import "DemoUtils.h"
#import "VideoPlayViewController.h"

@interface BitmapPadPreviewDemoVC ()
{
    BitmapPadPreview *drawpadPreview;
    
    LanSongView2 *lansongView;
    LSOBitmapPen *bmpPen;
    LSOVideoPen *videoPen;
    
    UIView *viewPenView;
}
@property (nonatomic,retain) NSMutableArray *videoArray;
@end

@implementation BitmapPadPreviewDemoVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"测试Preview";
    self.view.backgroundColor=[UIColor whiteColor];
    
    //布局视频宽高
    NSString *video=[AppDelegate getInstance].currentEditVideoAsset.videoPath;
        lansongView=[[LanSongView2 alloc] initWithFrame:self.view.frame];
        [self.view addSubview:lansongView];
    
    
    viewPenView=[[UIView alloc] initWithFrame:lansongView.frame];
    [self.view addSubview:viewPenView];
    
    
    _videoArray=[[NSMutableArray alloc] init];
    //-------------以下是ui操作-----------------------
  
}
-(void)viewDidAppear:(BOOL)animated
{
    [self startPreview]; //开启预览
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self stopPreview];
}
-(void)startPreview
{
    [self stopPreview];
    
    //创建容器
    NSString *video=[AppDelegate getInstance].currentEditVideoAsset.videoPath;
    drawpadPreview=[[BitmapPadPreview alloc] initWithVideo:video];

    
//    drawpadPreview=[[BitmapPadPreview alloc] initWithUIImage:[UIImage imageNamed:@"zaoan"]];
    
    [drawpadPreview addLanSongView:lansongView];

    viewPenView.backgroundColor=[UIColor clearColor];
    //在view上增加其他ui
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 50, 150, 80)];
    label.text=@"测试文字123abc";
    label.textColor=[UIColor redColor];
    [viewPenView addSubview:label];
    [drawpadPreview addViewPen:viewPenView isFromUI:NO];


    //增加Bitmap图层
    UIImage *image=[UIImage imageNamed:@"mm"];
    bmpPen=[drawpadPreview addBitmapPen:image];

    videoPen=drawpadPreview.videoPen;
    [drawpadPreview start];
    
}
-(void)stopPreview
{
    if (drawpadPreview!=nil) {
        [drawpadPreview stop];
        drawpadPreview=nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)slideChanged:(UISlider*)sender
{
    CGFloat val=[(UISlider *)sender value];
    switch (sender.tag) {
        case 601:
            break;
        case 602:
            {
                CGFloat timeS=val*videoPen.duration;
                [videoPen seekToTimePause:timeS];
            }
            break;
        case 603:
            videoPen.scaleWH=val*4;  //乘以4 是为了放大一些, 方便直观演示而已,实际可任意;
            break;
        default:
            break;
    }
}
-(void)doButtonClicked:(UIView *)sender
{
    switch (sender.tag) {
        case 101 :  //开始录制
            
            [LSOFileUtil saveUIViewToPhotosAlbum:lansongView];
            NSLog(@"已保存到相册");
            break;
        case  102:  //停止录制
//            [drawpadPreview stopRecord];
            break;
        case  103:  //容器暂停
            [drawpadPreview.videoPen.avplayer pause];
            break;
        case  104:  //容器恢复
            [drawpadPreview.videoPen.avplayer play];
            break;
        case 105:  //容器停止
            [drawpadPreview stop];
            break;
        case 106:  //容器开始
            [drawpadPreview start];
            break;
        case 107:
            break;
        default:
            break;
    }
}

-(UIView *)createButtons
{
    //点击按钮;
//    UIButton *text=[self createButton:@"文字" tag:103];
//    UIButton *stick=[self createButton:@"贴纸" tag:104];
//    UIButton *tuya=[self createButton:@"涂鸦" tag:105];
//    UIButton *result=[self createButton:@"获取结果" tag:106];
//    CGFloat btnWidth=80;
//    CGFloat btnHeight=30;
//
//
//    [text mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view.mas_centerY).offset(50);
//        make.centerX.mas_equalTo(lansongView.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
//    }];
//
//
//    [stick mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(btnStartRecord.mas_bottom);
//        make.left.mas_equalTo(btnDrawPadStart.mas_right);
//        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
//    }];
//    [tuya mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(btnStartRecord.mas_bottom);
//        make.left.mas_equalTo(btnDrawpadPause.mas_right);
//        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
//    }];
//
//    [result mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(btnStartRecord.mas_bottom);
//        make.left.mas_equalTo(btnDrawpadResume.mas_right);
//        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
//    }];
//
//    return result;
    return nil;
}
-(UIButton *)createButton:(NSString *)text tag:(int)tag
{
    UIButton *btn=[[UIButton alloc] init];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.tag=tag;
    
    [btn addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    return btn;
}
-(UIView *)createSlide:(UIView *)parentView  min:(CGFloat)min max:(CGFloat)max  value:(CGFloat)value tag:(int)tag labText:(NSString *)text;

{
    UILabel *labPos=[[UILabel alloc] init];
    labPos.text=text;
    
    UISlider *slidePos=[[UISlider alloc] init];
    
    slidePos.maximumValue=max;
    slidePos.minimumValue=min;
    slidePos.value=value;
    slidePos.continuous = YES;
    slidePos.tag=tag;
    [slidePos addTarget:self action:@selector(slideChanged:) forControlEvents:UIControlEventValueChanged];
    CGSize size=self.view.frame.size;
    //    CGFloat padding=size.height*0.01;
    
    [self.view addSubview:labPos];
    [self.view addSubview:slidePos];
    
    [labPos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(parentView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    [slidePos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(labPos.mas_centerY);
        make.left.mas_equalTo(labPos.mas_right);
        make.size.mas_equalTo(CGSizeMake(size.width-80, 15));
    }];
    return labPos;
}
-(void)dealloc
{
    [self stopPreview];
    bmpPen=nil;
    drawpadPreview=nil;
    lansongView=nil;
    if(_videoArray!=nil){
        [_videoArray removeAllObjects];
        _videoArray=nil;
    }
    NSLog(@"GameVideoDemoVC VC  dealloc");
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

