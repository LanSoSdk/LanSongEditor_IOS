//
//  LSOAddAudioPlayer.h
//  LanSongEditorFramework
//
//  Created by sno on 2021/4/12.
//  Copyright © 2021 sno. All rights reserved.
//

#import <Foundation/Foundation.h>



#import "LSODisplayView.h"

@class LSOAudioLayer;



NS_ASSUME_NONNULL_BEGIN
@interface LSOAddAudioPlayer : LSOObject



/// init
/// @param urlArray 用户选中的视频/图片
/// @param ratio 容器的比例, 如果原始比例, 则填入LSOSizeRatio_ORIGINAL
-(id)initWithUrlArray:(NSArray<NSURL *> *)urlArray ratio:(LSOSizeRatio)ratio;

 
/*
 读当前合成(容器)的总时长.单位秒;
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
 当前有多少个音频层;
 如果你获取使用此变量, 则会拷贝一份新的NSMutableArray, 请不要一直拷贝;
 */
@property (strong,atomic, readonly) NSMutableArray *audioLayerArray;

 /**
 增加预览的显示创建;
 @param view 设置一个合成的显示窗口, 显示窗口一定要和合成(容器)的宽高成比例, 可以不相等.
 */
-(void)setCompositionView:(LSODisplayView *)view;

/// 增加一个声音图层;
/// @param url url路径
/// @param startTimeS 开始时间;
- (LSOAudioLayer *)addAudioLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;

///  删除声音图层
/// @param audioLayer 声音图层对象
- (void)removeAudioLayer:(LSOAudioLayer *)audioLayer;


/// 在init后, 准备拼接的图层
/// @param handler 返回拼接好的图层对象
- (void)prepareConcatLayerAsync:(void (^)(NSArray *layerAray))handler;

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


/// 禁止图层的touch事件;
@property (nonatomic, assign) BOOL disableTouchEvent;


@property (nonatomic,assign) CGSize videoSize;

@end

NS_ASSUME_NONNULL_END

