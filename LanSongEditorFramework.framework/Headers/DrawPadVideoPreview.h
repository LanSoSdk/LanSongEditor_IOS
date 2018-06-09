//
//  DrawPadVideoPreview.h
//
//  Created by sno on 2018/5/24.
//  Copyright © 2018年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoPen.h"
#import "ViewPen.h"
#import "Pen.h"
#import "LanSongView2.h"
#import "BitmapPen.h"
#import "MVPen.h"

@interface DrawPadVideoPreview : NSObject

@property (nonatomic)   VideoPen *videoPen;
@property (nonatomic,assign) CGSize drawpadSize;


/**
初始化
 @param videoPath输入的视频路径
 */
-(id)initWithURL:(NSURL *)videoPath;

/**
初始化
 @param videoPath 输入的视频路径
 @return
 */
-(id)initWithPath:(NSString *)videoPath;

-(void)addLanSongView:(LanSongView2 *)view;

/**
 增加UI图层; 举例有增加Lottie

 @param view UI图层
 @param from 这个UI来自界面; 当前请设置为YES
 @return 返回对象
 */
-(ViewPen *)addViewPen:(UIView *)view isFromUI:(BOOL)from;

-(BitmapPen *)addBitmapPen:(UIImage *)image;

-(MVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;

-(void)removePen:(Pen *)pen;

/**
 开始执行
 这个只是预览, 开始后,不会编码, 不会有完成回调
 @return 执行成功返回YES, 失败返回NO;
 */
-(BOOL)start;


/**
 开始执行,并实时录制;

 @return
 */
-(BOOL)startWithEncode;

/**
 取消
 */
-(void)cancel;

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

-(void)switchFilter:(LanSongOutput <LanSongInput> *)filter;

/**
 滤镜级联, 叠加;
 把最后的滤镜输入到这里;
 */
-(void)switchFilterStartWith:(LanSongOutput <LanSongInput> *)startFilter  end:(LanSongOutput <LanSongInput> *)endFilter;

-(void)switchFilter:(LanSongTwoInputFilter *)filter secondInput:(LanSongOutput *)secondFilter;
@end
