//
//  LSOVideoComposition.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/3/14.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "LSODisplayView.h"

@class LSOLayer;
@class LanSongFilter;

//叠加层;
@class LSOAudioLayer;

@class LXQOperateLayer;


NS_ASSUME_NONNULL_BEGIN
@interface LSOEditPlayer : LSOObject



/// init
/// @param urlArray 用户选中的视频/图片
/// @param ratio 容器的比例, 如果原始比例, 则填入LSOSizeRatio_ORIGINAL
-(id)initWithUrlArray:(NSArray<NSURL *> *)urlArray ratio:(LSOSizeRatio)ratio;

-(id)initWithUrlArray:(NSArray<NSURL *> *)urlArray size:(CGSize)size;


/*
 读当前合成(容器)的总时长.单位秒;
 (当你设置每个图层的时长后, 此属性会改变.);
 */
@property(readonly,atomic) CGFloat durationS;

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
 设置一个图层为选中状态;
 当用户通过界面点击别的图层时,这个状态会被改变;
 可以设置, 如果设置不选中, 则设置为nil;
 */
@property (nonatomic, readwrite) LSOLayer *selectedLayer;




/**
    画布
 */

@property (nonatomic, readwrite)UIImage *__nullable backGroundImage;

/**
 设置一个背景视频;
 背景视频默认循环;
 */
- (void)setBackGroundVideoLayerWithURL:(NSURL *)url completedHandler:(void (^)(LSOLayer *videoLayer))handler;;
/**
 设置一个背景图片;
 */
- (LSOLayer *)setBackGroundImageLayerWithImage:(UIImage *)image;

/**
 增加预览的显示创建;
 @param view 设置一个合成的显示窗口, 显示窗口一定要和合成(容器)的宽高成比例, 可以不相等.
 */
-(void)setCompositionView:(LSODisplayView *)view;

//----------------------叠加层操作 start----------------------------------------
/**
 增加一个视频叠加层.
 叠加层是在拼接层的上面;
 atStartTime 在合成的指定时间开始增加;
 */
- (LSOLayer *)addVideoLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;
/**
 叠加一张图片图层;
 */
- (LSOLayer *)addImageLayerWithImage:(UIImage *)image atTime:(CGFloat)startTimeS;
- (LSOLayer *)addImageLayerWithImage:(UIImage *)image atTime:(CGFloat)startTimeS canOperate:(BOOL)canOperate;

/**
 增加一个gif图层;
 */
- (LSOLayer *)addGifLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;

/**
 增加mv动画层;
 */
- (LSOLayer *)addMVWithColorURL:(NSURL *)colorUrl maskUrl:(NSURL *) maskUrl atTime:(CGFloat)startTimeS;

//----------------------叠加层操作 end----------------------------------------

/// 增加一个声音图层;
/// @param url url路径
/// @param startTimeS 开始时间;
- (LSOAudioLayer *)addAudioLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;

///  删除声音图层
/// @param audioLayer 声音图层对象
- (void)removeAudioLayer:(LSOAudioLayer *)audioLayer;

/// 设置叠加层的位置
/// @param layer 图层对象
/// @param index 位置, 最里层是0
-(BOOL)setOverlayerLayerPosition:(LSOLayer *)layer index:(int)index;



/// 设置拼接层的位置.
/// @param layer 拼接的图层
/// @param index 图层的index, 从前到后, 第一个层是0; 最后面的是: _concatLayerArray.count-1;
-(BOOL)setConcatLayerPosition:(LSOLayer *)layer index:(int)index;


/// 删除背景图层;
- (void)removeBackGroundLayer;


/// 设置合成的比例
/// @param ratio 设置的比例.
- (CGSize)updateCompositionRatio:(LSOSizeRatio)ratio;
- (void)updateDisplaySizeAfterRatio:(CGSize)displaySize;


//----------------------一下是拼接层的操作----------------------------------------

