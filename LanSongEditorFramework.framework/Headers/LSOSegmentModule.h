//
//  LSOSegmentModule.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/10/22.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOSegmentModule : LSOObject

/**
 增加背景图片
 [可选],
 背景视频和图片不可同时设置, 如设置以视频为准;
 */
@property(nonatomic,readwrite) UIImage *bgImage;

/**
 背景视频
 [可选]
 */
@property(nonatomic,readwrite) NSURL *bgVideoUrl;


/**
 前景视频
 [可选]
 前景视频和图片不可同时设置, 如设置以视频为准;
 */
- (void)setMVWithColorUrl:(NSURL *)colorUrl maskUrl:(NSURL *)maskUrl;

/**
 前景图片
 [可选]
 */
@property(nonatomic,readwrite) UIImage *fgImage;

/**
 设置时长;
 [可选]
 */
@property(nonatomic,assign) float durationS;


/**
 设置声音
 [可选]
 */
@property(nonatomic,readwrite) NSURL *bgAudioUrl;


@property(nonatomic,readonly) NSURL *fgMvColorUrl;
@property(nonatomic,readonly) NSURL *fgMvMaskUrl;

@end

NS_ASSUME_NONNULL_END
