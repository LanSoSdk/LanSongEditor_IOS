//
//  ViewPenRealTimeDemoVC.m
//  LanSongEditor_all
//
//  Created by sno on 17/1/3.
//  Copyright © 2017年 sno. All rights reserved.
//

#import "ViewPenRealTimeDemoVC.h"

#import "LanSongUtils.h"
#import "BlazeiceDooleView.h"
#import "YXLabel.h"

@interface ViewPenRealTimeDemoVC ()
{
    DrawPadPreview *drawpad;
    
    NSString *dstPath;
    NSString *dstTmpPath;
    NSURL *sampleURL;
    Pen *operationPen;  //当前操作的图层
    
    
    CGFloat drawPadWidth;   //画板的宽度, 在画板运行前设置的固定值
    CGFloat drawPadHeight; //画板的高度,在画板运行前设置的固定值
    int     drawPadBitRate;  //画板的码率, 在画板运行前设置的固定值
    BOOL isadd;
    
    BlazeiceDooleView *doodleView;
    
    YXLabel *label;
    
}
@end
/**
 说明:  此ViewControlloer用来作为 蓝松科技工程师 调试代码所用, 建议不要作为参考.
 
 */
@implementation ViewPenRealTimeDemoVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
    dstPath = [SDKFileUtil genFileNameWithSuffix:@"mp4"];
    if ([SDKFileUtil fileExist:dstPath]) {
        [SDKFileUtil deleteFile:dstPath];
    }
    dstPath = [SDKFileUtil genFileNameWithSuffix:@"mp4"];
    dstTmpPath= [SDKFileUtil genFileNameWithSuffix:@"mp4"];

    
    //step1:第一步: 创建一个画板(尺寸,码率,保存路径,预览界面)
    drawPadWidth=480;
    drawPadHeight=480;
    drawPadBitRate=1000*1000;
    drawpad=[[DrawPadPreview alloc] initWithWidth:drawPadWidth height:drawPadHeight bitrate:drawPadBitRate dstPath:dstTmpPath];
    
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    DrawPadView *filterView=[[DrawPadView alloc] initWithFrame:CGRectMake(0, 60, size.width,size.width*(drawPadHeight/drawPadWidth))];
    
    [self.view addSubview: filterView];
    [drawpad setDrawPadPreView:filterView];  //增加一个预览界面
    
    
    //step2第二步:增加图层(当然也可以在画板进行中增加)
            UIImage *imag=[UIImage imageNamed:@"p640x1136"];
            [drawpad addBitmapPen:imag];
            
            
            //增加一个主视频图层
            sampleURL = [[NSBundle mainBundle] URLForResource:@"ping20s" withExtension:@"mp4"];
            operationPen=[drawpad addMainVideoPen:[SDKFileUtil urlToFileString:sampleURL] filter:nil];
    
    
            // 增加一个UI图层, 把这个UI画板的位置和大小和画板对齐.
//            CGRect frame=CGRectMake(0, 60, size.width,size.width*(drawPadHeight/drawPadWidth));
//            doodleView = [[BlazeiceDooleView alloc] initWithFrame:frame];
//            doodleView.drawView.formPush = YES;//
//            [self.view addSubview:doodleView];
//            [drawpad addViewPen:doodleView fromUI:YES];
    
    
        CGRect frame=CGRectMake(0, 60, size.width,size.width*(drawPadHeight/drawPadWidth));
        label   = [[YXLabel alloc] initWithFrame:frame];
        label.text       = @"蓝松科技, 短视频处理";
        label.startScale = 0.3f;
        label.endScale   = 2.f;
        label.backedLabelColor = [UIColor redColor];
        label.colorLabelColor  = [UIColor cyanColor];
        label.font=[UIFont systemFontOfSize:30];
        [self.view addSubview:label];
        
        [drawpad addViewPen:label fromUI:YES];
    
   
    //step3: 第三步: 设置回调,开始运行画板.
    __weak typeof(self) weakSelf = self;
    [drawpad setOnProgressBlock:^(CGFloat currentPts) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.labProgress.text=[NSString stringWithFormat:@"当前进度 %f",currentPts];
            
           //  NSLog(@"当前处理进度是:%f\n",currentPts);
            
            if (currentPts>6) {
                [weakSelf stopDrawpad];
            }
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
    
    [label startAnimation];
    
    
    //把视频缩小一半,放在背景图上.
    operationPen.scaleWidth=0.5f;
    operationPen.scaleHeight=0.5f;
    
    
    //----一下是ui操作.
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
    labHint.text=@"演示 ViewPen[UI图层]  \n\n  把[视频图层] 和 [UI图层] 同时放到画板上.\n\n  这里用一个文字动画举例,实际可以是文字,线条,动画等您的UI界面.";
    [self.view addSubview: labHint];
    
    [labHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_labProgress.mas_bottom).offset(padding);
        make.centerX.mas_equalTo(filterView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(size.width, 200));
    }];
    

    

}

-(void)stopDrawpad
{
    [drawpad stopDrawPad];
}

- (void)slideChanged:(UISlider*)sender
{
    
    CGFloat val=[(UISlider *)sender value];
    CGFloat pos2=drawpad.drawpadSize.width*val;
    switch (sender.tag) {
        case 101:  //weizhi
            operationPen.positionX=pos2;
            
            //当宽度增加后, 也演示下高度的变化.
            if (operationPen.positionX > drawpad.drawpadSize.width/2) {
                
                operationPen.positionY+=10;
                if (operationPen.positionY>=drawpad.drawpadSize.height) {
                    operationPen.positionY=0;
                }
            }
            break;
        case 102:  //scale
            if (operationPen!=nil) {
                operationPen.scaleHeight=val;
                operationPen.scaleWidth=val;
            }
            break;
            
        case 103:  //rotate;
            if (operationPen!=nil) {
                operationPen.rotateDegree=val;
            }
            break;
            
        default:
            break;
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (drawpad!=nil) {
        [drawpad stopDrawPad];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    if([SDKFileUtil fileExist:dstPath]){
        [SDKFileUtil deleteFile:dstPath];
    }
    if([SDKFileUtil fileExist:dstTmpPath]){
        [SDKFileUtil deleteFile:dstTmpPath];
    }
    NSLog(@"ViewPenRealTimeDemo. dealloc");
}
-(void)addAudio
{
    if ([SDKFileUtil fileExist:dstTmpPath]) {
        [VideoEditor drawPadAddAudio:[SDKFileUtil urlToFileString:sampleURL] newMp4:dstTmpPath dstFile:dstPath];
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
