//
//  LSOLayer.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/3/14.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LanSongContext.h"
#import "LanSongOutput.h"
#import "LanSongFilter.h"
#import "LanSongTwoInputFilter.h"



@class LSOEffect;
@class LSOAnimation;

NS_ASSUME_NONNULL_BEGIN

@interface LSOLayer : LanSongOutput
{
      NSObject *framebufferLock;  //数据的同步锁. 内部使用.
}

/**
 *  当前图层的类型
 */
@property(readwrite, nonatomic) LSOLayerType2 layerType;


/// 是否是拼接图片层
@property (readonly, nonatomic) BOOL isConcatImageLayer;

/// 是否拼接视频层
@property (readonly, nonatomic) BOOL isConcatVideoLayer;


/// 是否是叠加的视频层
@property (readonly, nonatomic) BOOL isVideoLayer;

/// 是否是叠加的mv透明动画层
@property (readonly, nonatomic) BOOL isMVLayer;

/// 是否是图片层
@property (readonly, nonatomic) BOOL isImageLayer;


/// 是否是Gif图层
@property (readonly, nonatomic) BOOL isGifLayer;

/// 是否是图片数组图层
@property (readonly, nonatomic) BOOL isImageArrayLayer;


/**
  在合成中的开始时间;
  放到concat中的时候, 内部设置.
 用addXXXLayer, 是外部设置的.
 用 layerDurationS获取当前
 */
@property(readwrite,assign) CGFloat startTimeOfComp;

/**
 素材的原始时长.
 */
@property (readonly,assign)CGFloat originalDurationS;
/**
 当前图层的显示时长;
 在设置裁剪时长后, 会变化;
 */
@property (readwrite,assign) CGFloat displayDurationS;
/*
读当前合成的总时长.
(当你设置每个图层的时长后, 此属性会改变.);
*/
@property (readonly,assign) CGFloat compDurationS;

//---------------------尺寸------------
/**
  输入资源的原始大小;
 */
@property (nonatomic,readonly) CGSize originalSize;

/**
  图层在容器中的大小.
 视频放到容器中后, 默认是对齐到边缘的,故图层大小会变换;
 */
@property  (nonatomic,readonly) CGSize layerSize;
/**
 当前图层的合成尺寸;
 */
@property  (nonatomic,readonly) CGSize compositionSize;

/**
 图层是否循环播放;
 放到concat中的, 请不要设置此方法;
 */
@property (readwrite,assign) BOOL looping;

/**
 当前图层是否隐藏,
 可以用这个在新创建的图层做隐藏/显示的效果, 类似闪烁, 或创建好,暂时不显示等效果.
 */
@property(getter=isHidden) BOOL hidden;

/**
 角度值0--360度. 默认为0.0
 顺时针旋转.
 */
@property (readwrite, nonatomic)  CGFloat rotateAngle;
/**
 *
 设置或读取  <当前图层的中心点>在容器中的坐标;
 容器坐标的左上角是左上角为0,0. 从上到下 是Y轴, 从左到右是X轴;
 当一个图层增加到容器中, 则默认是:
               positionX=drawPadSize.width/2;
               positionY=drawPadSize.height/2;
 */
@property (readwrite, nonatomic) CGPoint centerPoint;

/**
 以当前显示窗口为单位, 图层的中心点;
 */
@property (readwrite, nonatomic) CGPoint centerPointInView;

/**
 设置当前位置, 枚举类型.
 */
@property (readwrite,nonatomic) LSOPositionType positionType;

/**
 缩放的枚举类型;
 */
@property (readwrite,nonatomic) LSOScaleType scaleType;

/**
 可设置选中的图层周边的颜色;
 默认是红色;
 */
@property (nonatomic, assign) UIColor *selectedColor;

/**
 缩放具体大小;
 */
@property (readwrite, nonatomic) CGSize scaleSize;

/**
 以显示窗口为单位, 缩放到的大小
 */
@property (readwrite, nonatomic) CGSize scaleSizeInView;
/**
 以显示窗口为单位, 获取图层的宽高;
 */
@property (readonly, nonatomic) CGSize layerSizeInView;

/**
 缩放因子
 1.0 不缩放;
 0.5 是缩小1倍;
 2.0是放大一倍;
 范围是0---10.0f;
 
 */
@property(readwrite, nonatomic)  CGFloat scaleFactor;
/**
 是否把缩放和位置的参数转换;
 默认是不转换;
 */
@property (readwrite, nonatomic) BOOL isConvertScalePosition;
//------------mirror(镜像)--------------
//在绘制的时候, 横向图像镜像, 左边的在右边, 右边的在左边;
@property (nonatomic,assign)BOOL mirrorDrawX;

//竖向图像镜像, 上面的放下面, 下面的放上面. 默认不调整;
@property (nonatomic,assign)BOOL mirrorDrawY;


