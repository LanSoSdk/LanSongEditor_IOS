//
//  VideoEffectVC.m
//  LanSongEditor_all
//
//  Created by sno on 2018/4/11.
//  Copyright ? 2018 sno. All rights reserved.
//

#import "VideoEffectVC.h"

#import "DemoUtils.h"
#import "FilterTpyeList.h"
#import "FilterItem.h"
#import "VideoPlayViewController.h"

@interface VideoEffectVC ()
{
    DrawPadVideoPreview *drawpadPreview;
    
    LanSongView2 *lansongView;
    LSOBitmapPen *bmpPen;
    CGSize drawpadSize;
    LSOVideoPen *videoPen;
    
    
    NSString *dstPath;
    NSString *dstTmpPath;
    
    
    CGFloat  drawPadWidth;
    CGFloat  drawPadHeight;
    
    //抖动
    int colorEdgeCnt;
    int colorScaleStatus;
    BOOL colorScaleEnable;
    LanSongColorEdgeFilter *colorEdgeFilter;
    
    //灵活出窍
    LSOSubPen *outbodyPen;
    int outBodyCnt;
    float outBodySacle;
    
    //后台导出
    DrawPadVideoExecute *videoExecute;
  
}
@property (nonatomic,retain)  DemoProgressHUD *hud;
@end

@implementation VideoEffectVC

#define OUTBODY_FRAMES 15

#define SCALE_STATUS_NONE 0
#define SCALE_STATUS_ADD 1
#define SCALE_STATUS_DEL 2
#define ONESCALE_FRAMES 10

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blackColor];
    
    
    //----------------一下是各种参数设置;
    //创建路径;
    CGSize size=self.view.frame.size;
    lansongView=[DemoUtils createLanSongView:size drawpadSize:[AppDelegate getInstance].currentEditVideoAsset.videoSize];
    [self.view addSubview:lansongView];
    //抖动
    colorEdgeCnt = 0;
    colorScaleStatus = SCALE_STATUS_NONE;
    colorScaleEnable = NO;
    colorEdgeFilter=nil;
    
    //----灵魂出窍;
    outbodyPen=nil;
    outBodyCnt=0;
    outBodySacle = 1.0f;
    
    [self initButtonView];  //布局其他界面;
    
    _hud=[[DemoProgressHUD alloc] init];
}
- (void)viewDidAppear:(BOOL)animated
{
    [self startPreview];
}
- (void)viewDidDisappear:(BOOL)animated
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
    
    __weak typeof(self) weakSelf = self;
    [drawpadPreview setProgressBlock:^(CGFloat progess) {
        [weakSelf videoOutBody];
        [weakSelf colorEdgeRun];
    }];
    
    [drawpadPreview setCompletionBlock:^(NSString *path) {
        dispatch_async(dispatch_get_main_queue(), ^{
            VideoPlayViewController *vce=[[VideoPlayViewController alloc] init];
            vce.videoPath=path;
            [weakSelf.navigationController pushViewController:vce animated:NO];
        });
    }];
    
    videoPen=drawpadPreview.videoPen;
    videoPen.loopPlay=YES;
    
    //开始执行
    [drawpadPreview start];
}
-(void)stopPreview
{
    if (drawpadPreview!=nil) {
        [drawpadPreview cancel];
        drawpadPreview=nil;
    }
}
-(void)doButtonClicked:(UIView *)sender
{
    [self videoNoEffect];
    
    switch (sender.tag) {
        case 101:  //灵魂出窍
            if(outbodyPen==nil){
                outbodyPen=[videoPen addSubPen];
            }
            break;
        case 102:  //抖动
            [self colorEdgeStart];
            break;
        case 103:  //错位
            [self videoCuoWei];
            break;
        case 104:  //镜像
            [self videoMirror];
            break;
        case 105:
            [self twoImageMirror];
            break;
        case 106: //16方框
            [self video16Image];
            break;
        case 107:  //负片
            [self videoColorInvert];
            break;
        case 108: //浮雕
            [self videoColorLaplacian];
            break;
        case 109:  //卡通
            [self videoColorToon];
            break;
        case 110:  //后台执行
            [self exportSubPenExecute];
            break;
        default:
            break;
    }
}
//--------------------一下是ui界面.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//-------------------------各种子图层的效果;
/**
 类似抖音的抖动效果
 */
