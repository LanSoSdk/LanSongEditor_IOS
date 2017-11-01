//
//  MainViewController.m
//  LanSongEditor_all
//
//  Created by sno on 16/12/12.
//  Copyright © 2016年 sno. All rights reserved.
//

#import "MainViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "LanSongUtils.h"

#import "UIColor+Util.h"
#import "Masonry.h"
#import "FilterRealTimeDemoVC.h"

#import "ExecuteFilterDemoVC.h"
#import "CommDemoListTableVC.h"
#import "PictureSetsRealTimeVC.h"


#import "CameraPenDemoVC.h"
#import "CameraPenFullPortVC.h"
#import "CameraPenFullLandscapeVC.h"
#import "CameraPenSegmentRecordVC.h"


#import "ExtractVideoFrameVC.h"


#import "ViewPenRealTimeDemoVC.h"

#import "MVPenDemoRealTimeVC.h"
#import "MVPenOnlyVC.h"
#import "Demo1PenMothedVC.h"
#import "Demo2PenMothedVC.h"
#import "ViewPenOnlyVC.h"


#import "SegmentRecordSquareVC.h"
#import "SegmentRecordFullVC.h"
#import "SimpleVideoFileFilterViewController.h"


@interface MainViewController ()
{
    UIView  *container;
    NSString *videoPath; //当前要操作的文件.可能是选择的或默认的.
}
@end

#define kVideoFilterDemo 1
#define kVideoFilterBackGroudDemo 2
//移动缩放旋转演示
#define kDemo1PenMothed 3
#define kVideoUIDemo 4
#define kMorePictureDemo 5
#define kCommonEditDemo 6
#define kMVPenDemo 7
#define kDirectPlay 8

//分段录制正方形
#define kSegmentRecordSquare 9
//竖屏
#define kSegmentRecordFullPort 10
//横屏
#define kSegmentRecordFullLandscape 11
//分段录制
#define kSegmentRecordSegmentRecord 12

#define kDemo2PenMothed 13
#define kExtractVideoFrame 14


#define kUseDefaultVideo 801
#define kSelectVideo 802

