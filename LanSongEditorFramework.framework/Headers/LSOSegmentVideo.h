//
//  LSOSegmentTest.h
//  LanSongEditorFramework
//
//  Created by sno on 2021/2/26.
//  Copyright © 2021 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOCamLayer.h"
#import "LSOXAssetInfo.h"


NS_ASSUME_NONNULL_BEGIN


/// ai智能视频抠像类
@interface LSOSegmentVideo : LSOCamLayer




/// 获取支持的最大时长;
+ (CGFloat )supportMaxDuration;

- (instancetype)initWithURL:(NSURL *)url;


/// 设置裁剪时间, 在start开始前设置;
/// @param startTime 开始时间
/// @param endTime 结束时间
- (void)setCurDurationStartTime:(CGFloat)startTime endTime:(CGFloat)endTime;


/// 开始分割
- (void)start;


/// 是否在分割中;
@property (nonatomic, readonly) BOOL segmenting;


/// 输出的分辨率
@property (nonatomic, readonly) CGSize outputSize;


/// 总的时长;
@property (nonatomic, readonly) CGFloat durationS;

/**
 导出进度回调;
 在异步线程执行此block; 请用一下代码后调用;
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^segmentProgressBlock)(CGFloat progress,CGFloat percent);


/**
 在异步线程执行此block; 请用一下代码后调用;
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^segmentCompletionBlock)(void);

@property(nonatomic, readonly) NSURL *videoUrl;


@property(nonatomic, readonly)LSOXAssetInfo *assetInfo;

- (BOOL)getFrame:(unsigned char *)rgbaPtr atTime:(CGFloat)time;

- (void)releaseLSO;

@end

NS_ASSUME_NONNULL_END
