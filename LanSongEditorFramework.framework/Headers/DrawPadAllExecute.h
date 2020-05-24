//
//  DrawPadAllExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/10/23.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


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
#import "LSOVideoFramePen2.h"
#import "LSOAeCompositionAsset.h"
#import "LSOAECompositionPen.h"
NS_ASSUME_NONNULL_BEGIN
/**
 混合容器的后台执行;
 
 你可以增加图片/ 声音/视频,可以指定增加到什么位置.
 */
@interface DrawPadAllExecute : LSOObject

/**
 当前进度的最终长度;, 进度/duration等于百分比;
 */
@property (readonly) CGFloat durationS;

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


@property(nullable, nonatomic,copy)  UIColor *backgroundColor;

/// 增加视频图层
/// @param videoAsset 视频资源
/// @param option 视频选项
-(LSOVideoFramePen *)addVideoPen:(LSOVideoAsset *)videoAsset option:(LSOVideoOption * _Nullable)option;

/// 增加视频图层
/// @param videoAsset 视频资源
/// @param option 视频选项
/// @param startS 从容器的什么时间点增加此视频
/// @param endS 增加到容器的什么时间点为止.
-(LSOVideoFramePen *)addVideoPen:(LSOVideoAsset *)videoAsset option:(LSOVideoOption *_Nullable)option startPadTime:(CGFloat )startS endPadTime:(CGFloat)endS;



/// 增加view 图层;
/// 这个 view 一定是重新alloc,并没有增加到预览的self.view 中的.
/// view 是随容器的时间轴走动, 而不是随系统时间走动, 故如果你要设置动画, 则需要根据回调时间戳,自己写动画, 不能用iOS 中的 Animation;
/// @param view view 层
-(LSOViewPen *)addViewPen:(UIView *)view;


/// 增加Aejson文件动画;
/// @param aeView json动画对象
-(LSOAeViewPen *)addAeViewPen:(LSOAeView *)aeView;

/// 增加 AEjson 图层动画;
/// @param aeView  ae导出的json并替换好资源的对象
/// @param startS 从容器的什么时间点增加,单位秒
/// @param endS 增加到容器的什么时间点, 如果到容器结束,则设置为CGFLOAT_MAX
-(LSOAeViewPen *)addAeViewPen:(LSOAeView *)aeView  startPadTime:(CGFloat )startS endPadTime:(CGFloat)endS;

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
/// @param endS 增加到容器的什么时间点, 如果到容器结束,则设置为CGFLOAT_MAX
- (LSOBitmapPen *)addBitmapPen:(LSOBitmapAsset *)bmpAsset startPadTime:(CGFloat)startS endPadTime:(CGFloat)endS;


/// 增加MV图层
/// 各种透明的动画, 在我们SDK中, 认为是MV效果, 关于MV的 原理和制作步骤,请参考我们的指导文件.
/// @param colorUrl mv效果中的彩色视频路径
/// @param maskUrl mv效果中的黑白视频路径
/// @param startS 从容器的什么时间点增加,单位秒
/// @param endS 增加到容器的什么时间点, 如果到容器结束,则设置为CGFLOAT_MAX
-(LSOMVPen *)addMVPen:(NSURL *)colorUrl withMask:(NSURL *)maskUrl  startPadTime:(CGFloat)startS endPadTime:(CGFloat)endS;

/// 增加MV图层
-(LSOMVPen *)addMVPen:(NSURL *)colorUrl withMask:(NSURL *)maskUrl;

/// 把 AE 模板作为资源增加到容器里, 增加后, 作为容器的一个图层
/// @param asset AE 资源
/// @param startS 从容器的什么时间点增加
/// @param endS 增加到容器的什么时间点, 如果到容器结束,则设置为CGFLOAT_MAX
-(LSOAECompositionPen *) addAeCompositionPen:(LSOAeCompositionAsset *)asset  startPadTime:(CGFloat)startS endPadTime:(CGFloat)endS;
-(LSOAECompositionPen *) addAeCompositionPen:(LSOAeCompositionAsset *)asset;

//--------------------------------------------------------拼接类----------------------------------------------
///  拼接视频 多次调用
///  此拼接,是把所有图片前后拼接起来, 并放到最底层;
///   在拼接视频后,我们会自动计算每个层的显示时间, 请务必不要调用setDisplayTimeRange
/// @param asset 视频资源
/// @param option 视频选项;
-(LSOVideoFramePen2 *)concatVideoFramePen2:(LSOVideoAsset *)asset option:(LSOVideoOption * _Nullable)option;

/// 拼接图片
///  此拼接,是把所有图片前后拼接起来, 并放到最底层;
///  在拼接视频后,我们会自动计算每个层的显示时间, 请务必不要调用setDisplayTimeRange  
/// @param bmpAsset 图片资源
/// @param durationS 图片存在的时间;
-(LSOBitmapPen *)concatBitmapPen:(LSOBitmapAsset *)bmpAsset duration:(CGFloat)durationS;

-(LSOBitmapPen *)concatBitmapPen:(LSOBitmapAsset *)bmpAsset duration:(CGFloat)durationS overLapTime:(CGFloat)overLapTimeS;
//----------------------
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
@property(nonatomic, copy) void(^completionBlock)(NSString * _Nullable dstPath);

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

NS_ASSUME_NONNULL_END
/**
 DrawPadAllExecute *allExecute2;
 -(void)testAllExecute
 {
     allExecute2=[[DrawPadAllExecute alloc] initWithDrawPadSize:CGSizeMake(720, 1280) durationS:10];
     UIImage *image=[UIImage imageNamed:@"small"];
     [allExecute2 addViewPen:[self createUIView:CGSizeMake(720, 1280)]];
     
     [allExecute2 setProgressBlock:^(CGFloat progess) {
         dispatch_async(dispatch_get_main_queue(), ^{
             LSOLog_d(@"----progress is :%f",progess);
         });
     }];
     
     [allExecute2 setCompletionBlock:^(NSString * _Nullable dstPath) {
         dispatch_async(dispatch_get_main_queue(), ^{
             LSOLog_d(@"----progress is :%@",dstPath);
             [DemoUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
         });
     }];
     [allExecute2 start];
 }
 -(UIView *)createUIView:(CGSize)size
 {
     UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width,size.height)];
     rootView.backgroundColor = [UIColor redColor];
     UIImage *image = [UIImage imageNamed:@"small"];
     UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
     imageView.center = CGPointMake(rootView.bounds.size.width/2, rootView.bounds.size.height/2);

     UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 540, 120)];
     label.text=@"杭州蓝松科技";
     label.textColor=[UIColor redColor];
     [rootView addSubview:label];
     [rootView addSubview:imageView];
     return rootView;
 }
 */
