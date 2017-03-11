//
//  MainViewController.m
//  LanSongEditor_all
//
//  Created by sno on 16/12/12.
//  Copyright © 2016年 sno. All rights reserved.
//

#import "MainViewController.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "FilterRealTimeDemoVC.h"

#import "ExecuteFilterDemoVC.h"
#import "CommDemoListTableVC.h"
#import "PictureSetsRealTimeVC.h"
#import "VideoPictureRealTimeVC.h"
#import "ViewPenRealTimeDemoVC.h"
#import "TestDemoVC.h"
#import "CameraPenDemoVC.h"
#import "MVPenDemoRealTimeVC.h"
#import "TestViewPen.h"


#import <LanSongEditorFramework/LanSongEditor.h>



@interface MainViewController ()
{
    UIView  *container;
    
}
@end

#define kVideoFilterDemo 1
#define kVideoFilterBackGroudDemo 2
#define kVideoPictureDemo 3
#define kVideoUIDemo 4
#define kMorePictureDemo 5
#define kCameraPenDemo 6
#define kCommonEditDemo 7
#define kMVPenDemo 8

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"[画板图层]---开发架构举例";
    
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    
    //这里仅仅是用来测试
//    [self performSelector:@selector(testAVDecoder:) withObject:nil afterDelay:1.0f];
    
    /*
     初始化SDK
     */
    [LanSongEditor initSDK:NULL];
    
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
    NSString *available=[NSString stringWithFormat:@"当前版本:%@, 到期时间是:%d 年 %d 月底之前.欢迎联系我们: QQ:1852600324; email:support@lansongtech.com",
                        [LanSongEditor getVersion],
                        [LanSongEditor getLimitedYear],
                         [LanSongEditor getLimitedMonth]];
    
    versionHint.text=available;
    versionHint.textColor=[UIColor whiteColor];
    versionHint.backgroundColor=[UIColor redColor];
 
    
    
    UIView *view=[self newButton:container index:kVideoFilterDemo hint:@"图层滤镜(前台)"];
    view=[self newButton:view index:kVideoFilterBackGroudDemo hint:@"图层滤镜(后台)"];
    view=[self newButton:view index:kVideoPictureDemo hint:@"图片图层 (BitmapPen)演示"];
    view=[self newButton:view index:kVideoUIDemo hint:@"UI图层 (ViewPen)演示"];
    view=[self newButton:view index:kMVPenDemo hint:@"MV图层  (MVPen)演示"];
    view=[self newButton:view index:kMorePictureDemo hint:@"多张图片 (BitmapPen)演示"];
    view=[self newButton:view index:kCameraPenDemo hint:@"摄像头 (CameraPen)图层"];
    view=[self newButton:view index:kCommonEditDemo hint:@"视频基本编辑>>>"];
  
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
    
//    [self showVersionDialog];
}
-(void)doButtonClicked:(UIView *)sender
{
    
    sender.backgroundColor=[UIColor whiteColor];
    UIViewController *pushVC=nil;
    
    switch (sender.tag) {
        case kVideoFilterDemo:
            pushVC=[[FilterRealTimeDemoVC alloc] init];  //滤镜
          //  pushVC =[[TestDemoVC alloc] init];
            break;
        case kVideoFilterBackGroudDemo:
            pushVC=[[ExecuteFilterDemoVC alloc] init];  //后台滤镜
            ((ExecuteFilterDemoVC *)pushVC).isAddUIPen=NO;
            break;
        case kVideoPictureDemo:
            pushVC=[[VideoPictureRealTimeVC alloc] init];  //视频图层和图片图层
            break;
        case kVideoUIDemo:
            pushVC=[[ViewPenRealTimeDemoVC alloc] init];  //视频+UI图层.
            break;
        case kMorePictureDemo:
            pushVC=[[PictureSetsRealTimeVC alloc] init]; //图片图层
            break;
        case kCameraPenDemo:
           // pushVC=[[CameraPenDemoVC alloc] init]; //摄像头图层演示
            break;
        case kCommonEditDemo:
            pushVC=[[CommDemoListTableVC alloc] init];  //普通功能演示
            break;
        case kMVPenDemo:
            //pushVC=[[TestViewPen alloc] init];
            pushVC=[[MVPenDemoRealTimeVC alloc] init];  //MVPen演示, 增加一个mv图层.
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
    
    [btn addTarget:self action:@selector(doButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    
    [container addSubview:btn];
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.03;
    
    if (topView==container) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(container.mas_top).with.offset(padding);
            make.left.mas_equalTo(container.mas_left);
            make.size.mas_equalTo(CGSizeMake(size.width, 40));
        }];
    }else{
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).with.offset(padding);
            make.left.mas_equalTo(container.mas_left);
            make.size.mas_equalTo(CGSizeMake(size.width, 40));
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


-(void)showVersionDialog
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"欢迎您评估我们的sdk,当前版本是:" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
///------------------------------------------------------测试视频解码器.
- (CGImageRef)imageRefFromBGRABytes:(unsigned char *)imageBytes imageSize:(CGSize)imageSize {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(imageBytes,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 8,
                                                 imageSize.width * 4,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return imageRef;
}
- (UIImage *)imageFromBRGABytes:(unsigned char *)imageBytes imageSize:(CGSize)imageSize {
    CGImageRef imageRef = [self imageRefFromBGRABytes:imageBytes imageSize:imageSize];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}
-(void)testAVDecoder:(id)sender
{
    
     NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"ping20s" withExtension:@"mp4"];
    
    NSString *filepath=[SDKFileUtil urlToFileString:sampleURL];
    
    
    MediaInfo *info=[[MediaInfo alloc] initWithPath:filepath];
    if ([info prepare] && [info hasVideo])
    {
        NSLog(@"开始自行.....");
        AVDecoder *decoder=[[AVDecoder alloc] initWithPath:filepath];
        
        int  *rgbOut=(int *)malloc(info.vWidth * info.vHeight*4);
        
        while (YES) {
            long pts=[decoder decodeOneFrame:-1 rgbOut:rgbOut];
            
            CGSize size=CGSizeMake(info.vWidth, info.vHeight);
            UIImage *imge=[self imageFromBRGABytes:(unsigned char *)rgbOut imageSize:size];
            
            if (imge==nil) {
                NSLog(@" imge  获取到的是null");
            }
            UIImageWriteToSavedPhotosAlbum(imge, nil, nil, nil);//然后将该图片保存到图片图
            
          //  sleep(1);
            
            NSLog(@"Test 发送到相册 AVdecoder current pts:%ld....",pts);
            if ([decoder isEnd]) {
                
                break;
            }
        }
        NSLog(@"Test  AVdecoder is end....");
        [decoder releaseDecoder];
        free(rgbOut);
    }
   
}

@end
