//
//  FilterBackGroundViewController.m
//  LanSongEditor_all
//
//  Created by sno on 16/12/12.
//  Copyright © 2016年 sno. All rights reserved.
//

#import "ExecuteFilterDemoVC.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import <LanSongEditorFramework/LanSongEditor.h>
#import "VideoPlayViewController.h"
#import "LanSongUtils.h"
#import "YXLabel.h"


/**
 后台滤镜,
 此演示在容器里增加: 一个视频图层, 一个CALayer图层; 运行容器,得到结果.
 
 如果您只想给视频增加滤镜, 我们有另一个类ScaleExecute, 可以指定缩放,并设置滤镜,用ScaleExecute.h即可.
 */
@interface ExecuteFilterDemoVC ()
{
    UILabel *labProgresse;
    UIButton *btnPlay;
    
    DrawPadExecute *drawPad; //后台录制的容器.
    EditFileBox *srcFile;
    NSString *dstTmpPath;
    NSString *dstPath;
    YXLabel *label;
}
@end

@implementation ExecuteFilterDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self initUI];
}
-(void)viewDidDisappear:(BOOL)animated
{
    if (drawPad!=nil) {
        [drawPad stopDrawPad];
        drawPad=nil;
    }
}
-(void)startExecute
{
    dstTmpPath = [SDKFileUtil genTmpMp4Path];
    dstPath=[SDKFileUtil genTmpMp4Path];
    
    //step1: 设置容器大小为480x480, 或者您可以设置为原尺寸大小.
    drawPad =[[DrawPadExecute alloc] initWithWidth:480 height:480 dstPath:dstTmpPath];
    
    
    //step2: 增加一个视频图层,并给图层增加滤镜.
    LanSongFilter *filter= (LanSongFilter *)[[LanSongSepiaFilter alloc] init];
    
    srcFile=[AppDelegate getInstance].currentEditBox;
    
    VideoPen *videoPen= [drawPad addMainVideoPen:srcFile.srcVideoPath filter:filter];
    
   
    //设置进度
    __weak typeof(self) weakSelf = self;
    [drawPad setOnProgressBlock:^(CGFloat sampleTime) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showProgress:sampleTime];
        });
    }];
    
    //设置完成后的回调
    [drawPad setOnCompletionBlock:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf addAudio];
            [weakSelf showComplete];
        });
    }];
    
//    CALayer *mainLayer=[CALayer layer];
//    mainLayer.frame=CGRectMake(0, 60, 480,480);
//    mainLayer.backgroundColor=[UIColor clearColor].CGColor;
//    
//    CALayer *layer=[CALayer layer];
//    layer.frame=CGRectMake(0, 80, 50, 50);
//    layer.backgroundColor=[UIColor blueColor].CGColor;
//    [mainLayer addSublayer:layer];
//    
//    //增加一个CALayer;
//    [drawPad addCALayerPenWithLayer:mainLayer fromUI:NO];
//    
//    [self addBitmapLayer];
    
    //step3: 开始执行
    if(videoPen!=nil){
        if([drawPad startDrawPad]==NO)
        {
            NSLog(@"DrawPad容器线程执行失败, 请联系我们!");
        }
    }else{
         NSLog(@"视频图层增加失败...");
    }
}

-(void)addBitmapLayer
{
    if(drawPad!=nil){
        UIImage *image=[UIImage imageNamed:@"mm"];
        BitmapPen *pen=[drawPad addBitmapPen:image];

        //放到右上角.(图层的xy,是中心点的位置)
        pen.positionX=pen.drawPadSize.width-pen.penSize.width/2;
        pen.positionY=pen.penSize.height/2;
        
       
        pen.scaleWidth=0.5f;
        pen.scaleHeight=0.5f;
 
//        NSLog(@"增加一个 图片图层...");
    }
}
-(void) showProgress:(CGFloat) sampleTime
{
    NSString *hint=[NSString stringWithFormat:@"当前进度是:%f",sampleTime];
    labProgresse.text=hint;
}
-(void)addAudio
{
    if ([SDKFileUtil fileExist:dstTmpPath]) {
        [VideoEditor drawPadAddAudio:srcFile.srcVideoPath newMp4:dstTmpPath dstFile:dstPath];
    }else{
        dstPath=dstTmpPath;
    }
}

-(void)showComplete
{
    labProgresse.text=@"处理完毕";
    btnPlay.enabled=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)doButtonClicked:(UIView *)sender
{
    switch (sender.tag) {
        case 100 :
                [self startExecute];
            break;
        case  101:
            [self startVideoPlayerVC];
            break;
        default:
            break;
    }
}
-(void)initUI
{
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=100;
    [btn setTitle:@"开始执行" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor whiteColor];
    
    [btn addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    labProgresse=[[UILabel alloc] init];
    labProgresse.text=@"";
    
    
    btnPlay=[[UIButton alloc] init];
    btnPlay.tag=101;
    [btnPlay setTitle:@"结果预览" forState:UIControlStateNormal];
    [btnPlay setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnPlay.backgroundColor=[UIColor whiteColor];
    
    [btnPlay addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *labHint=[[UILabel alloc] init];
    labHint.numberOfLines=0;
    labHint.text=@"演示在容器里增加: 一个视频图层, 一个CALayer图层; 运行容器,得到结果.";
    
    [self.view addSubview:btn];
    [self.view addSubview:btnPlay];
    [self.view addSubview:labProgresse];
    [self.view addSubview: labHint];
    
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
    [labProgresse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(btn.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 60));
    }];
    
    [btnPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labProgresse.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(labProgresse.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
    btnPlay.enabled=NO;
    
    [labHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnPlay.mas_bottom).offset(padding);
        make.centerX.mas_equalTo(btnPlay.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(size.width, 200));
    }];
}
//--------------------------

-(void)startVideoPlayerVC
{
    if ([SDKFileUtil fileExist:dstPath]) {
        VideoPlayViewController *videoVC=[[VideoPlayViewController alloc] initWithNibName:@"VideoPlayViewController" bundle:nil];
        videoVC.videoPath=dstPath;
        [self.navigationController pushViewController:videoVC animated:YES];
    }else{
        NSString *str=[NSString stringWithFormat:@"文件不存在:%@",dstTmpPath];
        [LanSongUtils showHUDToast:str];
    }
}
-(void)dealloc
{
    [SDKFileUtil deleteFile:dstTmpPath];
    [SDKFileUtil deleteFile:dstPath];
    NSLog(@"ExecuteFilterDemoVC  dealloc...");
}
@end
