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
#import "CameraFullPortVC.h"
#import "Demo1PenMothedVC.h"
#import "FilterVideoDemoVC.h"
#import "CameraSegmentRecordVC.h"

#import "GameVideoDemoVC.h"


#import "CommDemoListTableVC.h"
#import "AEModuleDemoVC.h"
#import "AEPreviewDemo.h"

#import "VideoEffectVC.h"


@interface MainViewController ()
{
    UIView  *container;
    UILabel *labPath; // 视频路径.
}
@end

#define kVideoFilterDemo 1
//移动缩放旋转演示
#define kDemo1PenMothed 3
#define kVideoUIDemo 4
#define kCommonEditDemo 6
#define kDirectPlay 8

//竖屏
#define kSegmentRecordFullPort 10
//分段录制
#define kSegmentRecordSegmentRecord 12

#define kDemo2PenMothed 13
#define kLanSongExtractFrame 14
#define kLikeDouYinDemo 15

#define kAEModuleDemo1 16
#define kAEModuleDemo2 17
#define kAEModuleDemo3 18


#define kAEPreviewDemo 19

#define kGameVideoDemo 20

#define kUseDefaultVideo 801
#define kSelectVideo 802

@implementation MainViewController
{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"蓝松短视频SDK";
    
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    /*
     初始化SDK
     */
    if([LanSongEditor initSDK:nil]==NO){
        [self showSDKOutTimeWarnning];
    }
    /*
     删除sdk中所有的临时文件.
     */
    [LanSongFileUtil deleteAllSDKFiles];
  
    [self initView];
    
}
/**
 点击后, 进去界面.
 */
