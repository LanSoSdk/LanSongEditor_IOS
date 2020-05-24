//
//  DrawPadAllPreview.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/10/22.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "LSOVideoPen.h"
#import "LSOViewPen.h"
#import "LSOPen.h"
#import "LanSongView2.h"
#import "LSOVideoFramePen.h"
#import "LSOBitmapPen.h"
#import "LSOMVPen.h"
#import "LSOAeView.h"
#import "LSOObject.h"
#import "LSOBitmapAsset.h"
#import "LSOVideoAsset.h"
#import "LSOAeViewPen.h"
#import "LSOVideoOption.h"
#import "LSOVideoFramePen2.h"
#import "LSOVideoLayer.h"



NS_ASSUME_NONNULL_BEGIN
/**
 图片/视频/Ae动画处理的
 */
@interface DrawPadAllPreview : LSOObject


/// 初始化
/// @param size 容器大小, 其中的宽度和高度一定是2的倍数
/// @param durationS 容器的总时长, 单位秒. 可以是小数, [可选]
-(id)initWithDrawPadSize:(CGSize)size durationS:(CGFloat)durationS;





/// 您在init的时候, 设置的容器大小
@property (nonatomic,readonly) CGSize drawpadSize;

/// 设置容器的帧率.[可选, 默认是25]
/// 范围是>=25; 并小于33;如果您都是json增加, 则建议设置为json的帧率;
/// @param frameRate 
-(void)setFrameRate:(CGFloat)frameRate;
/**
 增加预览的显示创建;
 @param view
 */
-(void)addLanSongView:(LanSongView2 *)view;
//-----------------------------------Aejson动画图层--------------------------------
/// 增加Aejson文件动画;
/// @param aeView json动画对象
-(LSOAeViewPen *)addAeViewPen:(LSOAeView *)aeView;

/// 增加json动画
/// @param aeView json动画对象
/// @param startS 从容器的什么位置增加
/// @param endS 增加到容器的什么位置;
-(LSOAeViewPen *)addAeViewPen:(LSOAeView *)aeView  startPadTime:(CGFloat )startS endPadTime:(CGFloat)endS;

//-----------------------------------View UI图层--------------------------------
/**
 增加UI图层;
  [如果UI不变化, 建议把UIView转UIImage然后用addBitmapPen图片的形式增加, 不建议用此方法;]
 @param view UI图层
 @param from  这个UI是否来自界面, 如果你已经self.view addSubView增加了这个view,则这里设置为YES;
 @return 返回对象
 */
-(LSOViewPen *)addViewPen:(UIView *)view isFromUI:(BOOL)from;

//-----------------------------------图片图层--------------------------------
/**
 增加图片图层

 @param image 图片对象
 @return 返回图片图层对象
 */
-(LSOBitmapPen *)addBitmapPen:(LSOBitmapAsset *)bmpAsset;




/// 增加图片图层 ,可以设置开始时间和结束时间
/// @param image 图片对象
/// @param startS 开始时间,单位秒
/// @param endS 结束时间
-(LSOBitmapPen *)addBitmapPen:(LSOBitmapAsset *)bmpAsset startPadTime:(CGFloat )startS endPadTime:(CGFloat)endS;


//-----------------------------------透明动画 MV图层--------------------------------
/**
 增加mv图层;
 
 各种透明的动画, 在我们SDK中, 认为是MV效果, 关于MV的 原理和制作步骤,请参考我们的指导文件.
 @param colorPath mv效果中的彩色视频路径
 @param maskPath mv效果中的黑白视频路径
 @return MV对象
 */
-(LSOMVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;


-(LSOMVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath  startPadTime:(CGFloat )startS endPadTime:(CGFloat)endS;


//-------------------拼接类---------
/// 拼接图片
///  此拼接,是把所有图片前后拼接起来, 并放到最底层;
///  在拼接视频后,我们会自动计算每个层的显示时间, 请务必不要调用setDisplayTimeRange
///  默认会在上一个图层的下面交叠1秒的时长;
/// @param bmpAsset 图片资源
/// @param durationS 图片存在的时间;
-(LSOBitmapPen *)concatBitmapPen:(LSOBitmapAsset *)bmpAsset duration:(CGFloat)durationS;


/// 拼接图片
/// @param bmpAsset 图片图层
/// @param durationS 时长
/// @param overLapTimeS 和上一个图层交叠的时间;
-(LSOBitmapPen *)concatBitmapPen:(LSOBitmapAsset *)bmpAsset duration:(CGFloat)durationS overLapTime:(CGFloat)overLapTimeS;

/// 拼接一个视频图层
/// @param asset
/// @param option 
-(LSOVideoFramePen2 *)concatVideoFramePen2:(LSOVideoAsset *)asset option:(LSOVideoOption *)option;


-(LSOVideoLayer *)concatLSOVideoLayer:(LSOVideoAsset *)asset option:(LSOVideoOption *)option;



//----------------------控制类方法------


/// 设置容器的背景颜色
@property(nullable, nonatomic,copy)  UIColor *backgroundColor;

/**
 交换两个非拼接图层的前后位置;
 在开始前调用;
 @param first 第一个图层对象
 @param second 第二个图层对象
 */
-(BOOL)exchangePenPosition:(LSOPen *)first second:(LSOPen *)second;

/**
 设置非拼接图层的位置
 [在开始前调用]
 
 @param pen 图层对象
 @param index 位置, 最里层是0, 最外层是 getPenSize-1
 */
-(BOOL)setPenPosition:(LSOPen *)pen index:(int)index;

/**
 获取容器的总时长;
 单位:秒
 */
@property CGFloat durationS;


/// 用在UISlide滑动条 滑动的场合
/// @param timeS seek到的时间
-(void)seekPauseTo:(CGFloat)timeS;


/// 暂停预览
-(void)pausePreview;

/// 恢复预览;
-(void)resumePreview;


/// 设置是否循环预览
/// @param loop 循环预览
-(void)setLoopPreview:(BOOL)loop;



/// 当前是否暂停播放;
@property (nonatomic,readonly)BOOL isPaused;


-(void)removePen:(LSOPen *)pen;

/**
 因为当前增加多个声音或视频后,直接start有点耗时,
 我们暂时折中的办法是:在开始执行之前, 有一个准备的过程, 您可以在准备的时候,有个对话框,提醒用户;
 */
-(BOOL)prepareDrawPad:(void (^)(void))handler;
/**
 在调用此方法前,一定要调用prepare;
 这个只是预览, 开始后,不会编码, 不会有完成回调
 @return 执行成功返回YES, 失败返回NO;
 */
-(void)start;
/**
 取消
 */
-(void)cancel;

/**
 进度回调,
 当在编码的时候, 等于当前视频图层的视频播放进度 时间单位是秒;;
 工作在其他线程,
 如要工作在主线程,请使用:
 progress: 当前正在播放画面的时间戳;
 
 进度则是: progress/_duration;
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^progressBlock)(CGFloat progress);

/**
 编码完成回调, 完成后返回生成的视频路径;
 注意:生成的dstPath目标文件, 我们不会删除.如果你多次调用,就会生成多个视频文件;
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



/// 当前图层的数量;
@property (nonatomic,readonly) int penCount;


/// 当前是否循环播放;
@property (nonatomic,readonly) BOOL isLooping;

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

NS_ASSUME_NONNULL_END

