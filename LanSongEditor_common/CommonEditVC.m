//
//  VideoCommonEditVC.m
//  LanSongEditor_all
//
//  Created by sno on 2019/3/8.
//  Copyright © 2019 sno. All rights reserved.
//

#import "CommonEditVC.h"
#include "LSOFullWidthSwitchsView.h"
#import "LanSongUtils.h"
#import "BeautyManager.h"

/**
 视频的基本编辑;
 */
@interface CommonEditVC () <LSOFullWidthSwitchsViewDelegate>
{
    LSOVideoOneDo *videoOneDo;
    NSString *srcVideoPath;
    
    LSOFullWidthSwitchsView *scrollView;
    CGFloat videoWidth;
    CGFloat videoHeight;
    
    BOOL isAddText;
    BOOL isAddLogo;
    BOOL isExporting;
    BeautyManager *beautyMng;
}
@property(nonatomic) LSOProgressHUD *hud;

@end

@implementation CommonEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    [self createView];
    [self addRightBtn];
    self.title=@"视频编辑常见功能演示";
    
   srcVideoPath=[AppDelegate getInstance].currentEditVideo;
   videoOneDo=[[LSOVideoOneDo alloc] initWithNSURL:[LSOFileUtil filePathToURL:srcVideoPath]];
    if(videoOneDo==nil){
        [LanSongUtils showDialog:@"视频错误,请选择视频"];
    }
    videoWidth=videoOneDo.mediaInfo.width;
    videoHeight=videoOneDo.mediaInfo.height;
    isExporting=NO;
    _hud=[[LSOProgressHUD alloc] init];
}
-(void)createView
{
    scrollView=[LSOFullWidthSwitchsView new];
    [self.view  addSubview:scrollView];
    
    UILabel *label=[[UILabel alloc] init];
    label.text=@"各种参数均可修改.\n代码在VideoCommonEditVC.m中.";
    label.textColor=[UIColor whiteColor];
    label.numberOfLines=3;
    
    [self.view addSubview:label];
    
    
    CGSize size=self.view.frame.size;
    CGFloat padding=size.height*0.04;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.mas_equalTo(self.view.mas_top).offset(50);
        make.top.mas_equalTo(self.view.mas_top).with.offset(size.height*0.1);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(size.width, 50));
    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.top.mas_equalTo(label.mas_bottom).offset(padding);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    scrollView.delegateObj=self;
    [scrollView configureView:@[@"1.增加背景音乐+调节音量",@"2.裁剪时长",@"3.裁剪画面",@"4.缩放",@"5.增加Logo",@"6.增加文字",@"7.设置滤镜",@"8.设置码率(压缩)",@"9.增加美颜",@"10.增加封面"] width:self.view.frame.size.width];
}
- (void)addRightBtn {
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"导出" style:UIBarButtonItemStylePlain target:self action:@selector(exportVideo)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

-(void)exportVideo
{
    
    if(videoOneDo==nil){
        [LanSongUtils showDialog:@"视频错误,请选择视频"];
        return;
    }
    isAddLogo=NO;
    isAddText=NO;
    [videoOneDo resetAllValue];
    if(beautyMng!=nil){
        [beautyMng deleteBeauty:videoOneDo];
    }
    
    BOOL isOn=NO;
    for (int i=0; i<scrollView.uiswitchArray.count; i++) {
        UISwitch *uiswitch=(UISwitch *)[scrollView.uiswitchArray objectAtIndex:i];
        if(uiswitch.isOn){
            isOn=YES;
            switch (uiswitch.tag) {
                case 0:  //增加背景音乐
                    {
                        NSURL *audio1=[LSOFileUtil URLForResource:@"hongdou10s" withExtension:@"mp3"];
                        videoOneDo.videoUrlVolume=1.0f;
                        [videoOneDo addAudio:audio1 volume:3.0f loop:YES];
                    }
                    break;
                case 1:  //裁剪时长; 这里裁剪时长的2/3;
                    {
                        videoOneDo.cutStartTimeS=0;
                        videoOneDo.cutDurationTimeS=videoOneDo.mediaInfo.vDuration*2.0f/3.0f;
                    }
                    break;
                case 2:  //裁剪画面, 裁剪为原来的2/3;即从1/6处开始裁剪;
                    {
                        CGFloat x=videoOneDo.mediaInfo.width/6;
                        CGFloat y=videoOneDo.mediaInfo.height/6;
                        CGFloat width=videoOneDo.mediaInfo.width*2.0f/3.0f;
                        CGFloat height=videoOneDo.mediaInfo.height*2.0f/3.0f;
                        videoOneDo.cropRect=CGRectMake(x, y, width, height);
                        videoWidth=width;
                        videoHeight=height;
                    }
                    break;
                case 3: //4.缩放, 缩放1.5倍;
                    {
                        videoWidth*=1.5f;
                        videoHeight*=1.5f;
                        
                        //最大是1080P的视频
                        if(videoWidth>videoHeight){  //横屏;
                            if(videoWidth>1920)videoWidth=1920;
                            if(videoHeight>1088)videoHeight=1088;
                        }else{  //竖屏
                            if(videoHeight>1920)videoHeight=1920;
                            if(videoWidth>1088)videoWidth=1088;
                        }
                        
                        
                        videoOneDo.scaleSize=CGSizeMake(videoWidth,videoHeight);
                    }
                    break;
                case 4: //增加logo
                    isAddLogo=YES;
                    break;
                case 5:  //增加文字
                    isAddText=YES;
                    break;
                case 6:  //设置滤镜
                    {
                        LanSongFilter *filter=[[LanSongIF1977Filter alloc]init];
                        [videoOneDo setFilter:filter];
                    }
                    break;
                case 7:  //设置码率, 压缩;
                    {
                        videoOneDo.bitrate=[self getMinBitRate:videoWidth *videoHeight];
                    }
                    break;
                case 8:  //设置美颜;
                    {
                        beautyMng=[[BeautyManager alloc] init];
                        [beautyMng addBeautyWithVideoOneDo:videoOneDo];
                    }
                    break;
                case 9:  //增加封面
                    {
                        UIImage *image=[UIImage imageNamed:@"cover1"];
                        [videoOneDo setCoverPicture:image startTime:0 endTime:0.5f];
                    }
                    break;
                default:
                    return;
            }
        }
    }
    if(isOn==NO){
        [LanSongUtils showDialog:@"您至少选择一个功能来演示"];
        return ;
    }
    
    WS(weakSelf)
    [videoOneDo setUIView:[self addTextLogo]];  //增加这个UI图层;
    
    [videoOneDo setVideoProgressBlock:^(CGFloat currentFramePts, CGFloat percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LSOLog_d(@"currentFramePts: %f, percent:%f",currentFramePts,percent)
            [weakSelf.hud showProgress:[NSString stringWithFormat:@"进度:%f",percent]];
        });
    }];
    [videoOneDo setCompletionBlock:^(NSString * _Nonnull video) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.hud hide];
                [LanSongUtils startVideoPlayerVC:weakSelf.navigationController dstPath:video];
            });
    }];
    [videoOneDo start];
}
- (void)LSOFullWidthSwitchsViewSelected:(int)index isOn:(BOOL)isOn
{
    LSOLog_d(@"index is -----:%d, isOn:%d",index,isOn);
}
-(UIView *)addTextLogo
{
    if(!isAddLogo && !isAddText){
        return nil;
    }
        UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, videoWidth,videoHeight)];
        rootView.backgroundColor = [UIColor clearColor];
    
    if(isAddLogo){
        UIImage *image = [UIImage imageNamed:@"small"];
        UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
       [rootView addSubview:imageView];
    }
   
    if(isAddText){
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, videoWidth, 120)];
        label.text=@"杭州蓝松科技测试例子";
        label.font=[UIFont systemFontOfSize:50];
        label.textColor=[UIColor redColor];
        [rootView addSubview:label];
    }
    return rootView;
}

//视频码率建议值.
-(int) getMinBitRate:(int) wxh;
{
    if (wxh <= 480 * 480) {
        return (int)(1.0f*1024 * 1024);
    } else if (wxh <= 640 * 480) {
        return (int)(1.5f*1024 * 1024);
        
    } else if (wxh <= 800 * 480) {
        return (int)(1.8f*1024 * 1024);
    } else if (wxh <= 960 * 544) {
        return (int)(2.5f*1024 * 1024);
    } else if (wxh <= 1280 * 720) {
        return (int)(3.0f*1024 * 1024);
    } else if (wxh <= 1920 * 1080) {
        return (int)(3.5f * 1024 * 1024);
    } else {
        return (int)(3.8f*1024 * 1024);
    }
}
@end
