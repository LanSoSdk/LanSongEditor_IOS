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




#import "ViewPenRealTimeDemoVC.h"

#import "MVPenDemoRealTimeVC.h"
#import "MVPenOnlyVC.h"
#import "Demo1PenMothedVC.h"
#import "Demo2PenMothedVC.h"

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


@implementation MainViewController
{
    ExtractVideoFrame *extractFrame;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"[画板图层]---开发架构举例";
    
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];

    /*
     初始化SDK
     */
    if([LanSongEditor initSDK:NULL]==NO){
        [self showSDKOutTimeWarnning];
    }
    
    [SDKFileUtil deleteAllSDKFiles];
    
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
 
    
    
    UIView *view=[self newButton:container index:kSegmentRecordSquare hint:@"分段录制(正方形)"];
    view=[self newButton:view index:kSegmentRecordFullPort hint:@"竖屏录制 (摄像头图层)"];
    view=[self newButton:view index:kSegmentRecordFullLandscape hint:@"横屏录制 (摄像头图层)"];
    view=[self newButton:view index:kSegmentRecordSegmentRecord hint:@"分段录制 (摄像头图层)"];
    
    view=[self newButton:view index:kVideoUIDemo hint:@"UI图层"];
    view=[self newButton:view index:kMVPenDemo hint:@"MV图层"];
    view=[self newButton:view index:kMorePictureDemo hint:@"照片影集"];
    view=[self newButton:view index:kVideoFilterDemo hint:@"图层滤镜(前台)"];
    view=[self newButton:view index:kDemo1PenMothed hint:@"父类图层功能1"];
    view=[self newButton:view index:kDemo2PenMothed hint:@"父类图层功能2"];
    view=[self newButton:view index:kVideoFilterBackGroudDemo hint:@"图层滤镜[后台]"];
    
    view=[self newButton:view index:kCommonEditDemo hint:@"视频基本编辑>>>"];
    view=[self newButton:view index:kDirectPlay hint:@"直接播放视频"];

  
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
            pushVC =[[CameraPenDemoVC alloc] init];
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
        case kVideoFilterBackGroudDemo:
            pushVC=[[ExecuteFilterDemoVC alloc] init];  //后台滤镜
            ((ExecuteFilterDemoVC *)pushVC).isAddUIPen=NO;
            break;
        case kCommonEditDemo:
            pushVC=[[CommDemoListTableVC alloc] init];  //普通功能演示
            break;
        case kDirectPlay:
            [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:videoPath];
             //  [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:directPath];
            break;
        default:
            break;
    }
    
    if (pushVC!=nil) {
        [self.navigationController pushViewController:pushVC animated:YES];
    }
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
    //打印出字典中的内容
    NSLog(@"get the media info: %@", info);
    //获取媒体类型
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    //判断是静态图像还是视频
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
    //NSString *assetPath = [[NSBundle mainBundle] pathForResource:@"ping20s" ofType:@"mp4"];
//    NSString *assetPath = [[NSBundle mainBundle] pathForResource:@"TEST_1080P_270DU" ofType:@"mp4"];
//    extractFrame=[[ExtractVideoFrame alloc] initWithPath:assetPath];
//    if(extractFrame!=nil){
//        [extractFrame setExtractProcessBlock:^(UIImage *img, CMTime frameTime) {
//            if(img==nil){
//                NSLog(@"img is nil");
//            }else{
//                NSLog(@"保存到相册中的图片是:%d, 当前时间戳是:%f", frameCount++, CMTimeGetSeconds(frameTime));
//                UIImageWriteToSavedPhotosAlbum(img, self,nil, nil);
//            }
//            if(frameCount>=50){  //时间到后, 停止;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [extractFrame stop];
//                });
//            }
//        }];
//        
//        [extractFrame setExtractCompletedBlock:^(ExtractVideoFrame *v){
//            NSLog(@"执行完成");
//        }];
//        
//        //[extractFrame start];
//        [extractFrame startWithSeek:CMTimeMake(2, 1)];  //从6秒开始;
//        
//    }
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