//---------------alpha(透明)----------
/**
 调节当前画面中的RGBA 4个分量的百分比;
 如果你设置了redPercenet=0.8则表示把当前像素中的红色分量降低到80%;
 */
@property(readwrite, nonatomic) CGFloat redPercent;
@property(readwrite, nonatomic) CGFloat greenPercent;
@property(readwrite, nonatomic) CGFloat bluePercent;
@property(readwrite, nonatomic) CGFloat alphaPercent;


/**
 不透明度.
 默认是1.0; 完全透明是0.0;
 */
@property(readwrite, nonatomic) CGFloat opacityPercent;

/**
 裁剪时长的开始时间
 仅对视频有效;
 */
@property (readwrite,assign) CGFloat cutStartTimeS;
/**
 裁剪时长的结束时间;
 仅对视频有效
 */
@property (readwrite,assign) CGFloat cutEndTimeS;


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
 1.0 是默认
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
调节曝光度的百分比.
这里的百分比是两倍的关系,范围是 0--2.0; 其中 1.0 是默认值,
0---1.0是调小;
1.0 是默认,
1.0---2.0 是调大;
 如要关闭,则调整为 1.0.默认是关闭;
*/
-(void)setExposurePercent:(CGFloat)percent2X;


//-----------------------马赛克:----------
/**
 马赛克区域:
 xy以左上角开始, 左上角是0.0,0.0;
 宽度是一个百分比, 最大是 1.0;
 高度是 一个百分比. 最大是1.0;
 
 你实时传递过来的宽高和坐标, 除以当前图层的宽高,转换为百分比后设置过来,
 
 宽高坐标可以通过getCurrentRectInView 获取到当前图层在compositionView中的位置;
 
 我们举例最大4个马赛克区域;如果你需要更多的马赛克区域, 则用LSOMosaicRectFilter执行增加;
 */
@property(readwrite, nonatomic) CGRect mosaicRect1InView;
@property(readwrite, nonatomic) BOOL mosaic1Enable;
/**
 马赛克1的每个小格子的大小;
 范围0.01---0.2; 默认是0.08
 */
@property(readwrite, nonatomic) CGFloat mosaicPixelWidth1;



/// 马赛克2的方法
@property(readwrite, nonatomic) CGRect mosaicRect2InView;
@property(readwrite, nonatomic) BOOL mosaic2Enable;
@property(readwrite, nonatomic) CGFloat mosaicPixelWidth2;


/// 马赛克3的方法
@property(readwrite, nonatomic) CGRect mosaicRect3InView;
@property(readwrite, nonatomic) BOOL mosaic3Enable;
@property(readwrite, nonatomic) CGFloat mosaicPixelWidth3;


/// 马赛克4的方法
@property(readwrite, nonatomic) CGRect mosaicRect4InView;
@property(readwrite, nonatomic) BOOL mosaic4Enable;
@property(readwrite, nonatomic) CGFloat mosaicPixelWidth4;




//-------------------------FILTER(滤镜)----------------------------
/**
 设置美颜,
 范围是0.0---1.0; 0.0是关闭美颜; 默认是0.0;
 */
- (void)setBeautyLevel:(CGFloat)level;

/**
设置一个滤镜, 设置后, 之前增加的滤镜将全面清空.
类似滤镜一个一个的切换.新设置一个, 会覆盖上一个滤镜.
如果滤镜是无, 或清除之前的滤镜, 这里填nil;
*/
@property (nonatomic,nullable, copy)LanSongFilter  *filter;

/**
 增加一个滤镜,
 增加后, 会在上一个滤镜的后面增加一个新的滤镜.
 是级联的效果
 
 源图像--->滤镜1--->滤镜2--->滤镜3--->移动旋转缩放透明遮罩处理--->容器混合;
 */
-(void)addFilter:(nullable LanSongFilter *)filter;

/**
 删除一个滤镜;
 */
-(void)removeFilter:(nullable LanSongFilter *)filter;
/**
 删除所有滤镜;
 */
-(void)removeAllFilter;


/**
 调节素材中的音频音量.

 如果素材有音量,则设置, 如果没有音量,则无效;
 范围是0.0---8.0;
 1.0是原始音量; 大于1.0,是放大; 小于1.0是缩小;
 如果是0.0则无声,
 */
@property (nonatomic, assign)CGFloat audioVolume;


/**
 视频的播放速度;
 范围是 0.1---10.0
 默认1.0; 正常播放;
 建议的设置参数是:
 变慢:0.1, 0.2, 0.4, 0.6,0.8
 变快: 2.0, 3.0, 4.0, 6.0,8.0;
 当前仅是画面变速, 变速过程中暂时无声音;
 */
@property (nonatomic, assign)CGFloat videoSpeed;