@implementation MainViewController
{
    ExtractVideoFrame *extractFrame;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"[容器图层]---开发架构举例";
    
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];

    /*
     初始化SDK
     */
    if([LanSongEditor initSDK:NULL]==NO){
        [self showSDKOutTimeWarnning];
    }
    /*
     删除sdk中所有的临时文件.
     */
    [SDKFileUtil deleteAllSDKFiles];
    
  
    [self initView];
    [self testFile];
    
}
-(void)onClicked:(UIView *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    UIViewController *pushVC=nil;
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"ping20s" withExtension:@"mp4"];
    NSString *directPath=[SDKFileUtil urlToFileString:sampleURL];  //用在直接播放

    switch (sender.tag) {
        case kSegmentRecordSquare:
//            pushVC=[[ViewPenOnlyVC alloc] init];
            pushVC =[[CameraPenDemoVC alloc] init];
//              pushVC=[[SegmentRecordFullVC alloc] init];
            break;
        case kSegmentRecordFullPort:
            pushVC=[[CameraPenFullPortVC alloc] init];
            break;
        case kSegmentRecordFullLandscape:
            pushVC=[[CameraPenFullLandscapeVC alloc] init];  //横屏
            break;
        case kSegmentRecordSegmentRecord:
            pushVC=[[CameraPenSegmentRecordVC alloc] init];  //分段录制.
            break;
        case kVideoUIDemo:
            pushVC=[[ViewPenRealTimeDemoVC alloc] init];  //视频+UI图层.
            break;
        case kMVPenDemo:
            pushVC=[[MVPenDemoRealTimeVC alloc] init];  //MVPen演示, 增加一个mv图层.
            //     pushVC=[[MVPenOnlyVC alloc] init];
            break;
        case kMorePictureDemo:
            pushVC=[[PictureSetsRealTimeVC alloc] init]; //图片图层
            break;
        case kVideoFilterDemo:
            pushVC=[[FilterRealTimeDemoVC alloc] init];  //滤镜
            break;
        case kDemo1PenMothed:
            pushVC=[[Demo1PenMothedVC alloc] init];  //移动缩放旋转1
            break;
        case kDemo2PenMothed:
            pushVC=[[Demo2PenMothedVC alloc] init];  //移动缩放旋转2
            break;
        case kExtractVideoFrame:
            pushVC=[[ExtractVideoFrameVC alloc] init];
            break;
        case kVideoFilterBackGroudDemo:
            pushVC=[[ExecuteFilterDemoVC alloc] init];  //后台滤镜
            ((ExecuteFilterDemoVC *)pushVC).isAddUIPen=NO;
            break;
        case kCommonEditDemo:
            pushVC=[[CommDemoListTableVC alloc] init];  //普通功能演示
            break;
        case kDirectPlay:
               [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:directPath];
            break;
        default:
            break;
    }
    
    if (pushVC!=nil) {
        [self.navigationController pushViewController:pushVC animated:YES];
    }
}
-(void)initView
{
    UIScrollView *scrollView = [UIScrollView new];
    [self.view  addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    container = [UIView new];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
//    UIView *view=[self newDefaultButton:container];//时间关系, 调试好了,但暂时不用
    UIView *view=[self newButton:container index:kSegmentRecordSquare hint:@"分段录制(正方形)"];
    view=[self newButton:view index:kSegmentRecordFullPort hint:@"竖屏录制 (摄像头图层)"];
    view=[self newButton:view index:kSegmentRecordFullLandscape hint:@"横屏录制 (摄像头图层)"];
    view=[self newButton:view index:kSegmentRecordSegmentRecord hint:@"分段录制 (摄像头图层)"];
    
    view=[self newButton:view index:kVideoUIDemo hint:@"UI图层"];
    view=[self newButton:view index:kMVPenDemo hint:@"MV图层"];
    view=[self newButton:view index:kMorePictureDemo hint:@"照片影集"];
    view=[self newButton:view index:kDemo1PenMothed hint:@"所有图层均支持的父类功能1"];
    view=[self newButton:view index:kDemo2PenMothed hint:@"所有图层均支持的父类功能2"];
    view=[self newButton:view index:kVideoFilterDemo hint:@"所有图层均支持的父类功能3(滤镜)"];
    view=[self newButton:view index:kExtractVideoFrame hint:@"提取视频帧"];
    view=[self newButton:view index:kVideoFilterBackGroudDemo hint:@"后台容器(视频图层+滤镜+CALayer图层)"];
    view=[self newButton:view index:kCommonEditDemo hint:@"视频基本编辑>>>"];
    view=[self newButton:view index:kDirectPlay hint:@"直接播放视频"];
    
    
    UILabel *versionHint=[[UILabel alloc] init];
    //自动折行设置
    //  notUse.lineBreakMode = UILineBreakModeWordWrap;
    versionHint.numberOfLines=0;
    NSString *available=[NSString stringWithFormat:@"当前版本:%@, 到期时间是:%d 年 %d 月之前.欢迎联系我们: QQ:1852600324; email:support@lansongtech.com",
                         [LanSongEditor getVersion],
                         [LanSongEditor getLimitedYear],
                         [LanSongEditor getLimitedMonth]];
    
    versionHint.text=available;
    versionHint.textColor=[UIColor whiteColor];
    versionHint.backgroundColor=[UIColor redColor];
    [container addSubview:versionHint];
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.03;
    
    
    [versionHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(container.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width, 150));
    }];
    //
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(versionHint.mas_bottom).with.offset(40);
    }];
}
-(UIButton *)newDefaultButton:(UIView *)topView
{
    UIButton *btn1=[[UIButton alloc] init];
    btn1.tag=kUseDefaultVideo;
    
    [btn1 setTitle:@"使用默认视频" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn1.backgroundColor=[UIColor greenColor];
    
    [btn1 addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:btn1];
    
    
    
    UIButton *btn2=[[UIButton alloc] init];
    btn2.tag=kSelectVideo;
    
    [btn2 setTitle:@"文件夹" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn2.backgroundColor=[UIColor yellowColor];
    
    [btn2 addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [container addSubview:btn2];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.04;
    
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(container.mas_top).with.offset(padding);
            make.left.mas_equalTo(container.mas_left);
            make.size.mas_equalTo(CGSizeMake(size.width*0.7f-20, 50));  //按钮的高度.
        }];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(container.mas_top).with.offset(padding);
        make.left.mas_equalTo(size.width*0.7f);
        make.size.mas_equalTo(CGSizeMake(size.width*0.25f, 50));  //按钮的高度.
    }];
    return btn2;
}
-(UIButton *)newButton:(UIView *)topView index:(int)index hint:(NSString *)hint
{
    UIButton *btn=[[UIButton alloc] init];
    btn.tag=index;
    
    [btn setTitle:hint forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     btn.backgroundColor=[UIColor whiteColor];
    
    [btn addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    
    [container addSubview:btn];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.04;
    
    if (topView==container) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(container.mas_top).with.offset(padding);
            make.left.mas_equalTo(container.mas_left);
            make.size.mas_equalTo(CGSizeMake(size.width, 50));  //按钮的高度.
        }];
    }else{
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).with.offset(padding);
            make.left.mas_equalTo(container.mas_left);
            make.size.mas_equalTo(CGSizeMake(size.width, 50));
        }];
    }
    return btn;
}
-(void)btnDown:(UIView *)sender
{
    sender.backgroundColor=[UIColor grayColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//是否自动旋转,返回YES可以自动旋转
- (BOOL)shouldAutorotate {
    return YES;
}
//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
    
}
-(void) viewDidAppear:(BOOL)animated
{
    [LanSongUtils setViewControllerPortrait];
}
-(void)showSDKOutTimeWarnning
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"SDK已经过期,请更新到最新的版本/或联系我们:" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
int  frameCount=0;

//-----------选择视频
/**
 选择视频.
 */
-(void)pickVideo
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    NSString *requiredMediaType1 = ( NSString *)kUTTypeMovie;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType1,nil];
    
    [picker setMediaTypes: arrMediaTypes];
    
    picker.delegate = (id)self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}
#pragma mark  imagePickterControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        //获取视频文件的url
        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
       videoPath=[SDKFileUtil urlToFileString:mediaURL];
        
        NSLog(@"拿到的是url文件:%@,, string is:%@",mediaURL,videoPath);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)testFile
{
}

@end
