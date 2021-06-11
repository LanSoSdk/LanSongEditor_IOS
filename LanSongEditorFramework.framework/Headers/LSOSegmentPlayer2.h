//
//  LSOSegmentPlayer2.h
//  LanSongEditorFramework
//
//  Created by sno on 2021/5/8.
//  Copyright © 2021 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "LSODisplayView.h"


@class LSOLayer;


NS_ASSUME_NONNULL_BEGIN
@interface LSOSegmentPlayer2 : LSOObject


-(id)initWithURL:(NSURL *)videoUrl;



/// 对输入的视频做时长裁剪, 一定在在initWithURL后调用;
/// @param startTimeS 裁剪的开始时间
/// @param endTimeS 裁剪的结束时间
- (void)setVideoStartTime:(CGFloat)startTimeS endTime:(CGFloat)endTimeS;


/**
 您在init的时候, 设置的合成宽高.
 */
@property (nonatomic,readonly) CGSize playerSize;
 

/// 总时长;
@property (nonatomic,readonly) CGFloat durationS;



/// 设置背景为一个视频
/// @param url 视频路径
/// @param handler 设置完毕后,返回图层对象;
- (void)setBackGroundURL:(NSURL *)url completedHandler:(void (^)(LSOLayer *videoLayer))handler;



/// 设置背景为一张图片
/// @param image 图片对象
- (LSOLayer *)setBackGroundImage:(UIImage *)image;



/// 获取背景视频图层
@property (nonatomic,readonly) LSOLayer *backGroundLayer;


/// 背景声音的音量;
@property (nonatomic,assign) CGFloat backGroundAudioVolume;


/// 删除背景层
- (void)removeBackGround;


///  增加预览的显示窗口
/// @param view 显示窗口
- (void)setDisplayView:(LSODisplayView *)view;



/// 增加图标logo;
/// @param image 建议图片不要过大;
- (LSOLayer *)addImageLayerWithImage:(UIImage *)image;


/// 增加子图层;
- (LSOLayer *)addSubSegmentLayer;


/// 删除图层
/// @param layer 图层对象
- (BOOL)removeLayer:(nullable LSOLayer *)layer;


/// 设置一个声音路径
/// @param url 声音的url
/// @param cutStart 对声音裁剪的开始时间, 如果没有裁剪则为0
/// @param cutEnd 声音裁剪的结束时间, 如果没有裁剪,则为CGFLOAT_MAX
- (void)setAudioUrl:(NSURL *)url cutStartTime:(CGFloat)cutStart cutEndTime:(CGFloat)cutEnd;


@property (nonatomic, readonly) CGFloat audioCutStartTimeS;

/// 获取音乐裁剪结束时间;
@property (nonatomic, readonly) CGFloat audioCutEndTimeS;



/**
 当用户从下向上滑动, 让整个APP进入后台的时候,
 你可以调用整个方法, 让合成线程进入后台;
 */
- (void)applicationDidEnterBackground;
/**
 当用户从 后台的状态下, 恢复到当前界面, 则调用这个APP,恢复合成的运行;
 */
- (void)applicationDidBecomeActive;


/// prepare异步执行
/// @param handler
- (void)prepareAsync:(void (^)(BOOL))handler;

/**
 在调用此方法前
 [内部会开启一个线程]
 */
- (void)startPreview;


/**
是否播放中;
 */
@property (nonatomic,readonly) BOOL isPlaying;



/// 背景模糊调节. 范围是0.0--1.0;默认是0.24;
@property (nonatomic, assign) CGFloat backGroundBlurLevel;


/// 给背景设置滤镜;
@property (nonatomic, strong) LanSongFilter *backGroundFilter;


/// 异步获取
/// @param handler 每得到一张图片,回调一次;
-(void)getThumbnailAsyncWithHandler:(void (^)(UIImage *image, BOOL finish))handler;



/// 设置导出时的人像分割模式
/// @param mode 模式
- (void)setSegmentModeWhenExport:(LSOSegmentMode) mode;
/**
 开始导出,
 */
-(void)startExportWithRatio:(LSOExportSize)ratioType;


/// 取消导出.
- (void)cancelExport;
/**
 当前是否正在导出.
 */
@property (readonly) BOOL  isExporting;



//适配ios13的export类问题;
@property(nonatomic, copy) NSString *_Nullable(^mergeAVBlock)(NSString *video, NSString *audio);


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
 设置码率, 单位字节,
 [可选],最低是300*1024
 */
@property (nonatomic,assign) int exportBitRate;

/**
  用户点击事件; 用户手指按下.
 中间不需要增加 dispatch_async(dispatch_get_main_queue(),;
 */
@property(nonatomic, copy) void(^ _Nullable userTouchDownLayerBlock)(LSOLayer * _Nullable layer);
@property(nonatomic, copy) void(^ _Nullable userTouchMoveLayerBlock)(CGPoint point);
@property(nonatomic, copy) void(^ _Nullable userTouchScaleLayerBlock)(CGSize size);
@property(nonatomic, copy) void(^ _Nullable userTouchRotationLayerBlock)(CGFloat rotation);
@property(nonatomic, copy) void(^ _Nullable userTouchUpLayerBlock)(void);

@property(nonatomic, copy) void(^userSelectedLayerBlock)(LSOLayer *layer);


/// 禁止图层的touch事件;
@property (nonatomic, assign) BOOL disableTouchEvent;


@end

NS_ASSUME_NONNULL_END

