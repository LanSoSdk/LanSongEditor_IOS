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

-(id)initWithPath:(NSString *)path;

-(id)initWithURL:(NSURL *)url;

@property (nonatomic,readonly) NSURL *videoURL;

@property (nonatomic,readonly) NSString *videoPath;

@property (nonatomic,readonly) CGSize videoSize;


///**
// 替换视频中的音频, 如原视频没有音频,等于直接增加音频;
//  [替换后, 视频中的音频将不存在]
// 全局函数.
// 如果你要分别设置原有音频和增加的音频的音量, 用AudioPadExecute.
//
// @param video 视频完整路径
// @param audio 音频完整路径
// @return 合并后的视频.
// */
//+(NSString *)videoReplaceAudio:(NSString *)video audio:(NSString *)audio;
//
//
///**
// 替换视频中的音频
// [替换后, 视频中的音频将不存在]
// 全局函数.
// 如果你要分别设置原有音频和增加的音频的音量, 用AudioPadExecute.
// @param video 视频完整路径
// @param audio 音频完整路径
// @param videoRange 截取视频的哪部分, 如果不截取,则设置为kCMTimeRangeZero
// @param audioRange 截取音频的哪部分; 建议音频和视频的长度一致; 不截取则设置为kCMTimeRangeZero
// @return 合并后的视频;
// */
//+(NSString *)videoReplaceAudio:(NSString *)video audio:(NSString *)audio videoRange:(CMTimeRange)videoRange audioRange:(CMTimeRange)audioRange;

@end

NS_ASSUME_NONNULL_END
