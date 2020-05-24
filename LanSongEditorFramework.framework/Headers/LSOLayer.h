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

#import "LSOSubPen.h"
#import "LSOAnimation.h"

@class LSOMaskAnimation2;



NS_ASSUME_NONNULL_BEGIN

@interface LSOLayer : LanSongOutput
{
      NSObject *framebufferLock;  //数据的同步锁. 内部使用.
}
/**
 *  当前图层的类型
 */
@property(readwrite, nonatomic) LSOLayerType2 layerType;

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
@property (readonly,assign)CGFloat assetDurationS;
/**
 当前图层的时长;
 在设置裁剪时长后, 会变化;
 */
@property (readwrite,assign) CGFloat layerDurationS;
/*
读当前合成的总时长.
(当你设置每个图层的时长后, 此属性会改变.);
*/
@property (readonly,assign) CGFloat compDurationS;

//---------------------尺寸------------

/**
  输入资源的原始大小;
 */
@property (nonatomic,readonly) CGSize assetSize;

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
@property (readwrite, nonatomic) CGPoint positionPoint;

/**
 设置当前位置, 枚举类型.
 */
@property (readwrite,nonatomic) LSOPositionType positionType;

/**
 缩放的枚举类型;
 */
@property (readwrite,nonatomic) LSOScaleType scaleType;

//选中当前图层的时候, 在图层画面的四周增加颜色(或颜色可变;)
@property (readwrite, nonatomic) BOOL selected;

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
 缩放因子
 */
@property(readwrite, nonatomic)  CGFloat scaleFactor;

/**
 当设置缩放因子完毕后, 调用通知end;
 */
-(void)notifyScaleFactorEnded;
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
 不透明度. 等于同时设置RGBA;
 */
@property(readwrite, nonatomic) CGFloat opacityPercent;


/**
 同时设置 RGBA的百分比;
 也是设置透明度的值. 默认是 1.0 为完全不透明, 0.0 是透明.
 */
-(void) setRGBAPercent:(CGFloat)value;
//-------------------各种颜色调节-----------------
/**
 (weak需求): 把所有的调节放到一个Object中, 然后应用到所有的时候, 直接把这个Object应用到所有layer中.
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

//-(void)setFilter:(nullable LanSongFilter *)filter;

/**
 增加一个滤镜,
 增加后, 会在上一个滤镜的后面增加一个新的滤镜.
 是级联的效果
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
 0.1--1.0是放慢; 0.1是放慢10倍;
 1.0--10.0 是加快, 10.0是加速10倍;
 */
@property (nonatomic, assign)CGFloat videoSpeed;







@end
NS_ASSUME_NONNULL_END
