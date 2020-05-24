//
//  LSOVideoComposition.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/3/14.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "LSOCompositionView.h"

@class LSOLayer;
@class  LSOConcatLayer;
@class LanSongFilter;

//叠加层;
@class LSOVideoLayer;
@class LSOImageLayer;
@class LSOMVLayer;
@class LSOViewLayer;
@class LSOGifLayer;
@class LSOImageArrayLayer;
@class LSOAudioLayer;



//效果/特效/转场;
@class LSOTransition;



NS_ASSUME_NONNULL_BEGIN
/**
 视频合成.
 是一个容器, 可以把视频, 图片, 文字,动画, 声音等合成为视频.
 有预览, 和预览后的导出
 */
@interface LSOVideoComposition : LSOObject


/// 初始化
/// @param size 合成宽高, 其中的宽度和高度一定是2的倍数
-(id)initWithCompositionSize:(CGSize)size;

/*
 读当前合成(容器)的总时长.单位秒;
 (当你设置每个图层的时长后, 此属性会改变.);
 */
@property(readonly,nonatomic) CGFloat durationS;

/**
 您在init的时候, 设置的合成宽高.
 暂时不支持在合成执行过程中, 调整合成的宽高.
 */
@property (nonatomic,readonly) CGSize compositionSize;

/**
 获取,当前播放的时间点;
 */
@property(nonatomic, readonly) CGFloat currentTimeS;

/**
 当前内部有多少个叠加层;
 */
@property (strong,atomic, readonly) NSMutableArray *overlayLayerArray;

/**
 当前内部有多少个拼接层;
 可实时获取;
 */
@property (strong,atomic, readonly) NSMutableArray *concatLayerArray;

/**
 当前有多少个音频层;
 */
@property (strong,atomic, readonly) NSMutableArray *audioLayerArray;

/// 设置容器的帧率.[可选, 默认是25]
/// 范围是>=25; 并小于33;如果您都是json增加, 则建议设置为json的帧率;
/// @param frameRate
-(void)setFrameRate:(CGFloat)frameRate;
/**
 增加预览的显示创建;
 @param view 设置一个合成的显示窗口, 显示窗口一定要和合成(容器)的宽高成比例, 可以不相等.
 */
-(void)setCompositionView:(LSOCompositionView *)view;

//----------------------叠加层操作----------------------------------------
/**
 增加一个视频叠加层.
 叠加层是在拼接层的上面;
 atStartTime 在合成的指定时间开始增加;
 */
- (LSOVideoLayer *)addVideoLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;
/**
 叠加一张图片图层;
 */
- (LSOImageLayer *)addImageLayerWithImage:(UIImage *)image atTime:(CGFloat)startTimeS;

/**
 叠加一个mv;
 */
- (LSOMVLayer *)addMVLayerWithColorURL:(NSURL *)colorUrl maskUrl:(NSURL *) maskUrl atTime:(CGFloat)startTimeS;

/**
 增加一个View图层;
 增加的view图层一定和setCompositionView的view宽高和位置;
 */
- (LSOViewLayer *)addViewLayerWithUIView:(UIView *)view atTime:(CGFloat)startTimeS;

/**
 增加一个gif图层;
 */
- (LSOGifLayer *)addGifLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;

/// 增加多个图片数组图层
/// @param imageArray 图片数据, UIImage类型
/// @param intervalS 两张图片的间隔时间, 单位秒, 一般建议是0.04(40毫秒); 0.03(30毫秒)
/// @param startTimeS 从合成的什么时间点开始插入
- (LSOImageArrayLayer *)addImageArrayLayerWithArray:(NSArray<UIImage *> *)imageArray intervalS:(CGFloat)intervalS atTime:(CGFloat)startTimeS;
/**
 增加一个声音图层;
 */
- (LSOAudioLayer *)addAudioLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;

/**
 删除声音图层
 */
- (void)removeAudioLayer:(LSOAudioLayer *)audioLayer;


/**
 交互两层之间的位置;
 */
- (BOOL)exchangePenPosition:(LSOLayer *)first second:(LSOLayer *)second;
/**
 设置叠加层的位置
 
 @param pen 图层对象
 @param index 位置, 最里层是0, 最外层是 getPenSize-1
 */
- (BOOL)setPenPosition:(LSOLayer *)pen index:(int)index;



/**
 设置一个背景视频;
 背景视频默认循环;
 */
- (void)setBackGroundVideoLayerWithURL:(NSURL *)url completedHandler:(void (^)(LSOVideoLayer *videoLayer))handler;;
/**
 设置一个背景图片;
 */
- (LSOImageLayer *)setBackGroundImageLayerWithImage:(UIImage *)image;


/// 删除背景图层;
- (void)removeBackGroundLayer;

//----------------------一下是拼接层的操作----------------------------------------
/**
 异步增加多个 要拼接的视频
 */
- (void)addConcatLayerWithArray:(NSArray<NSURL *> *)urlArray completedHandler:(void (^)(NSArray *layerAray))handler;


