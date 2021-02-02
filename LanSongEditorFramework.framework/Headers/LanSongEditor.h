//
//  LanSongEditor.h
//  LanSongEditor
//
//  Created by sno on 16/8/3.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double LanSongEditorVersionNumber;

FOUNDATION_EXPORT const unsigned char LanSongEditorVersionString[];

/**
 当前此SDK的版本号.
 内部使用,请勿修改.
 */
#define  LANSONGEDITOR_VISION  "4.3.5"

#define  LANSONGEDITOR_BUILD_TIME  "20210125_1834"

//所有类的父类
#import <LanSongEditorFramework/LSOObject.h>


#import <LanSongEditorFramework/LSOCameraView.h>
#import <LanSongEditorFramework/LSOCamera.h>
#import <LanSongEditorFramework/LSOSegmentCamera.h>
#import <LanSongEditorFramework/LSOSegmentModule.h>


//aex的一些类---------------------------
#import <LanSongEditorFramework/LSOAexModule.h>
#import <LanSongEditorFramework/LSOAexImage.h>
#import <LanSongEditorFramework/LSOAexText.h>
#import <LanSongEditorFramework/LSOAexComposition.h>
#import <LanSongEditorFramework/LSOAexDisplayView.h>
#import <LanSongEditorFramework/LSOAexOption.h>


#import <LanSongEditorFramework/LSOLayer.h>
#import <LanSongEditorFramework/LSOAnimation.h>
#import <LanSongEditorFramework/LSOEffect.h>
#import <LanSongEditorFramework/LSOAudioLayer.h>

#import <LanSongEditorFramework/LSOConcatComposition.h>
#import <LanSongEditorFramework/LSODisplayView.h>
#import <LanSongEditorFramework/LanSongLog.h>


#import <LanSongEditorFramework/LSOCamLayer.h>




#import <LanSongEditorFramework/LSOVideoCompositionExecute.h>



//**********************一下类是老版本, 不再使用*****************************
#import <LanSongEditorFramework/LSOXAssetInfo.h>
#import <LanSongEditorFramework/LSOAsset.h>
#import <LanSongEditorFramework/LSOVideoAsset.h>
#import <LanSongEditorFramework/LSOBitmapAsset.h>
#import <LanSongEditorFramework/LSOVideoOption.h>
#import <LanSongEditorFramework/LSOAEVideoAsset.h>
#import <LanSongEditorFramework/LanSong.h>
#import <LanSongEditorFramework/DrawPadVideoPreview.h>
#import <LanSongEditorFramework/DrawPadVideoExecute.h>
#import <LanSongEditorFramework/DrawPadAllExecute.h>
#import <LanSongEditorFramework/DrawPadAEPreview.h>
#import <LanSongEditorFramework/DrawPadAEExecute.h>
#import <LanSongEditorFramework/LSOAeCompositionView.h>
#import <LanSongEditorFramework/BitmapPadPreview.h>
#import <LanSongEditorFramework/DrawPadCameraPreview.h>
#import <LanSongEditorFramework/BitmapPadExecute.h>
#import <LanSongEditorFramework/AudioPadExecute.h>
#import <LanSongEditorFramework/LanSongView2.h>
#import <LanSongEditorFramework/LSOPen.h>
#import <LanSongEditorFramework/LSOVideoPen.h>
#import <LanSongEditorFramework/LSOVideoPen2.h>
#import <LanSongEditorFramework/LSOVideoFramePen.h>
#import <LanSongEditorFramework/LSOVideoFramePen2.h>
#import <LanSongEditorFramework/LSOAeViewPen.h>
#import <LanSongEditorFramework/LSOMVPen.h>
#import <LanSongEditorFramework/LSOViewPen.h>
#import <LanSongEditorFramework/LSOBitmapPen.h>
#import <LanSongEditorFramework/LSOGifPen.h>
#import <LanSongEditorFramework/LSOAeCompositionPen.h>
#import <LanSongEditorFramework/LSOAeCompositionAsset.h>
#import <LanSongEditorFramework/LSOSubPen.h>
#import <LanSongEditorFramework/LanSong.h>
#import <LanSongEditorFramework/LSOExtractFrame.h>
#import <LanSongEditorFramework/LSOVideoDecoder.h>
#import <LanSongEditorFramework/LSOGetMVFrame.h>
#import <LanSongEditorFramework/LSOAudioRecorder.h>
#import <LanSongEditorFramework/LSOVideoOneDo.h>
#import <LanSongEditorFramework/DrawPadConcatVideoExecute.h>
#import <LanSongEditorFramework/AudioConcatExecute.h>
#import <LanSongEditorFramework/LSODrawPadPreview.h>
#import <LanSongEditorFramework/LSOFileUtil.h>
#import <LanSongEditorFramework/LSOImageUtil.h>
#import <LanSongEditorFramework/LSOAeView.h>
#import <LanSongEditorFramework/LSOAeImage.h>
#import <LanSongEditorFramework/LSOAeText.h>
#import <LanSongEditorFramework/LSOAEVideoSetting.h>
//#import <LanSongEditorFramework/LanSongTESTVC.h>

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

/*  获取当前sdk的key可升级制时间中的年份 */
+(int)getUpdateLimitedYear;

/*  获取当前sdk的key可升级制时间中的月份 */
+(int)getUpdateLimitedMonth;

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



/**
 设置内部文件创建在哪个文件夹下;
 
 如果不设置,默认在当前Document/lansongBox下;
 
 举例:
 NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
 NSString *documentsDirectory =[paths objectAtIndex:0];
 NSString *tmpDir = [documentsDirectory stringByAppendingString:@"/box2"];
 [LSOFileUtil setGenTempFileDir:tmpDir];
 
 建议在initSDK的时候设置;
 */
+(void)setTempFileDir:(NSString *)path;
/**
 我们的内部默认以当前时间为文件名; 比如:20180906094232_092.mp4
 你可以在这个时间前面增加一些字符串,比如增加用户名,手机型号等等;
 举例:
 prefix:xiaoming_iphone6s; 则生成的文件名是: xiaoming_iphone6s20180906094232_092.mp4
 @param prefix
 */
+(void)setTempFilePrefix:(NSString *)prefix;
/**
 设置在编码的时候, 编码成 编辑模式的视频;
 我们内部定义一种视频格式,命名为:编辑模式;
 这样的视频: 会极速的定位到指定的一帧;像翻书一样的翻看每一帧视频;
 
 @param as 是否为编辑模式. 默认不是编辑模式;
 */
+(void)setEncodeVideoAsEditMode:(BOOL)as;



@end
