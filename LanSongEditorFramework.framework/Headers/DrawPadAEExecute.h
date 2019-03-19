//
//  DrawPadAEExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/7/31.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LSOVideoPen.h"
#import "LSOViewPen.h"
#import "LSOPen.h"
#import "LSOBitmapPen.h"
#import "LSOMVPen.h"
#import "LanSong.h"
#import "LSOAeView.h"


/**
 Ae图层的后台快速合成容器;
 
 用来Ae的各种素材合成为目标视频;
 */
@interface DrawPadAEExecute : NSObject

/**
 当前输入视频的媒体信息, 可以获取视频宽高, 长度等;
 如果用init创建的DrawPadAEExecute则此对象为nil;
 */
@property (nonatomic,readonly)LSOMediaInfo *videoPenInfo;

/**
 当前进度的最终长度;, 进度/duration等于百分比;
 */
@property (readonly) CGFloat duration;

/**
 通过 initWithURL/initWithPath创建的视频对象
 */
@property (nonatomic)   LanSongMovie *videoPen;

/**
 当前容器的大小
 */
@property (nonatomic,readonly) CGSize drawpadSize;


/**
 设置编码时的码率.
 可选;
 */
@property (nonatomic,assign) int encoderBitRate;


@property (nonatomic,readonly) int penCount;


/**
 初始化
 
 @param videoPath 输入的视频文件
 @return 返回构造对象
 */
-(id)initWithURL:(NSURL *)videoPath;

/**
 初始化
 @param videoPath
 @return
 */
-(id)initWithPath:(NSString *)videoPath;


/**
 不增加背景视频的初始化方法;
 容器大小,生成视频的帧率,时长等于第一个增加的AEJson 图层或 MV图层的分辨率;
 
 @return
 */
-(id)init;


/**
 不增加背景视频的初始化方法;
 生成视频的帧率,时长等于第一个增加的AEJson 图层或 MV图层的帧率或时长;

 @param size 我们的SDK是图层和容器思想; 这里是设置容器的大小,请务必等于当前容器的宽高;
 */
-(id)initWithDrawPadSize:(CGSize)size;
/**
 增加UI图层;
 @param view UI图层
 @return 返回对象
 */
-(LSOViewPen *)addViewPen:(UIView *)view;


/**
 增加AE对象;
 [不建议使用]
 增加后, 作为一个图层叠加在其他层的上面;
 */
-(void)addAEView:(LSOAeView *)view;

/**
 增加AE的json文件;
 返回LSOAeView对象; 拿着对象可以做updateImage,updateText,updateVideo;
 几乎等于:addAEView:(LSOAeView *)view
 */
-(LSOAeView *)addAEJsonPath:(NSString *)jsonPath;

/**
 增加一个图片图层,
 可以增加多个.

 在容器开始运行前增加
 */
-(LSOBitmapPen *)addBitmapPen:(UIImage *)image;
/**
 增加一个图片图层
 
 可以增加多个.
 在容器开始运行前,
 @param image 图片对象
 @param position 位置
 @return 返回图层对象;
 */
- (LSOBitmapPen *)addBitmapPen:(UIImage *)image position:(LSOPosition)position;
/**
 增加mv图层;

 各种透明的动画, 在我们SDK中, 认为是MV效果, 关于MV的 原理和制作步骤,请参考我们的指导文件.
 @param colorPath mv效果中的彩色视频路径
 @param maskPath mv效果中的黑白视频路径
 @return 增加后,返回mv图层对象
 */
-(LSOMVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;

/**
 开始执行
 */
-(BOOL)start;
/**
 取消
 */
-(void)cancel;


/**
 调换两个图层的位置.
[在开始前调用]
 @param first 第一个图层
 @param second 第二个图层
 @return 交换成功返回YES;
 */
-(BOOL)exchangePenPosition:(LSOPen *)first second:(LSOPen *)second;
/**
 设置图层的位置
 [在开始前调用]
 @param pen 图层对象
 @param index 位置, 最里层是0, 最外层是 getPenSize-1
 */
-(BOOL)setPenPosition:(LSOPen *)pen index:(int)index;

/**
 进度回调,
 此进度回调, 在 编码完一帧后,没有任意queue判断,直接调用这个block;
 比如在:assetWriterPixelBufferInput appendPixelBuffer执行后,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^progressBlock)(CGFloat progess);

/**
 文字使用.
 */
@property(nonatomic, copy) void(^frameProgressBlock)(int frames);
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


/**
 设置Ae模板中的视频的音量大小.
 在需要增加其他声音前调用(addAudio后调用无效).
 不调用默认是原来的声音大小;
 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 设置为0, 则删除Ae模板中的音频;
 */
@property(readwrite, nonatomic) float aeAudioVolume;

/**
 增加音频图层, 在增加完图层后调用;
 可多次调用
 @param audio 音频路径.或带有音频的视频路径
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio volume:(CGFloat)volume;

/**
 增加音频图层, 在增加完图层后调用;
 可多次调用
 
 @param audio 音频路径.或带有音频的视频路径
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @param isLoop 是否循环
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio volume:(CGFloat)volume loop:(BOOL)isLoop;

/**
 增加音频图层, 在增加完图层后调用;
 把音频的哪部分 增加到主视频的指定位置上;
 可多次调用
 
 @param audio 音频路径.或带有音频的视频路径
 @param start 开始
 @param pos  把这个音频 增加到 主音频的那个位置,比如从5秒钟开始增加这个音频
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio start:(CGFloat)start pos:(CGFloat)pos volume:(CGFloat)volume;
/**
  增加音频图层, 在增加完图层后调用;
 可多次调用
 @param audio 音频路径.或带有音频的视频路径
 @param start 音频的开始时间段
 @param end 音频的结束时间段 如果增加到结尾, 则可以输入-1
 @param pos 把这个音频 增加到 主音频的那个位置,比如从5秒钟开始增加这个音频
 @param volume 混合时的音量
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio start:(CGFloat)start end:(CGFloat)end pos:(CGFloat)pos volume:(CGFloat)volume;
@end
