//
//  LSOAexImage.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/7/1.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"
#import "LSOAexOption.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOAexImage : LSOObject

/**
 当前图片的ID号;(用不到)
 */
@property (nonatomic, readonly)NSString *imageId;
/**
 图片的宽度
 */
@property (nonatomic, readonly) CGFloat width;
/**
 图片的高度
 */
@property (nonatomic, readonly) CGFloat height;

/**
 这个图片的开始时间点
 */
@property (nonatomic, readonly) CGFloat startTimeS;

/**
 当前图片的显示时长;
 */
@property (nonatomic, readonly) CGFloat durationS;

//----------------------用户设置的--------------------------------------------

/**
 用url路径更新当前AE图片;
 url可以是视频,也可以是图片;
 option:选项, 缩放形式, 视频开始时间点;
 */
- (BOOL)updateWithURL:(NSURL *)url option:(LSOAexOption *_Nullable )option;


/**
 用UIImage图片对象, 更新当前AE图片;
 option: 选项, 缩放形式;
 */
- (BOOL)updateWithUIImage:(UIImage *)image option:(LSOAexOption *_Nullable )option;
/**
 用户设置的视频路径;
 */
@property (nonatomic, readonly) NSURL *userURL;

/**
 只是让你附带一帧缩略图对象, 内部没有代码, 也不使用;
 如果你要附带更多的参数,请用lsoTag对象;
 */
@property (nonatomic, readwrite) UIImage *thumbnailImage;

//------------获取缩略图
/**
 异步 获取缩略图;
 当前是每秒钟获取一帧;, 一帧宽高最大是100x100;
 image 是获取到的每一张缩略图;
 finish是 是否获取完毕;
 */
- (void)getThumbnailAsyncWithHandler:(void (^)(UIImage *image, BOOL finish))handler;



@end
NS_ASSUME_NONNULL_END
