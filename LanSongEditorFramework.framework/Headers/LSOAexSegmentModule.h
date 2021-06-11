//
//  LSOAexSegmentModule.h
//  LanSongEditorFramework
//
//  Created by sno on 2021/5/25.
//  Copyright © 2021 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LSOObject.h"
#import "LSOAexImage.h"
#import "LSOAexText.h"
#import "LSOFileUtil.h"


NS_ASSUME_NONNULL_BEGIN

@interface LSOAexSegmentModule : LSOObject

- (instancetype)initWithJsonPath:(NSString *)jsonPath;

/// 当前Ae模板的总时长;
@property (nonatomic,readonly) CGFloat durationS;


/// 当前AE模板的宽度和高度;
@property(nonatomic, readonly) CGSize size;

/// 图片数量;
@property (nonatomic,readonly) int imageCount;


/// 文字数量；
@property (nonatomic,readonly) int textCount;

/**
 里面有多少个图片
 每张图片的宽度和高度, 开始时间点, 时长;
 */
@property (nonatomic, readonly) NSMutableArray<LSOAexImage *> *aexImageArray;


@property (nonatomic, readonly) NSMutableArray<LSOAexText *> *aexTextArray;





/**
 增加AE模板的背景部分,
 在PC端设计的AE模板时, 有些模板的底部几个图层是不需要替换的,则导出为背景视频;
 */
- (BOOL)setBackGroundVideoWithUrl:(NSURL *)videoUrl;

/**
 增加替换图片的上层, 动画部分;
 透明动画, 在PC端统一导出为 两个视频, 一个彩色,一个黑白;
 */
-(BOOL)setMvWithColorURL:(NSURL *)colorUrl  maskURL:(NSURL *)maskUrl;

/**
 设置声音路径;
 */
-(BOOL)setAudioWithURL:(NSURL *)audioUrl;

/**
 获取 背景视频的路径;
 */
@property (nonatomic,readonly)NSURL *bgVideoUrl;

/**
获取 透明动画的路径
 是两个视频,一个是有颜色, 一个是黑白;
 */
@property (nonatomic,readonly)NSURL *mvColorUrl;


@property (nonatomic,readonly)NSURL *mvMaskUrl;


/**
  获取模板中的单独导出的声音
 */
@property (nonatomic,readonly)NSURL *audioUrl;


-(void)printJsonInfo;



@end

NS_ASSUME_NONNULL_END
