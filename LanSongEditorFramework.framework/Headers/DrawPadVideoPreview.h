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
 当前容器的总长度,等于视频的长度;
 单位秒;
 */
@property (nonatomic)   CGFloat duration;

/**
初始化
 @param videoPath输入的视频路径
 */
-(id)initWithURL:(NSURL *)videoPath;
/**
 初始化
 指定容器大小, 指定后, 视频以原有的尺寸居中放到容器中;
 
 原尺寸对齐说明如下:
 1. 如果视频宽高大于容器宽高,则视频会显示到容器外面,如果小于则显示到内部;
 2. 举例:比如视频宽高是1280*720; 如果你设置的iphone 6plus,他的self.view.frame.size是414x736;则只会显示视频居中的414x736的局域画面; 视频的高度是720;但屏幕是736;则会居中显示, 画面的上方和下方有8个像素的黑边;(736-720=16/2=8);
 
 3.如果要视频的宽度和容器的宽度对齐,则缩放是:videoPen.scaleWH=videoPen.drawPadSize.width/videoPen.penSize.width;
 4.如果要视频的高度和容器高度对齐,则缩放是:videoPen.scaleWH=videoPen.drawPadSize.height/videoPen.penSize.height;
 5.视频的移动以原视频的尺寸移动; videoPen.penSize等于视频的宽高;
 6. 视频在编码时,建议最好是540x960或 1280x720,或640x640,会把容器的画面填满到您设置的编码分辨率.
 
 @param videoPath 视频路径
 @param size
 */
-(id)initWithURL:(NSURL *)videoPath drawPadSize:(CGSize)size;

/**
初始化
 @param videoPath 输入的视频路径
 @return
 */
-(id)initWithPath:(NSString *)videoPath;

/**
  初始化
 指定容器大小, 指定后, 视频以原有的尺寸居中放到容器中;
 
 原尺寸对齐说明如
 @param videoPath 视频路径
 @param size
 */
-(id)initWithPath:(NSString *)videoPath drawPadSize:(CGSize)size;

-(void)addLanSongView:(LanSongView2 *)view;

/**

 使用:
 //为了保持UI图层不变形,
 //应该先创建一个和LanSongView2一样大小的viewA增加到self.view上,再把要增加的view增加到这个viewA中;
 UIView *view=[[UIView alloc] initWithFrame:lansongView.frame];
 [self.view addSubview:view];
 [view addSubview:yourView];//<----把你的 UI增加到view中;
 [drawpadPreview addViewPen:view isFromUI:YES];
 
 @param view UI图层
 @param from  这个UI是否来自界面, 如果你已经self.view addSubView增加了这个view,则这里设置为YES;
 @return 返回对象
 */
-(ViewPen *)addViewPen:(UIView *)view isFromUI:(BOOL)from;

-(BitmapPen *)addBitmapPen:(UIImage *)image;

-(MVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;

-(void)removePen:(Pen *)pen;


/**
 设置录制视频的宽高;
 设置后, 容器宽高不变, 会在编码的时候, 把容器的所有图层缩放到这个宽高上;
 如果录制视频的宽高比 不等于容器的宽高比,则录制后的图层会变形;
 
 在startRecord前调用;
 @param size 录制视频的宽高
 */
-(void)setRecordSize:(CGSize)size;

/**
 设置录制的码率
  在startRecord前调用;
 */
-(void)setRecordBitrate:(int)bitrate;
/**
 容器开始预览;
 @return 执行成功返回YES, 失败返回NO;
 */
-(BOOL)start;
/**
 容器停止预览
 */
-(void)stop;

/**
 容器暂停
 如果正在录制,则录制也暂停;
 等于执行: [_videoPen.avplayer pause];
 */
-(void)pause;
/**
 容器暂停后的恢复播放;
 如果正在录制, 录制也恢复;
 等于执行: [_videoPen.avplayer play];
 */
-(void)resume;
/**
 开始录制
 录制的每一帧时间戳, 通过recordProgressBlock返回;
 @return
 */
-(BOOL)startRecord;
/**
 停止录制, 录制的视频通过completionBlock回调返回;
 
 停止后,如果视频之前是循环播放,则恢复为循环播放;
 */
-(void)stopRecord;
/**
 取消
 */
-(void)cancel;

/**
 
 预览进度; 也是当前视频的播放进度;
 时间单位是秒;;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^previewProgressBlock)(CGFloat progress);

//等于previewProgressBlock; 为了兼容老版本,暂时保留
@property(nonatomic, copy) void(^progressBlock)(CGFloat progress);
/**
 录制回调;
 */
@property(nonatomic, copy) void(^recordProgressBlock)(CGFloat progress);

/**
 每次编码完毕, 都会调用这里;
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

/**
 直接增加上原来的声音;
 里面没有做mp3或aac检查,没有做时长检查,直接合并在一起;
 
 @param video 生成的视频
 @param audio 带声音的原视频路径/或其他音频
 @param dstFile 生成的文件
 @return 成功返回true, 失败返回false;
 */
+(BOOL)addAudioDirectly:(NSString *)video audio:(NSString*)audio dstFile:(NSString *)dstFile;
@end
