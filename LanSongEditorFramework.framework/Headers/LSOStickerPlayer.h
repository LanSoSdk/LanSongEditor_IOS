//
//  LSOStickerPlayer.h
//  LanSongEditorFramework
//
//  Created by sno on 2021/4/8.
//  Copyright © 2021 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>


#import "LSODisplayView.h"

@class LSOLayer;

@class LSOAudioLayer;



NS_ASSUME_NONNULL_BEGIN
@interface LSOStickerPlayer : LSOObject



-(id)initWithImageUrl:(NSURL *)url;


/*
 读当前合成(容器)的总时长.单位秒;
 (当你设置每个图层的时长后, 此属性会改变.);
 */
@property(readonly,atomic) CGFloat compDurationS;

/**
 您在init的时候, 设置的合成宽高.
 暂时不支持在合成执行过程中, 调整合成的宽高.
 */
@property (nonatomic,readonly) CGSize compositionSize;
 
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
/**
 获取,当前播放的时间点;
 */
@property(nonatomic, readonly) CGFloat currentTimeS;

/**
 当前内部有多少个叠加层;
 如果你获取使用此变量, 则会拷贝一份新的NSMutableArray, 请不要一直拷贝;
 */
@property (strong,atomic, readonly) NSMutableArray *overlayLayerArray;

/**
 当前内部有多少个拼接层;
  如果你获取使用此变量, 则会拷贝一份新的NSMutableArray, 请不要一直拷贝;
 */
@property (strong,atomic, readonly) NSMutableArray *concatLayerArray;



/**
 增加预览的显示创建;
 @param view 设置一个合成的显示窗口,
 */
-(void)setCompositionView:(LSODisplayView *)view;


///  更新背景图片;
/// @param imageUrl 图片是本地的url路径;
- (LSOLayer *) setBackGroundImageUrl:(NSURL *)imageUrl;


/**
 叠加一张图片图层;
 */
- (LSOLayer *)addImageLayerWithImage:(UIImage *)image atTime:(CGFloat)startTimeS;

/**
 增加一个gif图层;
 */
- (LSOLayer *)addGifLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;

/**
 增加mv动画层;
 */
- (LSOLayer *)addMVWithColorURL:(NSURL *)colorUrl maskUrl:(NSURL *) maskUrl atTime:(CGFloat)startTimeS;

/**
 增加一个绿色背景的视频/图片;
 NSString 类型;
 */
- (LSOLayer *)addGreenBackGroundFileWithString:(NSString *)path;

/**
 增加一个绿色背景的视频/图片;
 NSURL 类型;
 */
- (LSOLayer *)addGreenBackGroundFileWithURL:(NSURL *)url;

/**
 设置一个图层为选中状态;
 当用户通过界面点击别的图层时,这个状态会被改变;
 可以设置, 如果设置不选中, 则设置为nil;
 */
@property (nonatomic, readwrite) LSOLayer *selectedLayer;



/// 设置一个声音路径
/// @param url 声音的url
/// @param cutStart 对声音裁剪的开始时间, 如果没有裁剪则为0
/// @param cutEnd 声音裁剪的结束时间, 如果没有裁剪,则为CGFLOAT_MAX
- (void)setAudioUrl:(NSURL *)url cutStartTime:(CGFloat)cutStart cutEndTime:(CGFloat)cutEnd;


@property (nonatomic, readonly) CGFloat audioCutStartTimeS;


/// 获取音乐裁剪结束时间;
@property (nonatomic, readonly) CGFloat audioCutEndTimeS;



/// 在init后, 准备
/// @param handler 返回拼接好的图层对象
- (void)prepare:(void (^)(NSArray *layerAray))handler;

/**
 删除一个图层.
 */
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
@property (readonly) BOOL isRunning;

/**
是否暂停;
 */
@property (readonly) BOOL isPausing;


/**
 开始导出,
 */
-(void)startExport;
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
 进度回调,
 当在编码的时候, 等于当前视频图层的视频播放进度 时间单位是秒;;
 工作在其他线程,
 如要工作在主线程,请使用:
 progress: 当前正在播放总合成的时间点,单位秒;
 percent: 当前总合成的时间点对应转换为的百分比;
 
 进度则是: progress/_duration;
 dispatch_async(dispatch_get_main_queue(), ^{
 });
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
 当前用户选中的图层回调;
 在异步线程执行此block; 请用一下代码后调用;
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^userSelectedLayerBlock)(LSOLayer *layer);

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
 合成容器时间改变回调;
 当整个容器的合成时间改变了, 则触发回调;
 比如你对视频做裁剪,则会触发这里.
 
 在异步线程执行此block; 请用一下代码后调用;
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^compositionDurationChangedBlock)(CGFloat durationS);

/// 禁止图层的touch事件;
@property (nonatomic, assign) BOOL disableTouchEvent;


@end

NS_ASSUME_NONNULL_END

