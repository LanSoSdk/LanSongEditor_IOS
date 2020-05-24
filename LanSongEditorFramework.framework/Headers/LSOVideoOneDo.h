//
//  LSOVideoOneDo.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/1/4.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import "LanSongFilter.h"
#import "LSOObject.h"



/**
 视频的常见处理:
 当前可以完成:
 1.增加多个背景音乐+调节音量,2.裁剪时长,3.裁剪画面,4.缩放,5.增加Logo,6.增加文字,7.设置滤镜,8.设置码率(压缩),
 9.增加美颜,10.增加封面,11增加UI界面,12,增加马赛克.13,旋转视频, 14, 叠加图片
 
 调用流程是:
 init--->setXXX--->设置进度完成回调--->start;
 */
@interface LSOVideoOneDo : LSOObject

/// 初始化对象, 如果视频不存在, 或者无法解码,则返回 nil;
/// @param videoURL 视频路径;
-(id)initWithNSURL:(NSURL *)videoURL;

/**
 在init后,获取视频的信息
 */
@property (nonatomic,readonly)CGFloat videoWidth;
@property (nonatomic,readonly)CGFloat videoHeight;

/// 获取视频的时长,单位秒;
@property (nonatomic,readonly)CGFloat videoDurationS;

/**
 是否在运行
 */
@property (readonly)BOOL  isRunning;

/**
 设置视频的音量大小.
 在需要增加其他声音前调用(addAudio后调用无效).
 不调用默认是原来的声音大小;
 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 设置为0, 则静音;
 */
@property(readwrite, nonatomic) float videoUrlVolume;
/**
 裁剪开始时长
 */
@property(readwrite, nonatomic) float cutStartTimeS;
/**
 要裁剪的时长;
 */
@property(readwrite, nonatomic) float cutDurationTimeS;
/**
 设置旋转角度;
 当前仅支持 90/180/270 (顺时针,即3点钟是90度);
 此角度以0角度为参考.
 如果视频本身有旋转角度,则我们内部会自动旋转过来,然后再根据您设置的角度来旋转;
 */
@property(readwrite, nonatomic) float rotationAngle;

/**
 恢复所有默认值;
 [清除所有设置的参数]
 */
-(void)resetAllValue;
/**
 视频裁剪;
 注意:
 1.CGRect中的x,y如是小数,则调整为整数;
 2.CGRect中的width,height如是奇数,则调整为偶数.(能被2整除的数)
 3.如果您设置了rotationAngle, 则先旋转,再裁剪;
 */
@property (readwrite,nonatomic)CGRect cropRect;

/**
 设置视频缩放到的目标大小;
 */
@property (readwrite,nonatomic)CGSize scaleSize;

/**
 视频编码码率;
 (起到视频压缩的作用)
 我们不建议你设置, 因为我们内部会根据不同的视频选择不同的码率
 */
@property (readwrite,nonatomic)int bitrate;

/**
 设置压缩百分比;
 范围是0--1;
 我们不建议你设置, 因为我们内部会根据不同的视频选择不同的码率
 */
-(void)setCompressPercent:(CGFloat)percent;

/**
 视频增加UI图层;
 (可以设置logo, 文字, 等其他控件, 不支持用OpenGL实现的控件,比如AVPlayerLayer)
 
 请务必:
 如果裁剪则view的宽高等于裁剪的宽高;
 如果没有,则等于视频的宽高;
 
 UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, encoderSize.width, encoderSize.height)];
 执行流程是: 先旋转-->裁剪--->执行滤镜--->设置马赛克区域--->增加UI层-->叠加图片--->缩放--->设置码率,编码;
 */
-(void)setUIView:(UIView *)view;

/**
设置滤镜
(在开始之前调用)
 */
-(void)setFilter:(LanSongFilter *)filter;

/**
 设置滤镜
(在开始之前调用)
 */
-(void)setFilterWithStart:(LanSongFilter *)startFilter end:(LanSongFilter *)endFilter;

/**
在视频的指定时间范围内覆盖一张图片. 类似增加封面的效果.˙
 
 和setOverLayPicture 的区别是:此方法可以设置时间;
 比如要增加封面. 则设置时间点为:0---1.0秒;
 
 注意:如果你用这个给视频增加一张封面的话, 增加好后, 分享到QQ或微信或放到mac系统上, 显示的缩略图不一定是第一帧的画面.
 @param image 图片对象
 @param start 开始时间, 单位秒
 @param end 结束时间, 单位秒;
 */
-(void)setCoverPicture:(UIImage *)image startTime:(CGFloat)start endTime:(CGFloat)end;
/**
 在视频上面叠加一张图片

 和setCoverPicture的区别是: 覆盖整个视频时长.
 说明:
 1. 可以和setCoverPicture 同时使用.
 2. 叠加后, 这个图片会缩放到和视频宽高一样的大小,并整个覆盖在视频的上面,如果图片和视频不等比例,则图片会拉伸缩放;
 3. 一般用在增加文字/logo/涂鸦的场合,我们的UI图层演示有例子;
 
 执行顺序是: 先旋转-->裁剪--->执行滤镜--->设置马赛克区域--->增加UI层-->叠加图片--->缩放--->设置码率,编码;
 @param image 图片
 */