-(void)onClicked:(UIView *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    UIViewController *pushVC=nil;
    
    if([self needCheckBox:sender]){
        //检查是否正常.
        if([LanSongFileUtil fileExist:[AppDelegate getInstance].currentEditVideo]==NO){
            [LanSongUtils showDialog:@"请选择默认视频 或 相册视频"];
            return ;
        }
    }
    switch (sender.tag) {
        case kUseDefaultVideo:
            {
                NSString *defaultVideo=@"dy_xialu2";
                NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:defaultVideo withExtension:@"mp4"];
                if(sampleURL!=nil){
                    labPath.text=[NSString stringWithFormat:@"使用默认视频:%@",defaultVideo];
                    [AppDelegate getInstance].currentEditVideo=[LanSongFileUtil urlToFileString:sampleURL];
                }else{
                    [LanSongUtils showDialog:@"选择默认视频  ERROR!!"];
                }
                sender.backgroundColor=[UIColor greenColor];
                break;
            }
        case kSelectVideo:
            [self pickVideo];
            sender.backgroundColor=[UIColor yellowColor];
            break;
        case kSegmentRecordFullPort:
            pushVC=[[CameraFullPortVC alloc] init];
            break;
        case kSegmentRecordSegmentRecord:
            pushVC=[[CameraSegmentRecordVC alloc] init];  //分段录制.
            break;
        case kDemo1PenMothed:
            pushVC=[[Demo1PenMothedVC alloc] init];  //移动缩放旋转1
            break;
        case kVideoFilterDemo:
            pushVC=[[FilterVideoDemoVC alloc] init];  //滤镜
            break;
        case kLikeDouYinDemo:
            pushVC=[[VideoEffectVC alloc] init];
            break;
        case kAEModuleDemo1:
            {
                AEModuleDemoVC *push1=[[AEModuleDemoVC alloc] init];
                push1.AeType=AEDEMO_AOBAMA;
                pushVC=push1;
            }
            break;
        case kAEModuleDemo2:
            {
                AEModuleDemoVC *push1=[[AEModuleDemoVC alloc] init];
                push1.AeType=AEDEMO_XIANZI;
                pushVC=push1;
            }
            break;
        case kAEModuleDemo3:
            {
                AEModuleDemoVC *push1=[[AEModuleDemoVC alloc] init];
                push1.AeType=AEDEMO_ZAO_AN;
                pushVC=push1;
            }
            break;
            
            case kAEPreviewDemo:
            {
                AEPreviewDemo *push1=[[AEPreviewDemo alloc] init];
                pushVC=push1;
            }
            break;
        case kCommonEditDemo:
            pushVC=[[CommDemoListTableVC alloc] init];  //普通功能演示
            break;
        case kDirectPlay:
            {
                 [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:[AppDelegate getInstance].currentEditVideo];
            }
            break;
        case kGameVideoDemo:
            pushVC=[[GameVideoDemoVC alloc] init];  //游戏录制类演示
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
    
    UIView *view=[self newDefaultButton:container];
    view=[self newButton:view index:kSegmentRecordFullPort hint:@"竖屏录制"];
    view=[self newButton:view index:kSegmentRecordSegmentRecord hint:@"分段录制"];
    view=[self newButton:view index:kDemo1PenMothed hint:@"图层---移动旋转缩放叠加"];
    view=[self newButton:view index:kVideoFilterDemo hint:@"滤镜---图层的方法"];
    view=[self newButton:view index:kLikeDouYinDemo hint:@"类似抖音效果"];
    view=[self newButton:view index:kAEModuleDemo1 hint:@"AE模板特效-1"];
    view=[self newButton:view index:kAEModuleDemo2 hint:@"AE模板特效-2"];
    view=[self newButton:view index:kAEModuleDemo3 hint:@"AE模板特效-3"];
    view=[self newButton:view index:kAEPreviewDemo hint:@"AE模板特效-预览"];
    
    view=[self newButton:view index:kGameVideoDemo hint:@"游戏视频录制类"];
    
    
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
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(versionHint.mas_bottom).with.offset(40);
    }];
}
-(BOOL)needCheckBox:(UIView *)sender
{
    return  sender.tag !=kUseDefaultVideo &&
    sender.tag!=kSelectVideo &&
    sender.tag!=kSegmentRecordFullPort &&
    sender.tag!=kSegmentRecordSegmentRecord;
}
-(UIView *)newDefaultButton:(UIView *)topView
{
    UIButton *btn1=[[UIButton alloc] init];
    btn1.tag=kUseDefaultVideo;
    
    [btn1 setTitle:@"使用默认视频" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn1.backgroundColor=[UIColor greenColor];
    
    [btn1 addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    [container addSubview:btn1];
    
    UIButton *btn2=[[UIButton alloc] init];
    btn2.tag=kSelectVideo;
    
    [btn2 setTitle:@"文件夹" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn2.backgroundColor=[UIColor yellowColor];
    
    [btn2 addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    
    [container addSubview:btn2];
    
    
    labPath=[[UILabel alloc] init];
    labPath.text=@"请选择视频文件.";
    labPath.textColor=[UIColor redColor];
    
    [container addSubview:labPath];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.04;
    
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(container.mas_top).with.offset(padding);
            make.left.mas_equalTo(container.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(size.width*0.7f-20, 50));  //按钮的高度.
    }];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(container.mas_top).with.offset(padding);
        make.left.mas_equalTo(size.width*0.7f);
        make.size.mas_equalTo(CGSizeMake(size.width*0.25f, 50));  //按钮的高度.
    }];
    
    [labPath mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn2.mas_bottom).with.offset(5);
        make.left.mas_equalTo(container.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(size.width, 30));  //按钮的高度.
    }];
    
    return labPath;
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
/**
 选择视频.
 */
-(void)pickVideo
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    NSString *requiredMediaType1 = ( NSString *)kUTTypeMovie;
    
    picker.sourceType =UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
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

/**
 得到 选择的视频
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        //获取视频文件的url
        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        if(mediaURL!=nil){
            labPath.text=[NSString stringWithFormat:@"选择的视频是:%@",[mediaURL lastPathComponent]];
            NSString *path=[LanSongFileUtil urlToFileString:mediaURL];
            [AppDelegate getInstance].currentEditVideo=path;
        }else{
            [LanSongUtils showHUDToast:@"导入视频错误, 系统相册返回nil"];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