-(void)colorEdgeStart{
    colorEdgeFilter = [[LanSongColorEdgeFilter alloc] init];
    [videoPen switchFilter:colorEdgeFilter];
    
    colorScaleStatus = SCALE_STATUS_ADD;
    colorScaleEnable =YES;
}
-(void)colorEdgeRun {
    if (colorScaleEnable) {
        //先放大, 再缩小;
        if (colorScaleStatus == SCALE_STATUS_ADD) {
            colorEdgeCnt += 2;
        } else if (colorScaleStatus == SCALE_STATUS_DEL) {
            colorEdgeCnt -= 2;
        }
        
        float scale = 1.0f + colorEdgeCnt * 0.06f;
        videoPen.scaleWidth=scale;
        videoPen.scaleHeight=scale;
        
        if (colorEdgeFilter != nil) {
            float value = 1.0f - colorEdgeCnt * 0.08f;
            [colorEdgeFilter setVolume:value];
        }
        
        if (colorEdgeCnt >= ONESCALE_FRAMES) {
            colorScaleStatus = SCALE_STATUS_DEL;
        } else if (colorEdgeCnt <= 0) { //恢复默认状态
            [videoPen switchFilter:nil];
            
            colorEdgeFilter =nil;
            colorEdgeCnt = 0;
            colorScaleEnable =NO;
            videoPen.scaleHeight=1.0;
            videoPen.scaleWidth=1.0;
            colorScaleStatus = SCALE_STATUS_NONE;
        }
    }
}

//---灵魂出窍
-(void)videoOutBody
{
    if(outbodyPen!=nil && videoPen!=nil){
        outBodyCnt++;
        if(outBodyCnt > OUTBODY_FRAMES){
            [videoPen removeSubPen:outbodyPen];
            outbodyPen=nil;
            outBodyCnt=0;
            outBodySacle = 1.0f;
        }else{
            outbodyPen.hidden=NO;
        }
        
        if(outbodyPen!=nil){
            [outbodyPen setRGBAPercent:0.3];
            outbodyPen.scaleWidth=outBodySacle;
            outbodyPen.scaleHeight=outBodySacle;
            outBodySacle+=0.15;
        }
    }
}

-(void)twoImageMirror
{
    if(videoPen!=nil){
        videoPen.hidden=YES;
        
        
        LSOSubPen *pen0=[videoPen addSubPen];
        
        pen0.scaleHeight=0.5;
        pen0.scaleWidth=0.5;
        pen0.positionX=pen0.scaleWidthValue/2;
        
        LanSongIFRiseFilter *filter=[[LanSongIFRiseFilter alloc] init];
        [pen0 switchFilter:filter];
        
        
        LSOSubPen *pen1=[videoPen addSubPen];
        pen1.scaleHeight=0.5;
        pen1.scaleWidth=0.5;
        pen1.positionX=pen0.positionX + pen1.scaleWidthValue;
        
        LanSongIF1977Filter *filter2=[[LanSongIF1977Filter alloc] init];
        [pen1 switchFilter:filter2];
        
    }
}

-(void)videoMirror
{
    if(videoPen!=nil){
        LanSongMirrorFilter *filter=[[LanSongMirrorFilter alloc] init];
        [videoPen switchFilter:filter];
    }
}

/**
 显示16个图层的效果
 */
-(void) video16Image
{
    if(videoPen!=nil){
        
        //放左上;
        videoPen.hidden=YES;
        
        LSOSubPen *pen0=[videoPen addSubPen];
        pen0.scaleWidth=0.25;
        pen0.scaleHeight=0.25;
        pen0.positionX=pen0.scaleWidthValue/2;
        pen0.positionY=pen0.scaleHeightValue/2;
        
        
        LSOSubPen *pen1=[videoPen addSubPen];
        pen1.scaleWidth=0.25;
        pen1.scaleHeight=0.25;
        pen1.positionX=pen0.positionX + pen0.scaleWidthValue;
        pen1.positionY=pen0.positionY;
        
        LSOSubPen *pen2=[videoPen addSubPen];
        pen2.scaleWidth=0.25;
        pen2.scaleHeight=0.25;
        pen2.positionX=pen1.positionX+ pen2.scaleWidthValue;
        pen2.positionY=pen0.positionY;
        
        LSOSubPen *pen3=[videoPen addSubPen];
        pen3.scaleWidth=0.25;
        pen3.scaleHeight=0.25;
        pen3.positionX=pen2.positionX+ pen3.scaleWidthValue;
        pen3.positionY=pen0.positionY;
        
        [self video12ImageLayout:pen3];
    }
}

