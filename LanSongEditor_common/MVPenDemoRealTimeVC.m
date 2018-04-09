//
//  MVPenDemoRealTimeVC.m
//  LanSongEditor_all
//
//  Created by sno on 17/2/26.
//  Copyright © 2017年 sno. All rights reserved.
//

#import "MVPenDemoRealTimeVC.h"

#import "LanSongUtils.h"
#import "BlazeiceDooleView.h"

@interface MVPenDemoRealTimeVC ()
{
    DrawPadPreview *drawpad;
    
    NSString *dstPath;
    NSString *dstTmpPath;
    
    EditFileBox *srcFile;
    Pen *operationPen;  //当前操作的图层
    
}
@end

@implementation MVPenDemoRealTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"演示增加MV图层";
    
    srcFile=[AppDelegate getInstance].currentEditBox;
    
    dstTmpPath = [SDKFileUtil genFileNameWithSuffix:@"mp4"];
    dstPath = [SDKFileUtil genFileNameWithSuffix:@"mp4"];
  
    
    //step1:第一步: 创建容器(尺寸,码率,编码后的目标文件路径,增加一个预览view)
    CGFloat     drawPadWidth=480;
    CGFloat     drawPadHeight=480;
    int    drawPadBitRate=1000*1000;
    //DrawPadPreview是一个线程,
    drawpad=[[DrawPadPreview alloc] initWithWidth:drawPadWidth height:drawPadHeight bitrate:drawPadBitRate dstPath:dstTmpPath];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    //DrawPadView是用来显示 DrawPadPreview画面的一个载体.
    DrawPadView *filterView=[[DrawPadView alloc] initWithFrame:CGRectMake(0, 60, size.width,size.width*(drawPadHeight/drawPadWidth))];
    
    [self.view addSubview: filterView];
    [drawpad setDrawPadPreView:filterView];
    
    
    //第二步: 增加一些图层,当然您也可以在容器开始后增加
    UIImage *imag=[UIImage imageNamed:@"p640x1136"];
    [drawpad addBitmapPen:imag];  //增加一个图片图层,因为先增加的,放到最后,等于是背景.

    
    //增加一个CALayer, 是一个红色的矩形框(先放一个全局的CAlayer,然后增加矩形框).
    CALayer *mainLayer=[CALayer layer];
    mainLayer.frame=CGRectMake(0, 60, size.width,size.width*(drawPadHeight/drawPadWidth));
    mainLayer.backgroundColor=[UIColor clearColor].CGColor;
    
    CALayer *layer=[CALayer layer];
    layer.frame=CGRectMake(0, 20, 50, 50);
    layer.backgroundColor=[UIColor redColor].CGColor;
    [mainLayer addSublayer:layer];
    [drawpad addCALayerPenWithLayer:mainLayer fromUI:NO];
    
    //增加一个视频图层.
    operationPen=  [drawpad addMainVideoPen:srcFile.srcVideoPath filter:nil];
    
    
    //增加一个mv图层.
    NSURL *colorPath = [[NSBundle mainBundle] URLForResource:@"mei" withExtension:@"mp4"];
    NSURL *maskPath = [[NSBundle mainBundle] URLForResource:@"mei_b" withExtension:@"mp4"];
    [drawpad addMVPen:[SDKFileUtil urlToFileString:colorPath] maskPath:[SDKFileUtil urlToFileString:maskPath] filter:nil];
    
    //第三步, 设置 进度回调,完成回调, 开始执行.
    __weak typeof(self) weakSelf = self;
    [drawpad setOnProgressBlock:^(CGFloat currentPts) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.labProgress.text=[NSString stringWithFormat:@"当前进度 %f",currentPts];
            
        });
    }];
    
    //设置完成后的回调
    [drawpad setOnCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf addAudio];
            [weakSelf showIsPlayDialog];
        });
    }];
    
    // 开始工作
    if([drawpad startDrawPad]==NO)
    {
        NSLog(@"DrawPad容器线程执行失败, 请联系我们!");
    }
    
    //一下是ui操作.
    _labProgress=[[UILabel alloc] init];
    _labProgress.textColor=[UIColor redColor];
    
    [self.view addSubview:_labProgress];
    
    [_labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(filterView.mas_bottom).offset(padding);
        make.centerX.mas_equalTo(filterView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
    
    UILabel *labHint=[[UILabel alloc] init];
    labHint.numberOfLines=0;
    
    labHint.text=@"演示\n 视频图层+ CALayer图层 + MV图层  的叠加 \n\n (左上侧的红色四方块为CALayer的演示)";
   
    [self.view addSubview: labHint];
    
    [labHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labProgress.mas_bottom).offset(padding);
        make.centerX.mas_equalTo(filterView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(size.width, 100));
    }];
}

/**
 处理完毕后, 增加音频
 */
-(void)addAudio
{
    if ([SDKFileUtil fileExist:dstTmpPath]) {
        [VideoEditor drawPadAddAudio:srcFile.srcVideoPath newMp4:dstTmpPath dstFile:dstPath];
    }else{
        dstPath=dstTmpPath;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)viewDidDisappear:(BOOL)animated
{
    if (drawpad!=nil) {
        [drawpad stopDrawPad];
    }
}
-(void)dealloc
{
    operationPen=nil;
    drawpad=nil;
    if([SDKFileUtil fileExist:dstPath]){
        [SDKFileUtil deleteFile:dstPath];
    }
    if([SDKFileUtil fileExist:dstTmpPath]){
        [SDKFileUtil deleteFile:dstTmpPath];
    }
    NSLog(@"VideoPictureRealTime VC  dealloc");
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

