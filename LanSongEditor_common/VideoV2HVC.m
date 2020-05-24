//
//  VideoV2HVC.m
//  LanSongEditor_all
//
//  Created by sno on 2019/6/24.
//  Copyright © 2019 sno. All rights reserved.
//

#import "VideoV2HVC.h"

#import "DemoUtils.h"
#import "VideoPlayViewController.h"
#import "LSDrawView.h"

@interface VideoV2HVC ()
{
    DrawPadVideoPreview *drawpadPreview;
    
    LanSongView2 *lansongView;
    LSOBitmapPen *bmpPen;
    CGSize drawpadSize;
    LSOVideoPen *videoPen;
    
    UISlider *videoProgress;
}

@property (nonatomic,assign) NSString *dstPath;
@end

@implementation VideoV2HVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"展示图层基本方法";
    self.view.backgroundColor=[UIColor blackColor];
    
    
    
    //-------------以下是ui操作-----------------------
    CGSize size=self.view.frame.size;
    lansongView=[DemoUtils createLanSongView:size drawpadSize:CGSizeMake(720, 1280)];
    [self.view addSubview:lansongView];
    
    
    CGFloat padding=size.height*0.01;
    
    _labProgress=[[UILabel alloc] init];
    _labProgress.textColor=[UIColor redColor];
    [self.view addSubview:_labProgress];
    
    [_labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lansongView.mas_bottom).offset(padding);
        make.centerX.mas_equalTo(lansongView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(size.width, 40));
    }];
}
- (void)viewDidAppear:(BOOL)animated
{
    [self startPreview]; //开启预览
}
-(void)startPreview
{
    [self stopPreview];
    
    //创建容器
    NSString *video=[AppDelegate getInstance].currentEditVideoAsset.videoPath;
    drawpadPreview=[[DrawPadVideoPreview alloc] initWithPath:video drawPadSize:CGSizeMake(720, 1280)];
    drawpadSize=drawpadPreview.drawpadSize;
    
    //增加显示窗口
    [drawpadPreview addLanSongView:lansongView];
    
    __weak typeof(self) weakSelf = self;
    [drawpadPreview setProgressBlock:^(CGFloat progress) {
        [weakSelf progressBlock:progress];
    }];
    
    [drawpadPreview setCompletionBlock:^(NSString *path) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //LSDELETE
            NSString *original=[AppDelegate getInstance].currentEditVideoAsset.videoPath;
            NSString *dstPath=[LSOVideoAsset videoMergeAudio:path audio:original];
            [DemoUtils startVideoPlayerVC:weakSelf.navigationController dstPath:dstPath];
        });
    }];
    
    
    UIImage *image1=[UIImage imageNamed:@"bgPicture.jpg"];
    LSOBitmapPen *bitmapPen=[drawpadPreview addBitmapPen:image1];
    bitmapPen.fillScale=YES;
    
    videoPen=drawpadPreview.videoPen;
    videoPen.loopPlay=YES;
    
    [drawpadPreview setPenPosition:bitmapPen index:0];
    videoPen.scaleWH=videoPen.drawPadSize.width/videoPen.drawPadSize.height;
    
    
    [videoPen setVisibleRectWithX:0.0 endX:0.5 startY:0.0 endY:0.8];
    //开始执行,并编码
    [drawpadPreview start];
    
}
-(void)progressBlock:(CGFloat)progress
{
    if(videoProgress!=nil){
        videoProgress.value=progress/drawpadPreview.duration;
    }
}
-(void)stopPreview
{
    if (drawpadPreview!=nil) {
        [drawpadPreview cancel];
        drawpadPreview=nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated
{
    
    [self stopPreview];
}

-(void)dealloc
{
    [self stopPreview];
    bmpPen=nil;
    drawpadPreview=nil;
    videoPen=nil;
    lansongView=nil;
    NSLog(@"VideoV2HVC dealloc");
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


