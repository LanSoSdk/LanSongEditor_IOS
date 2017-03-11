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


@interface PictureSetsRealTimeVC ()
{
    int frameCount;
    
    DrawPadDisplay *drawpad;
    NSTimer * timer;
    NSString *dstPath;
    NSString *dstTmpPath;
    
    Pen *operationPen;  //当前操作的图层
    
    
    CGFloat drawPadWidth;   //画板的宽度, 在画板运行前设置的固定值
    CGFloat drawPadHeight; //画板的高度,在画板运行前设置的固定值
    int     drawPadBitRate;  //画板的码率, 在画板运行前设置的固定值
    BOOL isadd;
    
}
@end

@implementation PictureSetsRealTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
    dstPath = [SDKFileUtil genFileNameWithSuffix:@"mp4"];
    dstTmpPath= [SDKFileUtil genFileNameWithSuffix:@"mp4"];
    //step1:第一步: 创建一个画板,并增加编码保存路径
    drawPadWidth=480;
    drawPadHeight=480;
    drawPadBitRate=1000*1000;
    drawpad=[[DrawPadDisplay alloc] initWithWidth:drawPadWidth height:drawPadHeight bitrate:drawPadBitRate dstPath:dstTmpPath];
    
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    //step2:第二步:  增加一个View用来预览显示.暂时采用宽度为固定值,来调整高度,如果您的视频是竖的, 则应该固定高度来调整宽度. 或者设置一个正方形
    DrawPadView *filterView=[[DrawPadView alloc] initWithFrame:CGRectMake(0, 60, size.width,size.width*(drawPadHeight/drawPadWidth))];
    
    [self.view addSubview: filterView];
    [drawpad setDrawPadPreView:filterView];
    
    
    //step3: 增加两个图层.一个大的做背景,一个小的用来调节.
    UIImage *imag=[UIImage imageNamed:@"p640x1136"];
    [drawpad addBitmapPen:imag];
    
    UIImage *image=[UIImage imageNamed:@"mm"];
    operationPen=[drawpad addBitmapPen:image];
    
    
    //设置进度回调.
    __weak typeof(self) weakSelf = self;
    [drawpad setOnProgressBlock:^(CGFloat currentPts) {
        dispatch_async(dispatch_get_main_queue(), ^{
              NSLog(@"当前处理的进度是:%f",currentPts);
            
            weakSelf.labProgress.text=[NSString stringWithFormat:@"当前进度 %f",currentPts];
            //在15秒的时候结束.
            if (currentPts>=8.0f) {
                [weakSelf stopDrawPad];
            }
//            else if(currentPts>10.0f){  //可以用来演示在进度进行中,删除一个图层, 然后再增加一个图层.
//                [weakSelf addBitmapPen];
//            }else if(currentPts>5.0f){
//                [weakSelf removeBitmapPen];
//            }
            
        });
    }];
    
    //设置完成后的回调
    [drawpad setOnCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf addAudio];
            [weakSelf showIsPlayDialog];
            
        });
    }];
    
    //step4: 设置画板自动刷新,并开始工作
    [drawpad setUpdateMode:kAutoTimerUpdate autoFps:25];
    [drawpad startDrawPad];
    

    //----一下是ui操作.
    _labProgress=[[UILabel alloc] init];
    _labProgress.textColor=[UIColor redColor];
    
    [self.view addSubview:_labProgress];
    
    [_labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(filterView.mas_bottom).offset(padding);
        make.centerX.mas_equalTo(filterView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
    
    UIView *currslide=  [self createSlide:_labProgress min:0.0f max:1.0f value:0.5f tag:101 labText:@"XY:"];
    currslide=          [self createSlide:currslide min:0.0f max:3.0f value:1.0f tag:102 labText:@"缩放:"];
                        [self createSlide:currslide min:0.0f max:360.0f value:0 tag:103 labText:@"旋转:"];
}

-(void)stopDrawPad
{
    [drawpad stopDrawPad];
}
-(void)addBitmapPen
{
    if (drawpad!=nil && isadd==NO) {
        isadd=YES;
        UIImage *image=[UIImage imageNamed:@"mm"];
        operationPen=[drawpad addBitmapPen:image];
        [LanSongUtils showHUDToast:@"演示再次增加一个图层"];
    }
}
-(void)removeBitmapPen
{
    if (drawpad!=nil && operationPen!=nil) {
        [drawpad removePen:operationPen];
        operationPen=nil;
        [LanSongUtils showHUDToast:@"演示删除一个图层"];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
  初始化一个slide
 */
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
    CGFloat padding=size.height*0.01;
    
    [self.view addSubview:labPos];
    [self.view addSubview:slidePos];
    
    
    [labPos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(parentView.mas_bottom).offset(padding);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [slidePos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(labPos.mas_centerY);
        make.left.mas_equalTo(labPos.mas_right);
        make.size.mas_equalTo(CGSizeMake(size.width-50, 15));
    }];
    return labPos;
}
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

-(void)viewDidDisappear:(BOOL)animated
{
    if (drawpad!=nil) {
        [drawpad stopDrawPad];
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
