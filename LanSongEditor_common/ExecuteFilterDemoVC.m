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


@interface ExecuteFilterDemoVC ()
{
    UILabel *labProgresse;
    UIButton *btnPlay;
    
    DrawPadExecute *drawPad; //后台录制的画板.
    NSString *dstTmpPath;
     NSString *dstPath;
    NSURL *videoURL;
    YXLabel *label;
}
@end

@implementation ExecuteFilterDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor=[UIColor lightGrayColor];
    
    
    [self initUI];
    
}


-(void)startExecute
{
    videoURL = [[NSBundle mainBundle] URLForResource:@"ping20s" withExtension:@"mp4"];
//     videoURL = [[NSBundle mainBundle] URLForResource:@"v3040x1520" withExtension:@"mp4"];
    dstTmpPath = [SDKFileUtil genTmpMp4Path];
    dstPath=[SDKFileUtil genTmpMp4Path];
    
    
    //step1: 设置画板
    drawPad =[[DrawPadExecute alloc] initWithWidth:480 height:480 bitrate:1000*1000 dstPath:dstTmpPath];
    
    
    //step2: 增加一个视频图层,并给图层增加滤镜.
    GPUImageFilter *filter= (GPUImageFilter *)[[GPUImageSepiaFilter alloc] init];
    [drawPad addMainVideoPen:[SDKFileUtil urlToFileString:videoURL] filter:filter];
    
    //设置进度
    __weak typeof(self) weakSelf = self;
    [drawPad setOnProgressBlock:^(CGFloat sampleTime) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"当前的进度是:%f",sampleTime);
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
    
    CALayer *mainLayer=[CALayer layer];
    mainLayer.frame=CGRectMake(0, 60, 480,480);
    mainLayer.backgroundColor=[UIColor clearColor].CGColor;
    
    CALayer *layer=[CALayer layer];
    layer.frame=CGRectMake(0, 80, 50, 50);
    layer.backgroundColor=[UIColor blueColor].CGColor;
    [mainLayer addSublayer:layer];
    [drawPad addCALayerPenWithLayer:mainLayer fromUI:NO];
    //step3: 开始执行
    if([drawPad startDrawPad]==NO)
    {
        NSLog(@"DrawPad容器线程执行失败, 请联系我们!");
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
        [VideoEditor drawPadAddAudio:[SDKFileUtil urlToFileString:videoURL] newMp4:dstTmpPath dstFile:dstPath];
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
    // Dispose of any resources that can be recreated.
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
    
    
    [self.view addSubview:btn];
    [self.view addSubview:btnPlay];
    [self.view addSubview:labProgresse];
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.03;
    
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
    if([SDKFileUtil fileExist:dstTmpPath]){
        [SDKFileUtil deleteFile:dstTmpPath];
    }
    if([SDKFileUtil fileExist:dstPath]){
        [SDKFileUtil deleteFile:dstPath];
    }
}
@end
