//
//  LanSongEditor.h
//  LanSongEditor
//
//  Created by sno on 16/8/3.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for LanSongEditor.
FOUNDATION_EXPORT double LanSongEditorVersionNumber;

//! Project version string for LanSongEditor.
FOUNDATION_EXPORT const unsigned char LanSongEditorVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <LanSongEditor/PublicHeader.h>


//**************************容器类(7个)***********************************
//视频预览容器
#import <LanSongEditorFramework/DrawPadVideoPreview.h>

//视频后台执行容器
#import <LanSongEditorFramework/DrawPadVideoExecute.h>

//AE模板的后台合成容器
#import <LanSongEditorFramework/DrawPadAEExecute.h>

//AE模板的前台预览容器
#import <LanSongEditorFramework/DrawPadAEPreview.h>

//录制视频容器:录制视频
#import <LanSongEditorFramework/DrawPadCameraPreview.h>

//图片容器: 给图片增加滤镜; 给多张图片增加滤镜;
#import <LanSongEditorFramework/BitmapPadExecute.h>

//音频容器:用来合成各种声音
#import <LanSongEditorFramework/AudioPadExecute.h>

//容器显示,集成UIView
#import <LanSongEditorFramework/LanSongView2.h>
//********************图层类(6个)*************************************

//图层的父类, 所有的xxxPen 集成这个父类;
#import <LanSongEditorFramework/Pen.h>

//视频图层, 用在前台预览容器中
#import <LanSongEditorFramework/VideoPen.h>
//视频图层, 用在后台容器中
#import <LanSongEditorFramework/VideoPen2.h>

//MV图层
#import <LanSongEditorFramework/MVPen.h>

//UI图层, 用来增加一些UIView到容器中
#import <LanSongEditorFramework/ViewPen.h>

//图片图层;
#import <LanSongEditorFramework/BitmapPen.h>

//子图层: 可做灵魂出窍等功能;
#import <LanSongEditorFramework/SubPen.h>
//******************************滤镜****************************************
//各种滤镜的头文件;
#import <LanSongEditorFramework/LanSong.h>
//***************************独立的音视频功能******************************
//Mp3 转AAC的类
#import <LanSongEditorFramework/LanSongMp3ToAAC.h>
//提取视频帧, 异步工作模式
#import <LanSongEditorFramework/LanSongExtractFrame.h>
//提取视频帧, 同步工作模式
#import <LanSongEditorFramework/LanSongVideoDecoder.h>

//提取MV视频帧, 同步工作模式
#import <LanSongEditorFramework/LanSongGetMVFrame.h>

//视频缩放, 支持任意视频分辨率的缩放
#import <LanSongEditorFramework/LanSongScaleExecute.h>

//视频倒序
#import <LanSongEditorFramework/LanSongVideoReverse.h>

//音频录制类
#import <LanSongEditorFramework/LanSongAudioRecorder.h>


//*************************辅助, 常见功能处理类**************************
//获取音视频的信息;
#import <LanSongEditorFramework/MediaInfo.h>

//列举了一些常见的视频编辑功能
#import <LanSongEditorFramework/VideoEditor.h>

//创建临时 处理文件的头文件
#import <LanSongEditorFramework/LanSongFileUtil.h>


//*************************杂项**************************

//我们用来测试代码的UIViewController
#import <LanSongEditorFramework/LanSongTESTVC.h>
//lottie的一些库文件
#import <LanSongEditorFramework/LOTValueDelegate.h>
#import <LanSongEditorFramework/LOTAnimatedControl.h>
#import <LanSongEditorFramework/LOTCacheProvider.h>
#import <LanSongEditorFramework/LOTKeypath.h>
#import <LanSongEditorFramework/LOTInterpolatorCallback.h>
#import <LanSongEditorFramework/LOTAnimatedSwitch.h>
#import <LanSongEditorFramework/LOTAnimationCache.h>
#import <LanSongEditorFramework/Lottie.h>
#import <LanSongEditorFramework/LOTComposition.h>
#import <LanSongEditorFramework/LOTAnimationTransitionController.h>
#import <LanSongEditorFramework/LOTAnimationView.h>
#import <LanSongEditorFramework/LOTAnimationView_Compat.h>
#import <LanSongEditorFramework/LOTValueCallback.h>
#import <LanSongEditorFramework/LOTBlockCallback.h>
#import <LanSongEditorFramework/LanSongLOTInfo.h>






@interface LanSongEditor : NSObject

/**
  获取当前sdk的限制时间中的年份.
 */
+(int)getLimitedYear;

/**
 获取当前sdk的限制时间中的月份

 @return
 */
+(int)getLimitedMonth;

/**
 返回当前sdk的版本号.

 @return
 */
+(NSString *)getVersion;
/**
 初始化sdk,

 @return
 */
+(BOOL)initSDK:(NSString *)name;

/**
 使用完毕sdk后, 注销sdk, 
 (当前内部执行为空,可以不调用. 仅预留)
 */
+(void)unInitSDK;

@end
