//
//  LSOSegmentPlayer.h
//  LanSongEditorFramework
//
//  Created by sno on 2021/3/1.
//  Copyright © 2021 sno. All rights reserved.
//


#import <Foundation/Foundation.h>


#import "LSODisplayView.h"
#import "LSOSegmentVideo.h"


@class LSOLayer;
@class LanSongFilter;

//叠加层;
@class LSOAudioLayer;


NS_ASSUME_NONNULL_BEGIN
@interface LSOSegmentPlayer : LSOObject



/// 抠像后的预览
/// @param segmentVideo 抠像视频对象;
-(id)initWithSegmentVideo:(LSOSegmentVideo *)segmentVideo;


/// 当前播放器的总时长
@property(nonatomic,readonly) CGFloat durationS;

/**
 您在init的时候, 设置的合成宽高.
 暂时不支持在合成执行过程中, 调整合成的宽高.
 */
@property (nonatomic,readonly) CGSize playerSize;
 
/**
 设置帧率,
 [可选],范围是10--60;
 */
@property (nonatomic,assign) CGFloat frameRate;

/**
 设置码率, 单位字节,
 [可选],最低是300*1024
 */
@property (nonatomic,assign) int exportBitRate;


/// 获取当前播放的时间点
@property(nonatomic, readonly) CGFloat currentTimeS;



/// 抠像视频的音量; 0.0是静音, 1.0是最大;
@property(nonatomic, assign) CGFloat segmentVideoVolume;


/// 声音图层数组;
@property (strong,atomic, readonly) NSMutableArray *audioLayerArray;

/// 设置背景为一个视频
/// @param url 视频路径
/// @param handler 设置完毕后,返回图层对象;
- (void)setBackGroundVideoLayerWithURL:(NSURL *)url completedHandler:(void (^)(LSOLayer *videoLayer))handler;

/// 设置背景为一张图片
/// @param image 图片对象
- (LSOLayer *)setBackGroundImageLayerWithImage:(UIImage *)image;


/// 删除背景层
- (void)removeBackGround;


/// 复制一个分割图层; 复制后, 返回图层对象, 可以通过图层对象做一些缩放,位置等操作,
/// 图层对象的layerType是:kLSOSegmentCopyLayer
- (LSOLayer *)copySegmentLayer;

/// 增加一个视频图层
/// @param url 视频url
/// @param startTimeS 从什么地方开始增加
- (LSOLayer *)addVideoLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;


/// 增加一个图片图层
/// @param image 图片对象
/// @param startTimeS 开始时间;
- (LSOLayer *)addImageLayerWithImage:(UIImage *)image atTime:(CGFloat)startTimeS;


/// 增加一个MV动画
/// @param colorUrl color视频路径
/// @param maskUrl 黑白视频路径
/// @param startTimeS 从什么地方开始增加
- (LSOLayer *)addMVWithColorURL:(NSURL *)colorUrl maskUrl:(NSURL *) maskUrl atTime:(CGFloat)startTimeS;


/// 增加一个Gif动画
/// @param url gif的路径
/// @param startTimeS 从什么地方开始增加
- (LSOLayer *)addGifLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;



///  增加预览的显示窗口
/// @param view 显示窗口
- (void)setDisplayView:(LSODisplayView *)view;


/// 增加一个声音图层;
/// @param url url路径
/// @param startTimeS 开始时间;
- (LSOAudioLayer *)addAudioLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;

///  删除声音图层
/// @param audioLayer 声音图层对象
- (void)removeAudioLayer:(LSOAudioLayer *)audioLayer;


/// 删除所有的声音图层;
- (void)removeALLAudioLayer;


/// 删除图层
/// @param layer 图层对象
- (BOOL)removeLayer:(nullable LSOLayer *)layer;



/**
 当用户从下向上滑动, 让整个APP进入后台的时候,
 你可以调用整个方法, 让合成线程进入后台;
 */
- (void)applicationDidEnterBackground;
/**
 当用户从 后台的状态下, 恢复到当前界面, 则调用这个APP,恢复合成的运行;
 */
- (void)applicationDidBecomeActive;

/**
 设置合成容器的背景颜色
 当前暂时导出无用;
 */
@property(nullable, nonatomic,copy)  UIColor *backgroundColor;

/**
  暂停;
 */
-(void)pause;

/**
 恢复播放
 */
-(void)resume;
/**
 定位到具体的时间戳;
 在调用后, 会暂停当前界面的执行;
 你需要在完成seek后, 调用resume来播放
 预览有效;
 */
- (void)seekToTimeS:(CGFloat)timeS;

/**
 在调用此方法前
 [内部会开启一个线程, ]
 */
-(BOOL)startPreview;
/**
 当前是否在运行;
 */
@property (nonatomic,readonly) BOOL isRunning;

/**
是否暂停;
 */
@property (nonatomic,readonly) BOOL isPlaying;



@property (nonatomic,assign) BOOL looping;



/**
 开始导出,
 */
-(void)startExportWithRatio:(LSOExportSize)ratioType;
/**
 当前是否正在导出.
 */
@property (readonly) BOOL  isExporting;
/**
 取消整个合成线程
 包括预览和导出, 都取消;
 */
-(void)cancel;

/**
 状态改变回调.
 目前只有两种状态, 暂停和播放
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^playerStateChangedBlock)(LSOPlayerState state);

/**
 进度回调,
 当在编码的时候, 等于当前视频图层的视频播放进度 时间单位是秒;;
 工作在其他线程,
 如要工作在主线程,请使用:
 进度则是: progress/_duration;
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 progress: 当前正在播放总合成的时间点,单位秒;
 percent: 当前总合成的时间点对应转换为的百分比;
 */
@property(nonatomic, copy) void(^playProgressBlock)(CGFloat progress,CGFloat percent);

//适配ios13的export类问题;
@property(nonatomic, copy) NSString *_Nullable(^mergeAVBlock)(NSString *video, NSString *audio);

/**
 在异步线程执行此block; 请用一下代码后调用;
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^playCompletionBlock)(void);

/**
 导出进度回调;
 在异步线程执行此block; 请用一下代码后调用;
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^exportProgressBlock)(CGFloat progress,CGFloat percent);

/**
编码完成回调, 完成后返回生成的视频路径;
注意:生成的dstPath目标文件, 我们不会删除.
在异步线程执行此block; 请用一下代码后调用;
dispatch_async(dispatch_get_main_queue(), ^{
});
*/
@property(nonatomic, copy) void(^exportCompletionBlock)(NSString *_Nullable dstPath);



/**
  用户点击事件; 用户手指按下.
 中间不需要增加 dispatch_async(dispatch_get_main_queue(),;
 */
@property(nonatomic, copy) void(^ _Nullable userTouchDownLayerBlock)(LSOLayer * _Nullable layer);
/**
 用户移动图层
 */
@property(nonatomic, copy) void(^ _Nullable userTouchMoveLayerBlock)(CGPoint point);
/**
 用户缩放图层事件;
 */
@property(nonatomic, copy) void(^ _Nullable userTouchScaleLayerBlock)(CGSize size);
/**
 用户旋转图层
 */
@property(nonatomic, copy) void(^ _Nullable userTouchRotationLayerBlock)(CGFloat rotation);
/**
 用户手指抬起;
 */
@property(nonatomic, copy) void(^ _Nullable userTouchUpLayerBlock)(void);

@property(nonatomic, copy) void(^userSelectedLayerBlock)(LSOLayer *layer);


/// 禁止图层的touch事件;
@property (nonatomic, assign) BOOL disableTouchEvent;


@end

NS_ASSUME_NONNULL_END

