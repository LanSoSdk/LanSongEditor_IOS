//
//  MVPenOnlyVC.m
//  LanSongEditor_all
//
//  Created by sno on 17/3/23.
//  Copyright © 2017年 sno. All rights reserved.
//

#import "MVPenOnlyVC.h"

#import "LanSongUtils.h"
#import "BlazeiceDooleView.h"

@interface MVPenOnlyVC ()
{
    DrawPadDisplay *drawpad;
}
@end

@implementation MVPenOnlyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"演示单独MV图层.";
    

    CGSize size=self.view.frame.size;
    CGFloat     drawPadWidth=480;
    CGFloat     drawPadHeight=480;
    
    
    _labProgress=[[UILabel alloc] initWithFrame:CGRectMake(0, 60, size.width,size.width*(drawPadHeight/drawPadWidth))];
    _labProgress.textColor=[UIColor redColor];
    _labProgress.font=[UIFont systemFontOfSize:50.0f];
    [self.view addSubview:_labProgress];

    
   
    UIView *view=[self createMVView];
    [self.view addSubview:view];
    
    // 开始工作
    [drawpad startDrawPad];
}
-(void)stopDrawPad
{
    [drawpad stopDrawPad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 创建一个画板.
 原理是: 在画板里只放 mv图层, 把画板设置为透明即可.
 @return
 */
-(DrawPadView *)createMVView
{
    CGFloat     drawPadWidth=480;
    CGFloat     drawPadHeight=480;
    
    CGSize size=self.view.frame.size;
    DrawPadView *mvView=[[DrawPadView alloc] initWithFrame:CGRectMake(0, 60, size.width,size.width*(drawPadHeight/drawPadWidth))];
    mvView.backgroundColor=[UIColor clearColor]; //显示层也设置为透明

    //创建一个画板, 不设置路径,即不实时录制视频.
    drawpad=[[DrawPadDisplay alloc] initWithWidth:drawPadWidth height:drawPadHeight bitrate:0 dstPath:nil];
    [drawpad setDrawPadPreView:mvView];
    
    [drawpad setBackgroundColorRed:0 green:0 blue:0 alpha:0];  //背景设置为透明
    [drawpad setUpdateMode:kAutoTimerUpdate autoFps:25];  //设置为自动刷新.
    
    
    //增加一个mv图层.
    NSURL *colorPath = [[NSBundle mainBundle] URLForResource:@"mei" withExtension:@"mp4"];
    NSURL *maskPath = [[NSBundle mainBundle] URLForResource:@"mei_b" withExtension:@"mp4"];
    MVPen *mvpen=[drawpad addMVPen:[SDKFileUtil urlToFileString:colorPath] maskPath:[SDKFileUtil urlToFileString:maskPath] filter:nil];
    //mvpen.mvMode=kMVMode_LastFrame; //默认模式是循环.
    //mvpen.mvMode=kMVMode_Hide;
    
    __weak typeof(self) weakSelf = self;
    [drawpad setOnProgressBlock:^(CGFloat currentPts) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.labProgress.text=[NSString stringWithFormat:@"当前进度 %f",currentPts];
            if (currentPts>100.0f) {
                [weakSelf stopDrawPad];
            }
        });
    }];

    return mvView;
    
}
/**
 初始化一个slide
 */
-(UIView *)createSlide:(UIView *)parentView  min:(CGFloat)min max:(CGFloat)max  value:(CGFloat)value tag:(int)tag labText:(NSString *)text;

{
    UILabel *labPos=[[UILabel alloc] init];
    labPos.text=text;
    
   
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.01;
    
    [self.view addSubview:labPos];
    
    
    [labPos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(parentView.mas_bottom).offset(padding);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    return labPos;
}
-(void)viewDidDisappear:(BOOL)animated
{
    if (drawpad!=nil) {
        [drawpad stopDrawPad];
    }
}
-(void)dealloc
{
    drawpad=nil;
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

