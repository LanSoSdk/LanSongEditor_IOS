//
//  LSOImageEditPlayer.h
//  LanSongEditorFramework
//
//  Created by sno on 2021/4/21.
//  Copyright © 2021 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>


#import "LSODisplayView.h"
#import "LSOSegmentImage.h"


@class LSOLayer;
@class LanSongFilter;



NS_ASSUME_NONNULL_BEGIN
@interface LSOImageEditPlayer : LSOObject


/// 图片编辑
/// @param image 图片编辑对象;
-(id)initWithSegmentImage:(LSOSegmentImage *)image;


/**
 播放器的宽高;
 */
@property (nonatomic,readonly) CGSize playerSize;
 

/// 设置背景为一张图片
/// @param image 图片对象
- (LSOLayer *)setBackGroundWithImage:(UIImage *)image;


/// 复制一份分割层;
/// 图层对象的layerType是:kLSOSegmentCopyLayer
- (LSOLayer *)copySegmentLayer;


/// 删除背景层
- (void)removeBackGround;



/// 增加一个图片图层
/// @param image 图片对象
- (LSOLayer *)addUIImage:(UIImage *)image;


/// 删除图层
/// @param layer 图层对象
- (BOOL)removeLayer:(nullable LSOLayer *)layer;



///  增加预览的显示窗口
/// @param view 显示窗口
- (void)setDisplayView:(LSODisplayView *)view;


/// 背景模糊的时候, 是否用原来的视频做背景;
@property (nonatomic, assign) BOOL  useOriginalVideoWhenBlur;



/// 背景模糊调节. 范围是0.0--1.0;默认是0.24;
@property (nonatomic, assign) CGFloat backGroundBlurLevel;


/// 给背景设置滤镜;
@property (nonatomic, strong) LanSongFilter *backGroundFilter;



/**
 当用户从下向上滑动, 让整个APP进入后台的时候,
 你可以调用整个方法, 让合成线程进入后台;
 */
- (void)applicationDidEnterBackground;

/**
 当用户从 后台的状态下, 恢复到当前界面, 则调用这个APP,恢复合成的运行;
 */
- (void)applicationDidBecomeActive;



@property (nonatomic, readonly) BOOL  isRunning;



/**
 在调用此方法前
 [内部会开启一个线程]
 */
-(BOOL)startPreview;


/**
 取消整个合成线程
 包括预览和导出, 都取消;
 */
-(void)cancel;



/// 导出为一张图片
/// @param handle 异步导出,工作在主线程;
- (void)exportWithHandle:(void (^)(UIImage *))handle;

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

