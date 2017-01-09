//
//  TestDemoVC.m
//  LanSongEditor_all
//
//  Created by sno on 16/12/3.
//  Copyright © 2016年 sno. All rights reserved.
//

#import "TestDemoVC.h"


#import "LanSongUtils.h"
#import "BlazeiceDooleView.h"

@interface TestDemoVC ()
{
    DrawPadDisplay *drawpad;
    
    NSString *dstPath;
    
    Pen *operationPen;  //当前操作的画笔
    
    
    CGFloat drawPadWidth;   //画板的宽度, 在画板运行前设置的固定值
    CGFloat drawPadHeight; //画板的高度,在画板运行前设置的固定值
    int     drawPadBitRate;  //画板的码率, 在画板运行前设置的固定值
    BOOL isadd;
}
@end

@implementation TestDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
    dstPath = [SDKFileUtil genFileNameWithSuffix:@"mp4"];
    if ([SDKFileUtil fileExist:dstPath]) {
        [SDKFileUtil deleteFile:dstPath];
    }
    dstPath = [SDKFileUtil genFileNameWithSuffix:@"mp4"];
    
    //step1:第一步: 创建画板(尺寸,码率,编码后的目标文件路径,增加一个预览view)
    drawPadWidth=480;
    drawPadHeight=480;
    drawPadBitRate=1000*1000;
    drawpad=[[DrawPadDisplay alloc] initWithWidth:drawPadWidth height:drawPadHeight bitrate:drawPadBitRate dstPath:dstPath];
    
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    DrawPadView *filterView=[[DrawPadView alloc] initWithFrame:CGRectMake(0, 60, size.width,size.width*(drawPadHeight/drawPadWidth))];
    filterView.backgroundColor=[UIColor blackColor];
    
    [self.view addSubview: filterView];
    [drawpad setDrawPadPreView:filterView];
    
    
    //第二步: 增加一些画笔,当然您也可以在画板开始后增加
//    UIImage *imag=[UIImage imageNamed:@"p640x1136"];
//    [drawpad addBitmapPen:imag];
    
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"ping20s" withExtension:@"mp4"];
    [drawpad addMainVideoPen:[SDKFileUtil urlToFileString:sampleURL] filter:nil];
    
    
      
    //第三步, 设置 进度回调,完成回调, 开始执行.
    __weak typeof(self) weakSelf = self;
    [drawpad setOnProgressBlock:^(CGFloat currentPts) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.labProgress.text=[NSString stringWithFormat:@"当前进度 %f",currentPts];
            if (currentPts>=20.0f) {
                [weakSelf stopDrawPad];
            }
        });
    }];
    
    //设置完成后的回调
    [drawpad setOnCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf showIsPlayDialog];
            
        });
    }];
    
    // 开始工作
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
    
    UIView *currslide=  [self createSlide:_labProgress min:0.0f max:1.0f value:0.5f tag:101 labText:@"X坐标:"];
    currslide=  [self createSlide:currslide min:0.0f max:1.0f value:0.5f tag:102 labText:@"Y坐标:"];
    currslide=          [self createSlide:currslide min:0.0f max:3.0f value:1.0f tag:103 labText:@"缩放:"];
    [self createSlide:currslide min:0.0f max:360.0f value:0 tag:104 labText:@"旋转:"];
    
}
-(void)stopDrawPad
{
    [drawpad stopDrawPad];
}
- (void)slideChanged:(UISlider*)sender
{
    
    CGFloat val=[(UISlider *)sender value];
    CGFloat posX=drawpad.drawpadSize.width*val;
    CGFloat posY=drawpad.drawpadSize.height*val;
    switch (sender.tag) {
        case 101:  //weizhi
            operationPen.positionX=posX;
            break;
        case 102:  //Y坐标
            operationPen.positionY=posY;
            break;
            
        case 103:  //scale
            if (operationPen!=nil) {
                operationPen.scaleHeight=val;
                operationPen.scaleWidth=val;
            }
            break;
            
        case 104:  //rotate;
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
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    [slidePos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(labPos.mas_centerY);
        make.left.mas_equalTo(labPos.mas_right);
        make.size.mas_equalTo(CGSizeMake(size.width-80, 15));
    }];
    return labPos;
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
