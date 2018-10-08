//
//  DrawPadCameraPreview.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/6/5.
//  Copyright © 2018年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoPen.h"
#import "ViewPen.h"
#import "Pen.h"
#import "LanSongView2.h"
#import "BitmapPen.h"
#import "MVPen.h"
#import "LanSongVideoCamera.h"
#import "CameraPen2.h"

@interface DrawPadCameraPreview : NSObject

@property (nonatomic,strong)CameraPen2 *cameraPen;


-(id)initFullScreen:(LanSongView2 *)view isFrontCamera:(BOOL)isFront;

-(id)initWithPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition  view:(LanSongView2 *)view;

-(id)initWithPreset:(LanSongVideoCamera *)camera drawpadSize:(CGSize)size view:(LanSongView2 *)view;

@property (nonatomic) CGSize drawpadSize;


/**
 增加UI图层

 @param view 增加UI图层;
 @param from 这个UI是否已经增加到界面上; 如果已经增加,则内部不再渲染到界面;
 @return 增加成功返回UI图层对象;
 */
-(ViewPen *)addViewPen:(UIView *)view isFromUI:(BOOL)from;


/**
 增加图片图层

 @param image 图片
 @return 返回图片图层对象
 */
-(BitmapPen *)addBitmapPen:(UIImage *)image;


/**
 增加MV图层

 @param colorPath mv图层的颜色视频
 @param maskPath mv图层的灰度视频
 @return 返回mv图层对象
 */
-(MVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;


/**
 删除图层
 */
-(void)removePen:(Pen *)pen;

/**
 开始执行
 这个只是预览, 开始后,不会编码, 不会有完成回调
 @return 执行成功返回YES, 失败返回NO;
 */
-(BOOL)startPreview;

-(void)stopPreview;
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
 当前是否在运行;
 */
@property (nonatomic,readonly) BOOL isRunning;
@property (nonatomic,readonly) BOOL isRecording;
@end
