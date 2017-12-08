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


#import <LanSongEditorFramework/MediaInfo.h>
#import <LanSongEditorFramework/VideoEditor.h>

#import <LanSongEditorFramework/SDKFileUtil.h>

#import <LanSongEditorFramework/LanSong.h>

#import <LanSongEditorFramework/DrawPadPreview.h>

#import <LanSongEditorFramework/DrawPadView.h>
#import <LanSongEditorFramework/DrawPadExecute.h>
#import <LanSongEditorFramework/Pen.h>
#import <LanSongEditorFramework/VideoPen.h>
#import <LanSongEditorFramework/MVPen.h>
#import <LanSongEditorFramework/ViewPen.h>
#import <LanSongEditorFramework/BitmapPen.h>
#import <LanSongEditorFramework/CameraPen.h>
#import <LanSongEditorFramework/Mp3ToAAC.h>
#import <LanSongEditorFramework/ExtractVideoFrame.h>
#import <LanSongEditorFramework/ScaleExecute.h>
#import <LanSongEditorFramework/LanSongAudioRecorder.h>
#import <LanSongEditorFramework/LanSongTESTVC.h>
#import <LanSongEditorFramework/BitmapPadExecute.h>

#import <LanSongEditorFramework/DrawPadCamera.h>

#import <LanSongEditorFramework/LanSongDebug.h>
//视频倒序
#import <LanSongEditorFramework/LanSongVideoReverse.h>


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
