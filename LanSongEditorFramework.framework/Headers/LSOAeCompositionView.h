//
//  LSOAeCompositionView.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/8/21.
//  Copyright © 2019 sno. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "LanSongContext.h"
#import "LSOPen.h"
#import "LanSongContext.h"
#import "LSOVideoPen.h"
#import "LSOViewPen.h"
#import "LSOBitmapPen.h"
#import "LSOMVPen.h"
#import "LanSong.h"
#import "LSOAeView.h"
#import "LSOObject.h"



@interface LSOAeCompositionView : UIView


/**
 增加第一层 : 背景视频
 如果没有没有第一层,则设置为nil; 或不调用;
 
 */
-(BOOL)addFirstPenWithPath:(NSString *)videoPath;
/**
 增加第一层: 背景视频
 如果没有没有第一层,则设置为nil; 或不调用;
 @param videoUrl NSURL类型的视频完整路径
 
 @return 增加成功返回
 */
-(BOOL)addFirstPenWithURL:(NSURL *)videoUrl;

/**
 增加第二层 : 解析后的json对象;
 */
-(LSOViewPen *)addSecondPen:(LSOAeView *)aeView;

/**
 增加第三层 : 导出的MV图层;
 [没有则不调用]
 */
-(LSOMVPen *)addThirdPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;
/**
 增加第四层 : 解析后的json
 [没有则不调用]
 */
-(LSOViewPen *)addForthPen:(LSOAeView *)aeView;

/**
 增加第五层 : 导出的MV图层;
 [没有则不调用]
 */
-(LSOMVPen *)addFifthPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;


/**
 增加第六层 : 解析后的json
 [没有则不调用]
 */
-(LSOViewPen *)addSixthPen:(LSOAeView *)aeView;

/**
 裁剪模板的总长度;
 */
- (void)setCutComposition:(CGFloat)durationS;

//----------增加其他图层(图片, UIView,MV等)--------------------------------
/**
 增加一个图片图层,
 可以增加多个.
 
 在容器开始运行前增加
 */
-(LSOBitmapPen *)addOtherBitmapPen:(UIImage *)image;

/**
 增加一个图片图层
 
 可以增加多个.
 在容器开始运行前,
 @param image 图片对象
 @param position 位置
 @return 返回图层对象;
 */
- (LSOBitmapPen *)addOtherBitmapPen:(UIImage *)image position:(LSOPosition)position;

/**
 增加UI图层;
 [如果UI不变化, 建议把UIView转UIImage然后用addBitmapPen图片的形式增加, 不建议用此方法;]
 @param view UI图层
 @return 返回对象
 */
-(LSOViewPen *)addOtherViewPen:(UIView *)view;

/**
 增加AE模板以外的mv图层;
 */
-(LSOMVPen *)addOtherMVPen:(NSURL *)colorURL withMask:(NSURL *)maskURL;
/**
 
 设置Ae模板中的视频的音量大小.
 也是最终生成视频的音量;
 在需要增加其他声音前调用(addAudio后调用无效).
 不调用默认是原来的声音大小;
 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 设置为0, 则删除Ae模板中的音频;
 */
@property(readwrite, nonatomic) float aeAudioVolume;

/**
 当前线程是否在运行
 */
@property(atomic,readonly) BOOL isRunning;


@property(atomic,readonly) int frameWidth;
@property(atomic,readonly)int frameHeight;
//总长度,单位秒;
@property(atomic,readonly)CGFloat  durationS;

/**
 增加音频
 可多次调用
 @param audio 音频路径.或带有音频的视频路径
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio volume:(CGFloat)volume;

/**
 增加音频
 可多次调用
 
 @param audio 音频路径.或带有音频的视频路径
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @param isLoop 是否循环
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio volume:(CGFloat)volume loop:(BOOL)isLoop;


/**
 增加音频, 把音频的哪部分 增加到主视频的指定位置上;
 可多次调用
 
 @param audio 音频路径.或带有音频的视频路径
 @param start 裁剪音频, 从音频的什么时间点开始增加;
 @param pos  把这个音频 增加到 主音频的那个位置,比如从5秒钟开始增加这个音频
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio start:(CGFloat)start pos:(CGFloat)pos volume:(CGFloat)volume;
/**
 增加音频
 可多次调用
 @param audio 音频路径.或带有音频的视频路径
 @param start 音频的开始时间段
 @param end 音频的结束时间段 如果增加到结尾, 则可以输入-1
 @param pos 把这个音频 增加到 主音频的那个位置,比如从5秒钟开始增加这个音频
 @param volume 混合时的音量
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio start:(CGFloat)start end:(CGFloat)end pos:(CGFloat)pos volume:(CGFloat)volume;


/**
 设置缓冲时间.
 
 我们默认缓冲时间为2秒;
 如果您的模板有点复杂, 则建议增加缓冲时间, 比如2--5秒;i
 
 当然你可以在缓冲的时候, 调用pausePreview暂停, 暂停的同时, 模板一样在加速渲染;
 @param timeS 时间, 单位是秒;
 */
-(void)setBufferingTime:(CGFloat)timeS;
/**
 设置视频图层在是视频处理完毕后, 是否要循环处理.
 */
@property(nonatomic,getter=isLoop) BOOL loopPlay;

/**
 是否要禁止缓冲等待.
 默认禁止缓冲. 这里是YES;
 
 如果模板复杂, 渲染慢, 默认会暂停一下播放, 返回缓冲回调, 表现就是卡顿;
 设置为YES后, 将不再缓冲, 但有可能画面和音乐不同步.
 */
@property(nonatomic,getter=isLoop) BOOL disableBuffering;
/**
 取消;
 */
-(void)cancel;


/**
 开始预览
 @return 开启异步线程成功,返回YES;
 */
-(BOOL)startPreview;
/**
 开始导出;
 
 @return 开启成功, 返回YES;
 */
-(BOOL)startExport;

/**
 暂停预览
 */
-(void)pausePreview;


/**
 暂停后的恢复 预览
 */
-(void)resumePreview;

//-------------------------------------各种回调类------------------------------------
/**
 预览播放进度;
 
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^previewProgressBlock)(CGFloat progress,CGFloat percent);
/**
 导出进度;
 
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^exportProgressBlock)(CGFloat progress,CGFloat percent);

/**
 导出的回调
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^exportCompletionBlock)(NSString *dstPath);

/**
 当前是否在缓冲中...
 如果您不希望缓冲, 可以设置disableBuffering=YES;
 */
@property(nonatomic, copy) void(^previewBufferingBlock)(BOOL  isBuffering);

@end
