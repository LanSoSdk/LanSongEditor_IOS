//
//  PictureSetsRealTimeVC.m
//  LanSongEditor_all
//
//  Created by sno on 16/12/29.
//  Copyright © 2016年 sno. All rights reserved.
//

#import "PictureSetsRealTimeVC.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
#import <LanSongEditorFramework/LanSongEditor.h>
#import "LanSongUtils.h"
#import "SlideEffect.h"



@interface PictureSetsRealTimeVC ()
{
    int frameCount;
    
    DrawPadPreview *drawpad;
    NSTimer * timer;
    NSString *dstPath;
    NSString *dstTmpPath;
    
    Pen *operationPen;  //当前操作的图层
    
    
    CGFloat drawPadWidth;   //画板的宽度, 在画板运行前设置的固定值
    CGFloat drawPadHeight; //画板的高度,在画板运行前设置的固定值
    int     drawPadBitRate;  //画板的码率, 在画板运行前设置的固定值
    BOOL isadd;
    NSMutableArray *slideArray;
    
}
@end

#define  kUpdateFps 25

@implementation PictureSetsRealTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
    dstPath = [SDKFileUtil genFileNameWithSuffix:@"mp4"];
    dstTmpPath= [SDKFileUtil genFileNameWithSuffix:@"mp4"];
    /**
     第一步: 创建一个画板,并增加编码保存路径
     */
    
    drawPadWidth=480;
    drawPadHeight=480;
    drawPadBitRate=1000*1000;
    drawpad=[[DrawPadPreview alloc] initWithWidth:drawPadWidth height:drawPadHeight bitrate:drawPadBitRate dstPath:dstTmpPath];
    
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    /**
     step2:第二步:  增加一个View用来预览显示.
     暂时采用宽度为固定值,来调整高度,如果您的视频是竖的, 则应该固定高度来调整宽度. 或者设置一个正方形
     */
    DrawPadView *drawpadView=[[DrawPadView alloc] initWithFrame:CGRectMake(0, 60, size.width,size.width*(drawPadHeight/drawPadWidth))];
    
    [self.view addSubview: drawpadView];
    [drawpad setDrawPadPreView:drawpadView];
    
    
    /**
     step3: 增加一些图层.
     */
    
    UIImage *imag=[UIImage imageNamed:@"p640x1136"];
    [drawpad addBitmapPen:imag];
    
    slideArray=[[NSMutableArray alloc] init];
    
    [self addBitmapPen:@"mm" start:0.0f end:5.0f];
    [self addBitmapPen:@"tt3" start:5.0f end:10.0f];
    [self addBitmapPen:@"pic3" start:10.0f end:15.0f];
    [self addBitmapPen:@"pic4" start:15.0f end:20.0f];
    [self addBitmapPen:@"pic5" start:20.0f end:25.0f];
    
    //设置进度回调.
    __weak typeof(self) weakSelf = self;
    [drawpad setOnProgressBlock:^(CGFloat currentPts) {
        dispatch_async(dispatch_get_main_queue(), ^{
              //NSLog(@"当前处理的进度是:%f(秒)",currentPts);
            
            weakSelf.labProgress.text=[NSString stringWithFormat:@"当前进度 %f",currentPts];
            //在15秒的时候结束.
            if (currentPts>=26.0f) {
                [weakSelf stopDrawPad];
            }
            //把当前进度传递进去.
            [weakSelf updatePen:currentPts];
        });
    }];
    
    //设置完成后的回调
    [drawpad setOnCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf addAudio];
            [weakSelf showIsPlayDialog];
            
        });
    }];
    
    /**
     第四步: 设置画板自动刷新,并开始工作
     */
    
    [drawpad setUpdateMode:kAutoTimerUpdate autoFps:25];
    
    if([drawpad startDrawPad]==NO)
    {
        NSLog(@"DrawPad容器线程执行失败, 请联系我们!");
    }
    

    //----一下是ui操作.
    _labProgress=[[UILabel alloc] init];
    _labProgress.textColor=[UIColor redColor];
    
    [self.view addSubview:_labProgress];
    
    [_labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(drawpadView.mas_bottom).offset(padding);
        make.centerX.mas_equalTo(drawpadView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
    
    UILabel *labHint=[[UILabel alloc] init];
    [labHint setText:@"举例: 同时向DrawPad容器里增加多个图片图层,然后按照进度移动来形成进出的效果"];
    labHint.numberOfLines=3;
    [self.view addSubview:labHint];
    [labHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labProgress.mas_bottom).offset(padding);
        make.centerX.mas_equalTo(_labProgress.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(size.width, 120));
    }];
    
}

/**
 每一个帧都有回调, 
 返回到这里,根据时间戳来移动每个图层的位置.

 @param currentPts <#currentPts description#>
 */
-(void)updatePen:(CGFloat)currentPts
{
    for (int i=0; i<slideArray.count; i++) {
        SlideEffect *item=[slideArray objectAtIndex:i];
        [item run:currentPts];
    }
}

-(void)stopDrawPad
{
    [drawpad stopDrawPad];
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (drawpad!=nil) {
        [drawpad stopDrawPad];
    }
}
/**
 把图片图层增加到DrawPad容器中.

 */
-(void)addBitmapPen:(NSString *)picName start:(CGFloat)start end:(CGFloat)end
{
    UIImage *imag=[UIImage imageNamed:picName];
    Pen *item=[drawpad addBitmapPen:imag];
    
    item.scaleWidth=0.5f;
    item.scaleHeight=0.5f;
    
    SlideEffect *slide=[[SlideEffect alloc] initWithPen:item FPs:kUpdateFps startTime:start endTime:end release:true];
    
    [slideArray addObject:slide];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 运行完后, 增加背景音乐
 */
-(void)addAudio
{
    //因为影集是没有音频的, 这里增加一个别的作为背景音乐.
    NSURL *audioRrl = [[NSBundle mainBundle] URLForResource:@"honor30s2" withExtension:@"m4a"];
    if([SDKFileUtil fileExist:dstTmpPath])
    {
        [VideoEditor executeVideoMergeAudio:dstTmpPath audioFile:[SDKFileUtil urlToFileString:audioRrl] dstFile:dstPath];
    }else{
        dstPath=dstTmpPath;
    }
}
-(void)showIsPlayDialog
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"视频已经处理完毕,是否需要预览" delegate:self cancelButtonTitle:@"预览" otherButtonTitles:@"返回", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
    }else {  //返回
        
    }
}


-(void)dealloc
{
    if([SDKFileUtil fileExist:dstPath]){
        [SDKFileUtil deleteFile:dstPath];
    }
    if([SDKFileUtil fileExist:dstTmpPath]){
        [SDKFileUtil deleteFile:dstTmpPath];
    }
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
