//
//  LSOAexImage.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/7/1.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOAexImage : LSOObject


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
 用户设置的图片对象;
 */
@property (nonatomic, readwrite) UIImage *userImage;

/**
 用户设置的视频路径;
 */
@property (nonatomic, readwrite) NSURL *userVideoURL;

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