/// 在init后, 准备拼接的图层
/// @param handler 返回拼接好的图层对象
- (void)prepareConcatLayerAsync:(void (^)(NSArray *layerAray))handler;
/**
 增加拼接图片图层;
  返回的layerAray :是当前新增加的图层对象数组
 */
- (void)insertConcatLayerWithImageArray:(NSArray<UIImage *> *)imageArray completedHandler:(void (^)(NSArray *layerAray))handler;

/// 在容器的指定位置增加资源
/// 在容器的指定时间点插入, 时间点在图层前半部分,插入图层前,反之插入到图层后;
/// @param urlArray url数组
/// @param compTimeS 在容器的指定时间点插入,
/// @param handle 完成后的回调,是当前新增加的图层对象数组
- (void)insertConcatLayerWithArray:(NSArray<NSURL *> *)urlArray atTime:(CGFloat)compTimeS  completedHandler:(void (^)(NSArray *layerArray,BOOL insertBefore))handler;



///  在容器的指定位置增加图片数组
/// @param imageArray 图片数组
/// @param compTimeS 指定时间点插入
/// @param handler 完成后的回调,是当前新增加的图层对象数组
- (void)insertConcatLayerWitImageArray:(NSArray<UIImage *> *)imageArray atTime:(CGFloat)compTimeS  completedHandler:(void (^)(NSArray *layerArray,BOOL insertBefore))handler;



/// 替换一个图层
/// @param currentLayer 当前要替换的图层
/// @param url 要替换的路径 NSURL 格式
/// @param handler 替换完成后的回调;
- (void)replaceConcatLayerWithLayer:(LSOLayer *)currentLayer replaceUrl:(NSURL *)url completedHandler:(void (^)(LSOLayer *replacedLayer))handler;

/// 分割图层
/// @param compTimeS
/// @param layer
-(void)splitConcatLayerByTime:(CGFloat)compTimeS layer:(LSOLayer *)layer;



/// 复制一个拼接图层
/// @param layer
/// @param completeBlock
-(void)copyConcatLayerByLayer:(LSOLayer *)layer complete:(void(^)(void))completeBlock;

/// 复制一个叠加图层
/// @param layer
/// @param completeBlock
-(LSOLayer *)copyVideoLayerByLayer:(LSOLayer *)layer;

/**
 删除一个图层.
 */
- (BOOL)removeLayer:(nullable LSOLayer *)layer;


/// 删除一组图层
/// @param layers <#layers description#>
- (void)removeLayerArray:(nullable NSArray<LSOLayer *> *)layers;


///  根据合成中的一个时间点, 删除对应的图层
/// @param compTimeS 在合成中的时间,单位秒;
- (BOOL)removeLayerByCompTime:(CGFloat )compTimeS;

- (BOOL)cutTimeFromStartWithLayer:(LSOLayer *)layer cutStartTimeS:(CGFloat)timeS;
-(BOOL)cutTimeFromEndWithLayer:(LSOLayer *)layer cutEndTimeS:(CGFloat)timeS;
/**
 根据当前在合成中的时间点, 来获取一个图层对象;
 当前返回的是 LSOLayer对象
 */
-(LSOLayer *)getCurrentConcatLayerByTime:(CGFloat)compTimeS;

//------------------------转场动画类----------------------------------------------
/**
 把一个滤镜应用到所有的图层;
 */
-(void)applyToAllLayersWithFilter:(LanSongFilter *)filter;


/**
  打印当前各个图层的信息;
 */
-(void)printCurrentLayerInfo;


//----------------------控制类方法-------------------------------

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
 从什么位置播放到什么位置, 播放后,会暂停;
 [合成容器开始后有效]
 */
- (void)playTimeRangeWithStart:(CGFloat)startS endTimeS:(CGFloat)endS;

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




@property (nonatomic,assign) CGSize videoSize;



@end

NS_ASSUME_NONNULL_END

