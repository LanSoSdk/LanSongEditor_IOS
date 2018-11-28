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

@interface LSOVideoBody : NSObject

-(id)initWithPath:(NSString *)path;

-(id)initWithURL:(NSURL *)url;

@property (nonatomic,readonly) NSURL *videoURL;

@property (nonatomic,readonly) NSString *videoPath;

@property (nonatomic,readonly) CGSize videoSize;


/**
 替换视频中的音频, 如原视频没有音频,等于直接增加音频;
 全局函数.
 如果你要分别设置原有音频和增加的音频的音量, 用AudioPadExecute.

 @param video 视频完整路径
 @param audio 音频完整路径
 @return 合并后的视频.
 */
+(NSString *)videoReplaceAudio:(NSString *)video audio:(NSString *)audio;
@end

NS_ASSUME_NONNULL_END
