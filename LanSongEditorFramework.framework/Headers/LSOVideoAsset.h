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
 视频大小
 */
@property (nonatomic,readonly) CGSize videoSize;


/**
  视频本身的宽度.
 显示的宽度;
 */
@property(readwrite, nonatomic) CGFloat width;


/**
 视频高度
 显示时的高度;
 */
@property(readwrite, nonatomic) CGFloat height;

/**
 视频时长,单位秒;
 */
@property(readwrite, nonatomic) CGFloat duration;

/**
 视频帧率, 一秒钟多少帧;
 */
@property(readwrite, nonatomic) CGFloat frameRate;

/**
 视频码率
 */
@property(readwrite, nonatomic) CGFloat bitrate ;

/**
视频在编码时的旋转角度;
 */
@property(nonatomic,readonly) int videoAngle;
/**
 是否有音频
 */
@property(readwrite, nonatomic) BOOL hasAudio;

/**
 第一帧的图片
 */
@property(nonatomic, readonly) UIImage *firstFrameImage;


@property(nonatomic, readonly) NSString *videoPath;
@property(nonatomic, readonly) NSString *videoName;
@property(nonatomic, readonly) NSString *videoSuffix;


@property(nonatomic, readonly) AVAsset *asset;


@end

NS_ASSUME_NONNULL_END
