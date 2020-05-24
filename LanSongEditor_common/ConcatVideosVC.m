//
//  ConcatVideosVC.m
//  LanSongEditor_all
//
//  Created by sno on 2019/6/11.
//  Copyright © 2019 sno. All rights reserved.
//

#import "ConcatVideosVC.h"
#import "DemoUtils.h"


@interface ConcatVideosVC ()
{
    LSODrawPadPreview *videoPreview;
    LanSongView2 *lansongView;
    
    DrawPadConcatVideoExecute *videoExecute;
    NSMutableArray *videoArray;
    DemoProgressHUD *hud;
}
@end

@implementation ConcatVideosVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *video=[LSOFileUtil URLForResource:@"dy_xialu2" withExtension:@"mp4"];
    NSURL *video3=[LSOFileUtil URLForResource:@"replaceVideo1" withExtension:@"mp4"];
    
    videoArray=[[NSMutableArray alloc] init];
    [videoArray addObject:video3];  //最底部 迪拜
    [videoArray addObject:video];  //二女子
    
    
    LSOXAssetInfo *info=[[LSOXAssetInfo alloc] initWithURL: [videoArray objectAtIndex:0]];
    if([info prepare]){
        lansongView=[DemoUtils createLanSongView:self.view.frame.size drawpadSize:CGSizeMake(info.width, info.height)];
        [self.view addSubview:lansongView];
        
        //创建容器;
        [self createView];
        hud=[[DemoProgressHUD alloc] init];
    }else{
        [DemoUtils  showHUDToast:@"第一个视频为空, 返回"];
        [self.navigationController popViewControllerAnimated:NO];
    }
}
-(void)viewDidAppear:(BOOL)animated
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
    
    videoPreview=[[LSODrawPadPreview alloc] initWithURLArray:videoArray];
    [videoPreview setLanSongView:lansongView];
    [videoPreview start];
}
-(void)stopPreview
{
    if(videoPreview!=nil){
        [videoPreview stop];
        videoPreview=nil;
    }
}


-(void)createView
{
    UIBarButtonItem *barItemEdit=[[UIBarButtonItem alloc] initWithTitle:@"开始执行" style:UIBarButtonItemStyleDone target:self action:@selector(doButtonClicked:)];
    barItemEdit.tag=602;
    self.navigationItem.rightBarButtonItem = barItemEdit;
    
    
    UILabel *label=[[UILabel alloc] init];
    label.text=@"当前: 预览仅支持等比例的分辨率.\n 后台支持所有.";
    label.numberOfLines=3;
    label.textColor=[UIColor whiteColor];
    [self.view addSubview:label];
    
    CGSize size=self.view.frame.size;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lansongView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(size.width, 50));
    }];
}
-(void)doButtonClicked:(UIView *)sender
{
    if(sender.tag==602){  //后台执行
        [self exportVideo];
    }
}
/**
 显示后台进度
 */
-(void)showExportProgress:(CGFloat) percent
{
      [hud showProgress:[NSString stringWithFormat:@"进度:%f",percent]];
}
/**
 显示后台处理结果
 */
-(void)showExportCompleted:(NSString *)dstPath
{
    [hud hide];
    [DemoUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
}
-(void) exportVideo
{
    [self stopPreview];
    
    videoExecute=[[DrawPadConcatVideoExecute alloc] initWithURLArray:videoArray];
    
    WS(weakSelf);
    [videoExecute setProgressBlock:^(CGFloat progess,CGFloat percent) {
        NSLog(@"initWithURLArray  is :%f, percent:%f",progess,percent);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showExportProgress:percent];
        });
    }];
    
    //增加一个背景图片;
    LSOBitmapPen *pen=[videoExecute addBitmapPen:[UIImage imageNamed:@"t14.jpg"]];
    pen.fillScale=YES;
    [videoExecute setPenPosition:pen index:0];  //调整到最底层
    
    [videoExecute setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showExportCompleted:dstPath];
        });
    }];
    [videoExecute start];
}
@end
