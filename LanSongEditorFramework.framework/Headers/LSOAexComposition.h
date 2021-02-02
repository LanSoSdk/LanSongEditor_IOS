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
#import "LSOLayer.h"


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
 当前有多少个音频层;
 获取会拷贝一份新的NSMutableArray, 请不要一直拷贝;
 */
@property (strong,atomic, readonly) NSMutableArray *audioLayerArray;

/**
 设置一个图层为选中状态;
 当用户通过界面点击别的图层时,这个状态会被改变;
 */
-(void)setAexDisplayView:(LSOAexDisplayView *)view;


/**
 给每个AexImage设置后， 你需要调用此代码， 告知合成类， 刷新界面；
 */
-(void)updateAexImageAsync:(LSOAexImage *)aexImage completed:(void (^)(void))handler;

/**
 在更新完LSOAexText后, 调用此方法, 告知合成类, 让合成类刷新;
 */
- (BOOL)updateAexText:(LSOAexText *)aexText;
/**dis
 增加声音图层;
 可设置从容器的什么时间点增加;
 */
- (LSOAudioLayer *)addAudioLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;
/**
 增加一个声音图层;
 */
- (LSOAudioLayer *)addAudioLayerWithURL:(NSURL *)url;

- (LSOLayer *)addImageLayerWithImage:(UIImage *)image atTime:(CGFloat)startTimeS;

/**
 删除一个声音图层;
 */
- (void)removeAudioLayer:(LSOAudioLayer *)audioLayer;
/**)
 增加logo图片
 posititon: 枚举类型;
 */
- (void)addLogoUIImage:(UIImage *)image position:(LSOPositionType)posititon;




/**
 增加logo图片
 centerPosition: 中心点位置;
 */
- (void)addLogoUIImage:(UIImage *)image certerPosition:(CGPoint )centerPosition;

//------------------------------------控制类方法---------------------------------------------
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
 定位到指定的AE图片;
 定位后,会触发_aexImageChangedBlock 和 _playProgressBlock回调;
 */
- (void)seekToAexImage:(LSOAexImage *)aexImage;

/**
 定位到指定的AE文本
 定位后,会触发 _playProgressBlock回调;
 */
- (void)seekToAexText:(LSOAexText *)aexText;

/**
 异步准备一下;
 */
- (void)prepareModuleAsync:(void (^)(void))handler;
/**
 在调用此方法前
 [内部会开启一个线程执行]
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

/**
 
 */
@property(nonatomic, copy) void(^aexImageChangedBlock)(LSOAexImage *aexImage,int index);


/**
 播放完成.
 */
@property(nonatomic, copy) void(^playCompletionBlock)(void);



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
@property(nonatomic, copy) void(^exportCompletionBlock)(NSString *_Nullable dstPath);


/**
 当前选中的图片
 */
@property (nonatomic, readonly) LSOAexImage *selectedAexImage;

/**
当前选中的文字
 */
@property (nonatomic, readwrite) LSOAexText *selectedAexText;

/**
 当前用户选中了正在播放的一张图片;
 选中后, 会暂停当前画面的播放;
 */
@property(nonatomic, copy) void(^userSelectedAexImageBlock)(LSOAexImage *aexImage,int index);

/**
 当前用户选中了正在播放的文字;
 选中后, 会暂停当前画面 的播放;
 */
@property(nonatomic, copy) void(^userSelectedAexTextBlock)(LSOAexText *text,int index);


/**
 适配ios13; 必须按照demo中的设置;
 */
@property(nonatomic, copy) NSString *_Nullable(^mergeAVBlock)(NSString *video, NSString *audio);

/**
 禁止图片点击事件;
 默认不禁止;
 */
@property (nonatomic, assign) BOOL disableAexImageTouchEvent;

/**
 禁止文字点击事件;
 */
@property (nonatomic, assign) BOOL disableAexTextTouchEvent;


@end

NS_ASSUME_NONNULL_END

