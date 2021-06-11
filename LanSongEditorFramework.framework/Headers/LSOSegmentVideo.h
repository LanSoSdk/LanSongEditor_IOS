//
//  LSOSegmentTest.h
//  LanSongEditorFramework
//
//  Created by sno on 2021/2/26.
//  Copyright © 2021 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOLayer.h"
#import "LSOCamLayer.h"

#import "LSOXAssetInfo.h"


NS_ASSUME_NONNULL_BEGIN


/// ai智能视频抠像类
@interface LSOSegmentVideo : LSOCamLayer



/// 获取支持的最大时长;
+ (CGFloat )supportMaxDuration;


/// 抠像并裁剪
/// @param url 抠像的url
/// @param start 视频的裁剪开始时间 单位秒;
/// @param end 视频的裁剪结束时间; 最大时长为20秒;
- (instancetype)initWithURL:(NSURL *)url cutStartTime:(CGFloat)start cutEndTime:(CGFloat)end;




/// init时的输入的url
@property(nonatomic, readonly) NSURL *videoUrl;



@property (nonatomic, assign) BOOL  onlyOneFrame;

/// 开始分割
- (void)start;


/// 是否在分割中;
@property (nonatomic, readonly) BOOL segmenting;


/// 输出的分辨率
@property (nonatomic, readonly) CGSize outputSize;


/// 总的时长;
@property (nonatomic, readonly) CGFloat durationS;



/// 分割出第一帧的回调
@property(nonatomic, copy) void(^segmentFirstFrameBlock)(void);


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




@property(nonatomic, readonly)LSOXAssetInfo *assetInfo;

- (BOOL)getFrame:(unsigned char *)rgbaPtr atTime:(CGFloat)time;


- (void)releaseLSO;

@end

NS_ASSUME_NONNULL_END