/**
 给视频图层设置倒序
 
 异步是因为: 在视频第一次倒序的时候, 有一个异步预处理的过程;
 percent:预处理百分比: 0---1.0;
 当前暂时不支持声音倒序. 在倒序时, 默认音量为0;
 调用此方法,会先触发容器暂停;
 回调是在别的线程, 如执行UI的代码,则用如下代码:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
-(void)setVideoReverseAsync:(BOOL)isReverse asyncHandler:(void (^)(CGFloat percent, BOOL finish))handler;


/// 当前是否在倒序状态;
@property(nonatomic, readonly)BOOL isReverse;
//------------获取缩略图
/**
 异步 获取缩略图;
 当前是每秒钟获取一帧;, 一帧宽高最大是100x100;
 image 是获取到的每一张缩略图;
 finish是 是否获取完毕;
 
 */
- (void)getThumbnailAsyncWithHandler:(void (^)(UIImage *image, BOOL finish))handler;

/**
 在你第一次调用过getThumbnailAsyncWithHandler后. 内部会保存到这个属性中.
 在下次获取的时候, 则可以直接读取;
 */
@property(nonatomic, readwrite)  NSMutableArray<UIImage *> *thumbImageArray;

/**
 当前图层是否需要touch事件;
 默认是需要的;
 */
@property (nonatomic, assign)BOOL touchEnable;

/// 获取当前图层在容器合成中的坐标
- (CGRect ) getCurrentRectInComp;

////获取图层在显示界面上的坐标;
- (CGRect) getCurrentRectInView;

/**
 把图层恢复到刚增加时的位置和大小
 */
- (void)resetLayerLayout;

/// 当前图层是否在显示状态;
-(BOOL)isDisplay;

//-------------------动画类--------------------------------

///用AE的json形式增加一个动画
/// @param jsonPath 动画文件
/// @param atCompS 从合成容器的什么位置增加
- (LSOAnimation *) addAnimationWithJsonPath:(NSString *)jsonPath atCompS:(CGFloat) atCompS;


/// 在图层的头部增加一个动画
/// @param jsonPath 动画文件,json格式
- (LSOAnimation *) setAnimationAtLayerHead:(NSString *)jsonPath;


/// 在图层的尾部增加一个动画
/// @param jsonPath 动画文件, json格式
- (LSOAnimation *) setAnimationAtLayerEnd:(NSString *)jsonPath;


/// 删除一个动画
/// @param animation 动画对象,在addAnimation的时候增加的.
- (void)removeAnimation:(LSOAnimation *)animation;


/// 删除所有动画
- (void)removeAllAnimationArray;

/// 获取所有的动画对象数组
- (NSMutableArray *)getAllAnimationArray;



/// 预览一个动画
/// @param animation 预览会从动画的开始时间点,播放到结束时间点;
-(BOOL) playAnimation:(LSOAnimation *)animation;
//----------------------------------特效类----------------------------------------

/// 用AE的json文件形式在指定时间点增加一个特效
/// @param jsonPath 特效的json
/// @param atCompS 从容器的指定时间点
- (LSOEffect *) addEffectWithJsonPath:(NSString *)jsonPath atCompS:(CGFloat) atCompS;


/// 在图层的头部增加一个特效
/// @param jsonPath 特效的json文件
- (LSOEffect *) addEffectWithJsonAtLayerHead:(NSString *)jsonPath;


/// 在图层的尾部增加一个特效
/// @param jsonPath 特效的json文件
- (LSOEffect *) addEffectWithJsonAtLayerEnd:(NSString *)jsonPath;


/// 删除一个特效,
/// @param effect 特效对象,从addEffectXXX得到的特效对象
- (void)removeEffect:(LSOEffect *)effect;


/// 删除所有的特效
- (void)removeAllEffectArray;


/// 预览一个特效
/// @param effect 预览会从特效的开始时间点,播放到结束时间点;
-(BOOL) playEffect:(LSOEffect *)effect;


/// 获取所有的特效对象数组
- (NSMutableArray *)getAllEffectArray;
//------------------转场类方法
/**
 设置转场的动画路径, json格式;
 可通过这个获取是否设置了转场; 如果要取消转场;则这里等于nil;
 设置后, 默认转场时间为1秒;
 */
@property(readwrite, assign)NSURL *transitionJsonUrl;
/**
 设置或获取转场时间
 在设置转场后有效;
 时间范围是0---5.0秒;
 如转场时间 大于图层时间, 则等于图层时间;
 */
@property(readwrite, assign)CGFloat transitionDurationS;

/**
 预览转场;
 你需要在设置转场后调用才有效;
 */
- (BOOL)playTransition;
/**
 取消转场
 */
- (void)cancelTransition;
/**
 转场相对于合成的 开始时间;
 */
@property (nonatomic, readonly) CGFloat transitionStartTimeOfCompS;

/**
 如果是拼接的是视频, 或叠加的是视频, 则可以获取到videoURL路径;
 */
@property (readwrite,nonatomic)NSURL *videoURL;
















/**
*/




@end
NS_ASSUME_NONNULL_END