-(void)setOverLayPicture:(UIImage *)image;

/**
 增加马赛克区域.
 
 马赛克的参考宽高是:
 如果裁剪了,则以裁剪的宽高; 没有裁剪,则视频的宽高; 视频的左上角XY是:0.0,0.0
 
 (可增加多个)
 */
-(void)addMosaicRect:(CGRect)rect;

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
 @param start 开始
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

//-------------------各种颜色调节-----------------
/**
调节亮度的百分比.
 这里的百分比是两倍的关系,范围是 0--2.0; 其中 1.0 是默认值,
 0---1.0是调小;
 1.0 是默认,
 1.0---2.0 是调大;
  如要关闭,则调整为 1.0.默认是关闭;
 */
-(void)setBrightnessPercent:(CGFloat)percent2X;
/**
 调节对比度的百分比.
 这里的百分比是两倍的关系,范围是 0--2.0; 其中 1.0 是默认值,
 0---1.0是调小;
 1.0 是默认,
 1.0---2.0 是调大;
 如要关闭,则调整为 1.0.默认是关闭;
 */
-(void)setContrastFilterPercent:(CGFloat)percent2X;
/**
 调节饱和度的百分比.
 这里的百分比是两倍的关系,范围是 0--2.0; 其中 1.0 是默认值,
 0---1.0是调小;
 1.0 是默认,
 1.0---2.0 是调大;
  如要关闭,则调整为 1.0.默认是关闭;
 */
-(void)setSaturationFilterPercent:(CGFloat)percent2X;
/**
调节锐化的百分比.
这里的百分比是两倍的关系,范围是 0--2.0; 其中 1.0 是默认值,
0---1.0是调小;
1.0 是默认,
1.0---2.0 是调大;
 如要关闭,则调整为 1.0.默认是关闭;
*/
-(void)setSharpFilterPercent:(CGFloat)percent2X;
/**
调节色温的百分比.
这里的百分比是两倍的关系,范围是 0--2.0; 其中 1.0 是默认值,
0---1.0是调小;
1.0 是默认,
1.0---2.0 是调大;
 如要关闭,则调整为 1.0.默认是关闭;
*/
-(void)setWhiteBalanceFilterPercent:(CGFloat)percent2X;
/**
调节色调的百分比.
这里的百分比是两倍的关系,范围是 0--2.0; 其中 1.0 是默认值,
0---1.0是调小;
1.0 是默认,
1.0---2.0 是调大;
 如要关闭,则调整为 1.0.默认是关闭;
*/
-(void)setHueFilterPercent:(CGFloat)percent2X;
/**
调节褪色的百分比.
这里的百分比是两倍的关系,范围是 0--2.0; 其中 1.0 是默认值,
0---1.0是调小;
1.0 是默认,
1.0---2.0 是调大;
 如要关闭,则调整为 1.0.默认是关闭;
*/
-(void)setExposurePercent:(CGFloat)percent2X;

/**
 开始执行
  执行流程是: 先旋转-->裁剪--->执行滤镜--->设置马赛克区域--->增加UI层-->缩放--->设置码率,编码;
 */
-(BOOL) start;

/**
 停止执行.停止后,不会调用completionBlock回调;
 */
-(void)stop;
/**
 *     执行过程中的进度对调, 返回的当前时间戳 单位是秒.
 
 currentFramePts:当前正在编码的视频帧时间戳
 percent: 百分比,0--1;
 
 注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....CODE....
 });
 */
@property(nonatomic, copy) void(^videoProgressBlock)(CGFloat currentFramePts,CGFloat percent);
/**
 结束回调.
 执行后返回结果.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....CODEC....
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *video);
@end


/*
 举例如下:
 LSOVideoOneDo *videoOneDo;
 -(void)testVideoOneDo:(NSURL *)video
 {
 videoOneDo=[[LSOVideoOneDo alloc] initWithNSURL:video];
 
 //时长剪切
 videoOneDo.cutStartTimeS=3;
 videoOneDo.cutDurationTimeS=10;
 
 //画面裁剪
 [videoOneDo setCropRect:CGRectMake(0.0, 0.0, 540, 540)];
 
 //增加马赛克
 [videoOneDo addMosaicRect:CGRectMake(0.0, 0.0, 270, 270)];
 
 //增加一个View来叠加logo,文字等.
 [videoOneDo setUIView:[self createUIView]];
 
 [videoOneDo setCompletionBlock:^(NSString * _Nonnull video) {
 dispatch_async(dispatch_get_main_queue(), ^{
 [DemoUtils startVideoPlayerVC:self.navigationController dstPath:video];
 });
 }];
 [videoOneDo setVideoProgressBlock:^(CGFloat progess,CGFloat percent) {
 LSOLog(@"进度是:%f, 百分比:%f",progess,percent);
 }];
 [videoOneDo start];
 }
 -(UIView *)createUIView
 {
     UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 540,540)];
     rootView.backgroundColor = [UIColor clearColor];
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
