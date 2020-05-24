//
//  LSOVideoBody.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/11/23.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>


NS_ASSUME_NONNULL_BEGIN


/**
 视频资源类.
 管理一个视频路径,得到视频的宽高等信息;
 */
@interface LSOVideoAsset : NSObject


/// 全局方法
/// @param URL 视频路径;
+ (instancetype)assetWithURL:(NSURL *)URL;


-(id)initWithURL:(NSURL *)url;


/// 初始化
/// @param path 视频路径;
-(id)initWithPath:(NSString *)path;





//------------视频的常见属性;
@property (nonatomic,readonly) NSURL *videoURL;


/**
 视频显示的大小;
 */
@property (nonatomic,readonly) CGSize videoSize;


/**
 显示的宽度;
 */
@property(nonatomic,readonly) CGFloat width;


/**
 视频高度
 显示时的高度;
 */
@property(nonatomic,readonly) CGFloat height;

/**
 视频时长,单位秒;
 */
@property(nonatomic,readonly) CGFloat duration;

/**
 视频帧率, 一秒钟多少帧;
 */
@property(nonatomic,readonly) CGFloat frameRate;

/**
 视频码率
 */
@property(nonatomic,readonly) CGFloat bitrate ;

/**
视频在编码时的旋转角度;
 */
@property(nonatomic,readonly) int videoAngle;
/**
 是否有音频
 */
@property(nonatomic,readonly) BOOL hasAudio;


@property(nonatomic, readonly) NSString *videoPath;
@property(nonatomic, readonly) NSString *videoName;
@property(nonatomic, readonly) NSString *videoSuffix;

@property(nonatomic, readonly) AVURLAsset *asset;

//----------获取图片的功能
/**
获取 第一帧的图片
只读.
*/
@property(nonatomic, readonly) UIImage *firstFrameImage;


typedef void (^getThunbnailUIImageHandler)(UIImage *image);

/**
 是否是竖屏视频;
 */
@property (nonatomic,readonly) BOOL isPortraitVideo;

/// 获取20张图片
/// @param uiImageHandler 异步获取后的回调;
-(void)getThunbnailUIImageAsynchronously:(getThunbnailUIImageHandler)uiImageHandler;


/// 读取多张缩略图
/// @param count  要读取的张数,最大20张;
/// @param uiImageHandler 异步返回的回调;
-(void)getThunbnailUIImageAsynchronously:(int)count uiimageHandler:(getThunbnailUIImageHandler)uiImageHandler;


/// 视频和声音混合, 混合成功返回YES,失败返回NO
/// @param video  要混合的视频
/// @param audio 要混合的声音
/// @param dstPath 混合后的目标视频
+(BOOL)videoMergeAudio:(NSString *)video audio:(NSString *)audio dstPath:(NSString *)dstPath;


/// 视频和声音混合, 混合成功返回新的视频文件完整路径, 失败返回输入的视频路径;
/// @param video 要混合的视频路径
/// @param audio 要混合的声音路径
+(NSString *)videoMergeAudio:(NSString *)video audio:(NSString *)audio;


/// 获取视频的第一帧
/// @param url 内部会缩放处理, 最大的尺寸是640x640
+ (UIImage *)getVideoImageimageWithURL:(NSURL *)url;

    
/*****************一下是内部使用***********************************/
-(id)getSlice1;
-(void)startCacheframe;
@end

NS_ASSUME_NONNULL_END
