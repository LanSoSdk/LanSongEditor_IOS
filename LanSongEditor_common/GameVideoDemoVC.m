//
//  GameVideoDemoVC.m
//  LanSongEditor_all
//
//  Created by sno on 2018/9/7.
//  Copyright © 2018 sno. All rights reserved.
//

#import "GameVideoDemoVC.h"

#import "DemoUtils.h"
#import "VideoPlayViewController.h"
#import "LSDrawView.h"

@interface GameVideoDemoVC ()
{
    DrawPadVideoPreview *drawpadPreview;
    
    LanSongView2 *lansongView;
    LSOBitmapPen *bmpPen;
    CGSize drawpadSize;
    LSOVideoPen *videoPen;
}
@property (nonatomic,retain) NSMutableArray *videoArray;
@end

@implementation GameVideoDemoVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"测试Preview";
    self.view.backgroundColor=[UIColor whiteColor];
    
    //布局视频宽高
     CGSize size=self.view.frame.size;
     lansongView=[DemoUtils createLanSongView:size drawpadSize:[AppDelegate getInstance].currentEditVideoAsset.videoSize];
     [self.view addSubview:lansongView];
    
    _videoArray=[[NSMutableArray alloc] init];
    
    //-------------以下是ui操作-----------------------
    
    
    _labProgress=[[UILabel alloc] init];
    _labProgress.textColor=[UIColor redColor];
    [self.view addSubview:_labProgress];
    
    [_labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lansongView.mas_bottom);
        make.centerX.mas_equalTo(lansongView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(size.width, 30));
    }];
    
    _recordProgress=[[UILabel alloc] init];
    _recordProgress.textColor=[UIColor redColor];
    [self.view addSubview:_recordProgress];
    
    [_recordProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labProgress.mas_bottom);
        make.centerX.mas_equalTo(_labProgress.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(size.width, 30));
    }];
    
    UIView *btn1=[self createButtons];
    
    UIView *currslide=  [self createSlide:btn1 min:0.0f max:1.0f value:0.5f tag:601 labText:@"速度:"];
    UIView *currslide2=  [self createSlide:currslide min:0.0f max:1.0f value:0.5f tag:602 labText:@"移动:"];
    [self createSlide:currslide2 min:0.0f max:1.0f value:0.5f tag:603 labText:@"缩放:"];
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
    drawpadPreview=[[DrawPadVideoPreview alloc] initWithPath:video];
    drawpadSize=drawpadPreview.drawpadSize;
    
    
    //增加显示窗口
    [drawpadPreview addLanSongView:lansongView];
    
    //增加Bitmap图层
    UIImage *image=[UIImage imageNamed:@"mm"];
    bmpPen=[drawpadPreview addBitmapPen:image];
    
    //增加UI图层, 这个图层的功能是涂鸦;
        UIView *view=[[UIView alloc] initWithFrame:lansongView.frame];
        view.backgroundColor=[UIColor clearColor];
        LSDrawView *drawView=[[LSDrawView alloc] initWithFrame:CGRectMake(0, 0, lansongView.frame.size.width, lansongView.frame.size.height)];
        drawView.brushColor = UIColorFromRGB(255, 255, 0);
        drawView.shapeType = LSShapeCurve;  //形状是曲线;
        [view addSubview:drawView];

        [self.view addSubview:view];
        [drawpadPreview addViewPen:view isFromUI:YES];
    
    
    __weak typeof(self) weakSelf = self;
    //设置预览进度;
    [drawpadPreview setProgressBlock:^(CGFloat progress) {
        [weakSelf progressBlock:progress];
    }];
    
    [drawpadPreview setRecordProgressBlock:^(CGFloat progress) {
         [weakSelf recordProgressBlock:progress];
    }];
    [drawpadPreview setCompletionBlock:^(NSString *path) {
        [weakSelf.videoArray addObject:path];
    }];
    
    videoPen=drawpadPreview.videoPen;
    videoPen.loopPlay=YES;
    
    //开始执行,并编码
    [drawpadPreview start];
}
-(void)progressBlock:(CGFloat)progress
{
    int percent=(int)(progress*100/drawpadPreview.duration);
    _labProgress.text=[NSString stringWithFormat:@"播放进度:%f,百分比:%d",progress,percent];
}
-(void)recordProgressBlock:(CGFloat)progress
{
    _recordProgress.text=[NSString stringWithFormat:@"录制时长:%f",progress];
}
-(void)stopPreview
{
    if (drawpadPreview!=nil) {
        [drawpadPreview cancel];
        drawpadPreview=nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doButtonClicked:(UIView *)sender
{
    switch (sender.tag) {
        case 101 :  //开始录制
            [drawpadPreview startRecord];
            break;
        case  102:  //停止录制
            [drawpadPreview stopRecord];
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
            if([_videoArray count]>1){
                
                
                
//                NSString *dstPath=[LSOFileUtil genTmpMp4Path];
////                 [LSOVideoEditor executeConcatMP4:_videoArray dstFile:dstPath];
//                VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
//                vce.videoPath=dstPath;//LSDELETE
//                [self.navigationController pushViewController:vce animated:NO];
                
                
            }else if([_videoArray count]==1){
                NSString *path=[_videoArray objectAtIndex:0];
                VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
                vce.videoPath=path;
                [self.navigationController pushViewController:vce animated:NO];
            }else{
                [DemoUtils showDialog:@"没有录制的视频"];
            }
            break;
        default:
            break;
    }
}
- (void)slideChanged:(UISlider*)sender
{
    CGFloat val=[(UISlider *)sender value];
    switch (sender.tag) {
        case 601:
            videoPen.avplayer.rate=val*2;  //速度在0.0---2.0之间;
            break;
        case 602:
            {  //从屏幕的最左侧,移动到屏幕的最右侧;
                CGFloat posX=(videoPen.drawPadSize.width +videoPen.penSize.width)*val -videoPen.penSize.width/2;
                videoPen.positionX=posX;
            }
            break;
        case 603:
            videoPen.scaleWH=val*4;  //乘以4 是为了放大一些, 方便直观演示而已,实际可任意;
            break;
        default:
            break;
    }
}

-(UIView *)createButtons
{
    //点击按钮;
    UIButton *btnStartRecord=[self createButton:@"开始录制" tag:101];
    UIButton *btnStopRecord=[self createButton:@"停止录制" tag:102];
    UIButton *btnDrawpadPause=[self createButton:@"容器暂停" tag:103];
    UIButton *btnDrawpadResume=[self createButton:@"容器恢复" tag:104];
    UIButton *btnDrawPadStop=[self createButton:@"容器停止" tag:105];
    UIButton *btnDrawPadStart=[self createButton:@"容器开始" tag:106];
    UIButton *btnVideoConcat=[self createButton:@"拼接合成" tag:107];
    CGFloat btnWidth=80;
    CGFloat btnHeight=30;
    [btnStartRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_recordProgress.mas_bottom);
        make.left.mas_equalTo(_recordProgress.mas_left);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
    }];
    
    [btnStopRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_recordProgress.mas_bottom);
        make.left.mas_equalTo(btnStartRecord.mas_right);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
    }];
    
    
    [btnDrawPadStart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnStartRecord.mas_bottom);
        make.left.mas_equalTo(btnStartRecord.mas_left);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
    }];
    
    
    [btnDrawpadPause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnStartRecord.mas_bottom);
        make.left.mas_equalTo(btnDrawPadStart.mas_right);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
    }];
    [btnDrawpadResume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnStartRecord.mas_bottom);
        make.left.mas_equalTo(btnDrawpadPause.mas_right);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
    }];
    
    [btnDrawPadStop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnStartRecord.mas_bottom);
        make.left.mas_equalTo(btnDrawpadResume.mas_right);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
    }];
    
    [btnVideoConcat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnDrawPadStop.mas_bottom);
        make.left.mas_equalTo(btnDrawPadStart.mas_left);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
    }];
    return btnVideoConcat;
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
