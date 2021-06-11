//
//  DrawPadCameraPreview.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/6/5.
//  Copyright © 2018年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LSOVideoPen.h"
#import "LSOViewPen.h"
#import "LSOPen.h"
#import "LanSongView2.h"
#import "LSOBitmapPen.h"
#import "LSOMVPen.h"
#import "LanSongVideoCamera.h"
#import "LSOCameraPen.h"

@interface DrawPadCameraPreview : NSObject


/**
 初始化

 @param view 显示view
 @param isFront 是否设置为前置
 */
-(id)initFullScreen:(LanSongView2 *)view isFrontCamera:(BOOL)isFront;
/**
 初始化

 @param sessionPreset 设置分辨率
 @param cameraPosition 
 @param view <#view description#>
 @return <#return value description#>
 */
-(id)initWithPreset:(NSString *)sessionPreset isFrontCamera:(BOOL)isFront view:(LanSongView2 *)view;


/**
 在init后, 会拿到Camera图层;
 */
@property (nonatomic,strong)LSOCameraPen *cameraPen;


@property (nonatomic) CGSize drawpadSize;

/**
 增加UI图层
 @param view 增加UI图层;
 @param from 设置为YES;
 @return 增加成功返回UI图层对象;
 */
-(LSOViewPen *)addViewPen:(UIView *)view isFromUI:(BOOL)from;


/**
 增加图片图层

 @param image 图片
 @return 返回图片图层对象
 */
-(LSOBitmapPen *)addBitmapPen:(UIImage *)image;


/**
 增加MV图层

 @param colorPath mv图层的颜色视频
 @param maskPath mv图层的灰度视频
 @return 返回mv图层对象
 */
-(LSOMVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;
/**
 删除图层
 */
-(void)removePen:(LSOPen *)pen;

/**
 开始执行
 这个只是预览, 开始后,不会编码, 不会有完成回调
 @return 执行成功返回YES, 失败返回NO;
 */
-(BOOL)startPreview;

-(void)stopPreview;

/**
 设置录制大小,[默认用drawpadsize;不建议调用]
 */
-(void)setRecordSize:(CGSize)size;

/**
 设置录制的码率
 在startRecord前调用;
 */
-(void)setRecordBitrate:(int)bitrate;
/**
 开始执行,并实时录制;
 @return
 */
-(BOOL)startRecord;

/**
 停止录制

 @param handler 返回录制后的文件路径;
 */
-(void)stopRecord:(void (^)(NSString *))handler;

/**
 进度回调,
 当在编码的时候, 等于当前视频图层的视频播放进度 时间单位是秒;;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^progressBlock)(CGFloat progess);


/**
 编码完成回调, 完成后返回生成的视频路径;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *dstPath);



/**
 在录制的时候, 音频的采样点回调,
 */
@property(nonatomic, copy) void(^audioProcessingCallback)(SInt16 **samples, CMItemCount numSamples);
/**
 当前是否在运行;
 */
@property (nonatomic,readonly) BOOL isRunning;
@property (nonatomic,readonly) BOOL isRecording;

/**
 特定用户使用;
 */
-(void)pauseMVPenAudioPlayer;
/**
 特定用户使用
 */
-(void)resumeMVPenAudioPlayer;
@end
