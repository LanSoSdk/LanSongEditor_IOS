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
#import "LSOSegmentVideo.h"


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



/**
 替换分割后的图片
 用 LSOSegmentOneFrame得到的图片;
 */
- (BOOL)updateWithSegmentUIImage:(UIImage *)image option:(LSOAexOption *_Nullable )option;


/**
 替换分割后的视频;
 */
- (BOOL)updateWithSegmentVideo:(LSOSegmentVideo *)segmentVideo option:(LSOAexOption *_Nullable )option;


/**
 替换普通的图片或视频.
 */

- (BOOL)updateWithURL:(NSURL *)url option:(LSOAexOption *_Nullable )option;

/**
 替换图片
 */
- (BOOL)updateWithUIImage:(UIImage *)image option:(LSOAexOption *_Nullable )option;



/// 设置裁剪缩放大小
/// @param size 把设置的图片(视频)缩放到的宽高, 比如图片原来是1080x1920; 通过手指缩放到720x1280, 则这里输入720x1280;
/// @param point json的图片宽高为四方形区域, 替换后的图片(视频)的中心点在这个四方形区域的什么位置;
- (void)setScaleSize:(CGSize)size  centerPoint:(CGPoint)point;

/**
 缩放类型;
 */
@property (nonatomic,assign)  LSOScaleType scaleType;

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
