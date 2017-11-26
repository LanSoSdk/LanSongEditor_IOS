//
//  ViewPenOnlyVC.m
//  LanSongEditor_all
//
//  Created by sno on 2017/10/10.
//  Copyright © 2017年 sno. All rights reserved.
//

#import "ViewPenOnlyVC.h"

#import "LanSongUtils.h"
#import "BlazeiceDooleView.h"
#import "YXLabel.h"

@interface ViewPenOnlyVC ()
{
    DrawPadPreview *drawpad;
    
    NSString *dstPath;
    NSURL *sampleURL;
    Pen *operationPen;  //当前操作的图层
    
    
    CGFloat drawPadWidth;   //容器的宽度, 在容器运行前设置的固定值
    CGFloat drawPadHeight; //容器的高度,在容器运行前设置的固定值
    int     drawPadBitRate;  //容器的码率, 在容器运行前设置的固定值
    BOOL isadd;
    
    BlazeiceDooleView *doodleView;
    
    YXLabel *label;
    
}
@end
/**
 说明:  此ViewControlloer用来作为 蓝松科技工程师 调试代码所用, 建议不要作为参考.
 
 */
@implementation ViewPenOnlyVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    dstPath = [SDKFileUtil genFileNameWithSuffix:@"mp4"];
    if ([SDKFileUtil fileExist:dstPath]) {
        [SDKFileUtil deleteFile:dstPath];
    }
    dstPath = [SDKFileUtil genFileNameWithSuffix:@"mp4"];
    
    
    //step1:第一步: 创建一个容器(尺寸,码率,保存路径,预览界面)
    drawPadWidth=480;
    drawPadHeight=480;
    drawPadBitRate=1000*1000;

//    drawPadWidth=720;
//    drawPadHeight=1280;
//    drawPadBitRate=3000*1024;
    
//    drawPadWidth=960;
//    drawPadHeight=540;
//    drawPadBitRate=2000*1000;
    
    drawpad=[[DrawPadPreview alloc] initWithWidth:drawPadWidth height:drawPadHeight bitrate:drawPadBitRate dstPath:dstPath];
    
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    DrawPadView *filterView=[[DrawPadView alloc] initWithFrame:CGRectMake(0, 60, size.width,size.width*(drawPadHeight/drawPadWidth))];
    
    [self.view addSubview: filterView];
    [drawpad setDrawPadPreView:filterView];  //增加一个预览界面
    
    
    //step2第二步:增加图层(当然也可以在容器进行中增加)
    UIImage *imag=[UIImage imageNamed:@"p640x1136"];
    BitmapPen *pen=[drawpad addBitmapPen:imag];
    
    
    pen.scaleWidth=pen.drawPadSize.width/pen.penSize.width;
    
    pen.scaleHeight=pen.drawPadSize.height/pen.penSize.height;
    
    
    // 增加一个UI图层, 把这个UI容器的位置和大小和容器对齐.
    CGRect frame=CGRectMake(0, 60, size.width,size.width*(drawPadHeight/drawPadWidth));
    
    label   = [[YXLabel alloc] initWithFrame:frame];
    label.backgroundColor=[UIColor redColor];
    
    label.text       = @"蓝松科技, 短视频处理";
    label.startScale = 0.3f;
    label.endScale   = 2.f;
    label.backedLabelColor = [UIColor redColor];
    label.colorLabelColor  = [UIColor cyanColor];
    label.font=[UIFont systemFontOfSize:30];
    
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 50, 150, 50)];
    [btn setTitle:@"addXXXX2FILTER" forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor redColor];
    
    [label addSubview:btn];
    [self.view addSubview:label];
    
    ViewPen *viewPen=[drawpad addViewPen:label fromUI:YES];  //增加ViewPen到容器中,并拿到对象
    
    if(viewPen!=nil){
        [viewPen switchFilter:[[LanSongSepiaFilter alloc]init]];
    }
    
    //step3: 第三步: 设置回调,开始运行容器.
    __weak typeof(self) weakSelf = self;
    [drawpad setOnProgressBlock:^(CGFloat currentPts) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.labProgress.text=[NSString stringWithFormat:@"当前进度 %f",currentPts];
                        if (currentPts>6) {  //您可要在任意进度中停止DrawPad
                            [weakSelf stopDrawpad];
                        }
            
        });
    }];
    
    //设置完成后的回调
    [drawpad setOnCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showIsPlayDialog];
            
        });
    }];
    [drawpad setUpdateMode:kAutoTimerUpdate autoFps:25];
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
    labHint.text=@"演示 ViewPen[UI图层]  \n\n  把[视频图层] 和 [UI图层] 同时放到容器上.\n\n  这里用一个文字动画举例,实际可以是文字,线条,动画等您的UI界面.";
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
    
    [SDKFileUtil deleteFile:dstPath];
    NSLog(@"ViewPenRealTimeDemo. dealloc");
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
