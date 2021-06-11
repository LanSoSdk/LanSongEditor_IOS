//
//  LSOAeExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 2021/4/10.
//  Copyright © 2021 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "LSOViewPen.h"
#import "LSOPen.h"
#import "LSOBitmapPen.h"
#import "LSOMVPen.h"
#import "LanSong.h"
#import "LSOAeView.h"
#import "LSOObject.h"


/**
 图层导出合成类;
 */
@interface LSOAeExecute : LSOObject

/**
 当前进度的最终长度;, 进度/duration等于百分比;
 */
@property (readonly) CGFloat duration;

/**
 当前容器的大小
 */
@property (nonatomic,readonly) CGSize drawpadSize;
/**
 设置编码时的码率.
 可选;
 */
@property (nonatomic,assign) int encoderBitRate;


/**
 初始化;
 */
-(id)init;


/**
 增加模板中的背景视频
 */
-(BOOL)addBgVideoWithURL:(NSURL *)videoUrl;


/**
 增加AE的json文件;
 */
- (BOOL)addAEJsonUrl:(NSURL *)jsonUrl;



/// 增加mv图层;
/// @param colorUrl mv效果中的彩色视频路径
/// @param maskUrl mv效果中的黑白视频路径
-(BOOL)addMVWidthColorUrl:(NSURL *)colorUrl maskUrl:(NSURL *)maskUrl;

/**
 增加UI图层;
 @param view UI图层
 @return 返回对象
 */
-(LSOViewPen *)addViewPen:(UIView *)view;


/**
 设置要替换的所有路径;
 当前支持图片和视频
 */
@property (nonatomic, copy) NSMutableArray<NSURL *> *replaceArray;



/**
 增加一个图片图层,
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
 开始执行
 */
-(BOOL)start;


/**
 进度回调,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^progressBlock)(CGFloat progess);

/**
 完成回调
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


-(void)releaseLSO;

@end
