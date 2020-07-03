//
//  LXAexComposition.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/6/30.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "LSOAexDisplayView.h"
#import "LSOAexModule.h"


//叠加层;
@class LSOAudioLayer;




NS_ASSUME_NONNULL_BEGIN
/**
 视频合成.
 是一个容器, 可以把视频, 图片, 文字,动画, 声音等合成为视频.
 有预览, 和预览后的导出
 */
@interface LSOAexComposition : LSOObject


/// 初始化
- (id)initWithLSOAexModule:(LSOAexModule *)module;

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
 获取,当前播放的时间点;
 */
@property(nonatomic, readonly) CGFloat currentTimeS;

/**
 当前内部有多少个叠加层;
 如果你获取使用此变量, 则会拷贝一份新的NSMutableArray, 请不要一直拷贝;
 */
@property (strong,atomic, readonly) NSMutableArray *overlayLayerArray;

/**
 当前有多少个音频层;
 如果你获取使用此变量, 则会拷贝一份新的NSMutableArray, 请不要一直拷贝;
 */
@property (strong,atomic, readonly) NSMutableArray *audioLayerArray;

/**
 设置一个图层为选中状态;
 当用户通过界面点击别的图层时,这个状态会被改变;
 */
-(void)setCompositionView:(LSOAexDisplayView *)view;

/**
 增加一个声音图层;
 */
- (LSOAudioLayer *)addAudioLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;



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


@property(nonatomic, copy) void(^playCompletionBlock)();



/**
 导出进度回调;
 */
@property(nonatomic, copy) void(^exportProgressBlock)(CGFloat progress,CGFloat percent);

/**
编码完成回调, 完成后返回生成的视频路径;
注意:生成的dstPath目标文件, 我们不会删除.
工作在其他线程,
如要工作在主线程,请使用:
dispatch_async(dispatch_get_main_queue(), ^{
});
*/
@property(nonatomic, copy) void(^exportCompletionBlock)(NSString *dstPath);




/**
 合成容器时间改变回调;
 当整个容器的合成时间改变了, 则触发回调;
 比如你对视频做裁剪,则会触发这里.
 durationS
 */
@property(nonatomic, copy) void(^compositionDurationChangedBlock)(CGFloat durationS);


/// 禁止图层的touch事件;
@property (nonatomic, assign) BOOL disableTouchEvent;


@end

NS_ASSUME_NONNULL_END