/**
 把剩余的12个列出来;
 */
-(void)video12ImageLayout:(LSOSubPen *)first
{
    LSOSubPen *penLast=first;
    
    for (int i=0; i<3; i++)
    {
        LSOSubPen *pen0=[videoPen addSubPen];
        pen0.scaleHeight=0.25;
        pen0.scaleWidth=0.25;
        pen0.positionX=pen0.scaleWidthValue/2;
        pen0.positionY=penLast.positionY + pen0.scaleHeightValue;
        
        LSOSubPen *pen1=[videoPen addSubPen];
        pen1.scaleHeight=0.25;
        pen1.scaleWidth=0.25;
        pen1.positionX=pen0.positionX + pen1.scaleWidthValue;
        pen1.positionY=penLast.positionY +pen1.scaleHeightValue;
        
        LSOSubPen *pen2=[videoPen addSubPen];
        pen2.scaleHeight=0.25;
        pen2.scaleWidth=0.25;
        pen2.positionX=pen1.positionX +pen2.scaleWidthValue;
        pen2.positionY=penLast.positionY + pen2.scaleHeightValue;
        
        LSOSubPen *pen3=[videoPen addSubPen];
        pen3.scaleHeight=0.25;
        pen3.scaleWidth=0.25;
        pen3.positionX=pen2.positionX +pen3.scaleWidthValue;
        pen3.positionY=penLast.positionY + pen3.scaleHeightValue;
        penLast=pen3;
    }
}

/**
 视频错位
 */
-(void)videoCuoWei
{
    if(videoPen!=nil){
        
        LSOSubPen *pen=[videoPen addSubPen];
        pen.positionX=videoPen.positionX -20;  //Y不变;
        pen.positionY=videoPen.positionY;
        [pen setRGBAPercent:0.3];
        
        
        LSOSubPen *pen2=[videoPen addSubPen];
        pen2.positionX=videoPen.positionX +20;
        pen2.positionY=videoPen.positionY;
        [pen2 setRGBAPercent:0.3];
    }
}

/**
 颜色反转
 */
-(void)videoColorInvert
{
    if(videoPen!=nil){
        LanSongColorInvertFilter *filter=[[LanSongColorInvertFilter alloc] init];
        [videoPen switchFilter:filter];
    }
}
/**
 卡通
 */
-(void)videoColorToon
{
    if(videoPen!=nil){
        LanSongToonFilter *filter=[[LanSongToonFilter alloc] init];
        [videoPen switchFilter:filter];
    }
}

-(void)videoColorLaplacian
{
    if(videoPen!=nil){
        LanSongLaplacianFilter *filter=[[LanSongLaplacianFilter alloc] init];
        [videoPen switchFilter:filter];
    }
}
/**
 无效果;
 */