/// 在容器的指定位置增加资源
/// @param urlArray url数组
/// @param compTimeS 在容器的指定时间点
/// @param handle 完成后的回调
- (void)insertConcatLayerWithArray:(NSArray<NSURL *> *)urlArray atTime:(CGFloat)compTimeS  completedHandler:(void (^)(NSArray *layerArray))handler;



/// 替换一个图层
/// @param currentLayer 当前要替换的图层
/// @param url 要替换的路径 NSURL 格式
/// @param handler 替换完成后的回调;
- (void)replaceConcatLayerWithLayer:(LSOConcatLayer *)currentLayer replaceUrl:(NSURL *)url completedHandler:(void (^)(LSOConcatLayer *replacedLayer))handler;

/// 用视频 增加一个拼接层;
/// @param url 可以多次调用.返回一个拼接图层对象, 用对象可以调试各种参数.
-(LSOConcatLayer *)addConcatLayerWithURL:(NSURL *)url;

/**
 用图片  增加一个拼接层;
 可以多次调用.返回一个拼接图层对象, 用对象可以调试各种参数.
 */
-(LSOConcatLayer *)addConcatLayerWithUIImage:(UIImage *)url;

/**
 分割一个图层,
 返回是否分割成功.
 */
-(LSOLayer *)splitConcatLayerByTime:(CGFloat)compTimeS;

/**
 根据合成的时间点 拷贝一个拼接图层
 compTimeS:当前标尺指向的时间点 内部会根据这个时间点, 找到对应的图层, 从而拷贝这个图层;
 */
-(LSOLayer *)copyConcatLayerByTime:(CGFloat)compTimeS;
/**
 根据拼接图层, 复制一个拼接图层;
 */
-(LSOLayer *)copyConcatLayerByLayer:(LSOConcatLayer *)layer;

/**
 删除一个图层.
 */
- (BOOL)removeLayer:(nullable LSOLayer *)layer;


///  根据合成中的一个时间点, 删除对应的图层
/// @param compTimeS 在合成中的时间,单位秒;
- (BOOL)removeLayerByCompTime:(CGFloat )compTimeS;

/**
 裁剪图层的头部.
 compTimeS: 相对裁剪的偏移量
 */
-(BOOL)cutTimeFromStartWithLayer:(LSOConcatLayer *)layer offsetTime:(CGFloat)compTimeS;

/**
 裁剪图层的尾部
 compTimeS: 相对裁剪的偏移量
 */
-(BOOL)cutTimeFromEndWithLayer:(LSOLayer *)layer offsetTime:(CGFloat)compTimeS;
/**
 根据当前在合成中的时间点, 来获取一个图层对象;
 当前返回的是 LSOConcatLayer对象, 后续可能是OverLayer对象等等;
 */
-(LSOLayer *)getCurrentConcatLayerByTime:(CGFloat)compTimeS;

//------------------------转场动画类----------------------------------------------
/**
 把一个滤镜应用到所有的图层;
 */
-(void)applyToAllLayersWithFilter:(LanSongFilter *)filter;

/**
 把一个转场应用到所有图层
 */
-(void)applyToAllLayersWithTransition:(LSOTransition *)transition;

/**
 在指定的节点增加一个转场动画, 节点是两个图层的交汇点;
 
 比如 第0个图层和第1个图层连接处是 nodeIndex=0;
     第1个图层和第2个图层连接处是nodeIndex=1;
     第2个和第3个的连接处是nodeIndex=2;
 */
- (BOOL)setTransitionAtIndex:(LSOTransition *)transition  nodeIndex:(int)nodeIndex;

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
 回复;
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
 当视频或图片加载好后, 调用prepareComposition, 让合成开始异步做准备工作.
 当准备完毕, 根据handler回调调用开始预览.
 */
- (void)prepareComposition:(void (^)(BOOL))handler;

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
 开始导出.
  导出使用之前设置的容器合成分辨率为导出视频的b分辨率:compositionSize
 [异步工作]
 在预览的过程中, 调用startExport既导出当前的各种设置.
 */
-(void)startExport;


/**
 开始导出, 可设置导出视频的分辨率.
 建议分辨率和容器合成分辨率等比例;
 [异步工作]
 在预览的过程中, 调用startExport既导出当前的各种设置.
 */
-(void)startExportWithSize:(CGSize)size;
/**
 当前是否正在导出.
 */
@property (readonly) BOOL  isExporting;
/**
 取消
 */
-(void)cancel;

/**
 把合成容器中的尺寸转换为 屏幕尺寸;
 */
- (CGSize)convertToViewSizeWithLayerSize:(CGSize)layerSize;

/**
  把容器中的坐标,转换为屏幕坐标;
 */
- (CGPoint) convertToViewPointWithLayerPoint:(CGPoint)layerPoint;


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
@property(nonatomic, copy) void(^progressBlock)(CGFloat progress,CGFloat percent);

@property(nonatomic, copy) void(^exportProgressBlock)(CGFloat progress,CGFloat percent);


/**
 编码完成回调, 完成后返回生成的视频路径;
 注意:生成的dstPath目标文件, 我们不会删除.如果你多次调用,就会生成多个视频文件;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *dstPath);
@end

NS_ASSUME_NONNULL_END

