//
//  DrawPadAllExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/10/23.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "LSOVideoPen.h"
#import "LSOViewPen.h"
#import "LSOPen.h"
#import "LSOBitmapPen.h"
#import "LSOMVPen.h"
#import "LanSong.h"
#import "LSOAeView.h"
#import "LSOObject.h"
#import "LSOBitmapAsset.h"
#import "LSOVideoFramePen.h"
#import "LSOVideoAsset.h"
#import "LSOAeViewPen.h"




/**
 混合容器的执行;
 */
@interface DrawPadAllExecute : LSOObject

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
 图层数量
 */
@property (nonatomic,readonly) int penCount;

//----------------一下为具体方法-------------------------
/**
 初始化;
 @return
 */
-(id)initWithDrawPadSize:(CGSize)size durationS:(CGFloat)durationS;

/// 增加视频资源, 返回视频图层;
/// @param videoAsset 视频资源
-(LSOVideoFramePen *)addVideoPen:(LSOVideoAsset *)videoAsset;

/// 增加视频资源, 返回视频图层;
/// @param videoAsset 视频资源
/// @param startS 从容器的什么时间点开始, 单位秒
/// @param endS 从容器的什么时间点结束; 单位秒;
-(LSOVideoFramePen *)addVideoPen:(LSOVideoAsset *)videoAsset startTime:(CGFloat )startS endTime:(CGFloat)endS;



/// 增加Aejson文件动画;
/// @param aeView json动画对象
-(LSOAeViewPen *)addAeViewPen:(LSOAeView *)aeView;
/// 增加json动画
/// @param aeView 动画;
-(LSOAeViewPen *)addAeViewPen:(LSOAeView *)aeView  startTime:(CGFloat )startS endTime:(CGFloat)endS;


/**
 增加一个图片图层,
 可多次调用
 在容器开始运行前增加
 */
-(LSOBitmapPen *)addBitmapPen:(LSOBitmapAsset *)bmpAsset;


/// 增加图片图层
/// 可多次调用
/// @param bmpAsset 图片资源
/// @param startS 开始时间, 单位秒
/// @param endS 结束时间,单位秒, 如果到文件尾,则用CGFLOAT_MAX
- (LSOBitmapPen *)addBitmapPen:(LSOBitmapAsset *)bmpAsset startTime:(CGFloat)startS endTime:(CGFloat)endS;
/**
 增加mv图层;

 各种透明的动画, 在我们SDK中, 认为是MV效果, 关于MV的 原理和制作步骤,请参考我们的指导文件.
 @param colorPath mv效果中的彩色视频路径
 @param maskPath mv效果中的黑白视频路径
 @return 增加后,返回mv图层对象
 */
-(LSOMVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;


/// 增加MV图层
///  各种透明的动画, 在我们SDK中, 认为是MV效果, 关于MV的 原理和制作步骤,请参考我们的指导文件.
/// @param colorPath mv效果中的彩色视频路径
/// @param maskPath mv效果中的黑白视频路径
/// @param startS 开始时间
/// @param endS 结束时间;
-(LSOMVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath startTime:(CGFloat)startS endTime:(CGFloat)endS;

/**
 开始执行
 */
-(BOOL)start;
/**
 取消
 */
-(void)cancel;


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
 @param start 从声音的哪个时间点开始增加;
 @param pos  把这个音频 增加到 主音频的那个位置,比如从5秒钟开始增加这个音频
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio start:(CGFloat)start pos:(CGFloat)pos volume:(CGFloat)volume;
/**
  增加音频图层, 在增加完图层后调用;
 可多次调用
 @param audio 音频路径.或带有音频的视频路径
 @param start 从声音的哪个时间点开始增加;
 @param end 音频的结束时间段 如果增加到结尾, 则可以输入CGFLOAT_MAX
 @param pos 把这个音频 增加到 主音频的那个位置,比如从5秒钟开始增加这个音频
 @param volume 混合时的音量
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio start:(CGFloat)start end:(CGFloat)end pos:(CGFloat)pos volume:(CGFloat)volume;
@end