-(void) videoNoEffect
{
    if(videoPen!=nil){
        videoPen.hidden=NO;
        
        videoPen.scaleWidth=1.0;
        videoPen.scaleHeight=1.0;
        videoPen.positionX=videoPen.drawPadSize.width/2;
        videoPen.positionY=videoPen.drawPadSize.height/2;
        
        [videoPen removeAllSubPen];
        [videoPen switchFilter:nil];
        colorScaleEnable=NO;
    }
}
-(void)initButtonView
{
    CGSize size=self.view.frame.size;
    
    CGFloat padding=size.height*0.01;
    
    UILabel *hint=[[UILabel alloc] init];
    hint.text=@"效果开源,可举一反三";
    hint.textColor=[UIColor redColor];
    [self.view addSubview:hint];
    
    
    //灵活出窍
    UIButton *outBody=[self createButton:@"灵魂出窍" WithTag:101];
    UIButton *colorEdge=[self createButton:@"抖动" WithTag:102];
    UIButton *cuowei=[self createButton:@"错位" WithTag:103];
    
    UIButton *videoMirror=[self createButton:@"镜像" WithTag:104];
    UIButton *bgBlur=[self createButton:@"双画面" WithTag:105];
    UIButton *subpen16=[self createButton:@"16画面" WithTag:106];
    
    
    UIButton *invertColor=[self createButton:@"负片" WithTag:107];
    UIButton *fudiao=[self createButton:@"浮雕" WithTag:108];
    UIButton *toon=[self createButton:@"卡通" WithTag:109];
    
    UIButton *bgExecute=[self createButton:@"后台举例" WithTag:110];
     [bgExecute setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    int btnW=120;
    int btnH=60;
    
    [hint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lansongView.mas_bottom).offset(padding);
        make.left.mas_equalTo(self.view.mas_left).offset(padding);
        make.size.mas_equalTo(CGSizeMake(size.width/2, btnH));
    }];
    
    [bgExecute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lansongView.mas_bottom).offset(padding);
        make.left.mas_equalTo(hint.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(size.width/2, btnH));
    }];
    
    
    [outBody mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(hint.mas_bottom).offset(padding);
        make.left.mas_equalTo(self.view.mas_left).offset(padding);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    [colorEdge mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(hint.mas_bottom).offset(padding);
        make.left.mas_equalTo(outBody.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    [cuowei mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(hint.mas_bottom).offset(padding);
        make.left.mas_equalTo(colorEdge.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    //第二排
    [videoMirror mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(cuowei.mas_bottom).offset(padding);
        make.left.mas_equalTo(outBody.mas_left);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    [bgBlur mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(videoMirror.mas_top);
        make.left.mas_equalTo(videoMirror.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    [subpen16 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(videoMirror.mas_top);
        make.left.mas_equalTo(bgBlur.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    
    //第三排
    [invertColor mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(subpen16.mas_bottom).offset(padding);
        make.left.mas_equalTo(outBody.mas_left);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    [fudiao mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(invertColor.mas_top);
        make.left.mas_equalTo(invertColor.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    [toon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(invertColor.mas_top);
        make.left.mas_equalTo(fudiao.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
}
-(UIButton *)createButton:(NSString *)name WithTag:(int)tag
{
    UIButton *btn1=[[UIButton alloc] init];
    [btn1 setTitle:name forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.titleLabel.font=[UIFont systemFontOfSize:25];
    btn1.tag=tag;
    
    [btn1 addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    return btn1;
}
/**
 演示后台执行
 */
-(void)exportSubPenExecute
{
    [self stopPreview];
    
    
    videoExecute=[[DrawPadVideoExecute alloc] initWithPath:[AppDelegate getInstance].currentEditVideoAsset.videoPath];
    
    //----演示左右两个画面(就是增加两个子图层);
    LSOSubPen *pen0=[videoExecute.videoPen addSubPen];
    videoExecute.videoPen.hidden=YES;
    pen0.scaleHeight=0.5;
    pen0.scaleWidth=0.5;
    pen0.positionX=pen0.scaleWidthValue/2;
    
    LanSongIFRiseFilter *filter=[[LanSongIFRiseFilter alloc] init];
    [pen0 switchFilter:filter];
    
    
    LSOSubPen *pen1=[videoExecute.videoPen addSubPen];
    pen1.scaleHeight=0.5;
    pen1.scaleWidth=0.5;
    pen1.positionX=pen0.positionX + pen1.scaleWidthValue;
    
    LanSongIF1977Filter *filter2=[[LanSongIF1977Filter alloc] init];
    [pen1 switchFilter:filter2];
    
    
    //-----------------增加其他
    WS(weakSelf)
    [videoExecute setProgressBlock:^(CGFloat progess) {
        NSLog(@"progress  is :%f",progess);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.hud showProgress:[NSString stringWithFormat:@"时间戳:%f",progess]];
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

-(void)dealloc
{
    [self stopPreview];
    videoPen=nil;
    dstPath=nil;
}
@end

