//
//  LSOVlogAsset.h
//  LanSongEditorFramework
//
//  Created by sno on 2021/3/3.
//  Copyright © 2021 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"
#import "LSOVLogLayer.h"



NS_ASSUME_NONNULL_BEGIN

@interface LSOVLogAsset : LSOObject

/**
 当前图片的ID号;(用不到)
 */
@property (nonatomic, readonly)NSString *videoName;


/// 模板中的视频宽度
@property (nonatomic, readonly) CGFloat width;

/// 模板中的视频高度
@property (nonatomic, readonly) CGFloat height;


/// 模板中的视频开始时间
@property (nonatomic, readonly) CGFloat startTimeS;


/// 模板中的视频时长
@property (nonatomic, assign) CGFloat durationS;


-(void)getThumbnailAsyncWithHandler:(void (^)(UIImage *image, BOOL finish))handler;




/**
 当替换为视频的时候,视频开始裁剪的时间点;
 裁剪时长等于LSOAexImage的时长;
 图片不起作用;
 */
@property (nonatomic,assign) CGFloat videoCutStartTimeS;

/**
 缩放类型.
 当输入的画面和 LSOAexImage不一致时, 可设置缩放类型;
 图片和视频 均适用;
 */
@property (nonatomic,readwrite)  LSOScaleType scaleType;


/// 如果视频和模板中的宽度不一致,则设置背景的颜色;
@property (nullable, nonatomic,copy)  UIColor *backGourndColor;



//----------------------用户设置的--------------------------------------------

/**
 用url路径更新当前AE图片;
 url可以是视频,也可以是图片;
 option:选项, 缩放形式, 视频开始时间点;
 */
- (BOOL)updateWithURL:(NSURL *)url;

/**
 用UIImage图片对象, 更新当前AE图片;
 option: 选项, 缩放形式;
 */
- (BOOL)updateWithUIImage:(UIImage *)image;



/**
 在增加到VLogPlayer中后, 每个asset对应一个layer,从这里 获取;
 */
@property (nonatomic, weak) LSOVLogLayer *vlogLayer;
 

/**
 用户设置的视频路径;
 */
@property (nonatomic, readonly) NSURL *userURL;



/// 用户选择的是否是4k的视频;
@property (nonatomic, readonly) BOOL is4kVideo;






@end
NS_ASSUME_NONNULL_END
