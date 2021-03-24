//
//  LSOVLogLayer.h
//  LanSongEditorFramework
//
//  Created by sno on 2021/3/5.
//  Copyright © 2021 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "LanSongContext.h"
#import "LanSongOutput.h"
#import "LanSongFilter.h"
#import "LanSongTwoInputFilter.h"
#import "LSOFileUtil.h"


@class LSOEffect;
@class LSOAnimation;
@class LSOSubLayer;

NS_ASSUME_NONNULL_BEGIN

@interface LSOVLogLayer : LanSongOutput
{
      NSObject *framebufferLock;  //数据的同步锁. 内部使用.
}

/**
 *  当前图层的类型
 */
@property(readwrite, nonatomic) LSOLayerType2 layerType;


/// 是否是叠加的视频层
@property (readonly, nonatomic) BOOL isVideoLayer;

/// 是否是叠加的mv透明动画层
@property (readonly, nonatomic) BOOL isMVLayer;

/// 是否是图片层
@property (readonly, nonatomic) BOOL isImageLayer;




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
 用户自己设置的各种选项,内部没有使用;
 */
@property(nonatomic,readwrite) NSObject *userSetting;

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
 预览时有效
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
 缩放到图层在容器中的具体大小;
 */
@property (readwrite, nonatomic) CGSize scaleSize;

/**
 以显示窗口为单位, 缩放大小, 此宽高是相对于LSODisplayView而言;
 预览时有效
 */
@property (readwrite, nonatomic) CGSize scaleSizeInView;


/**
 以显示窗口为单位, 获取图层的宽高;
 预览时有效
 */
@property (readonly, nonatomic) CGSize layerSizeInView;

/**
 缩放系数
 从视频或图片放入到容器中的默认缩放大小为基准, 乘以缩放系数;
 */
@property(readwrite, nonatomic)  CGFloat scaleFactor;
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






//-------------------各种颜色调节-----------------
/**
 调节亮度的百分比.
 这里的百分比是两倍的关系,范围是 0--2.0; 其中 1.0 是默认值,
 0---1.0是调小;
 1.0 是默认,
 1.0---2.0 是调大;
 如要关闭,则调整为 1.0.默认是关闭;
 */
@property (readwrite, assign) CGFloat brightnessPercent;
/**
 调节对比度的百分比.
 这里的百分比是两倍的关系,范围是 0--2.0; 其中 1.0 是默认值,
 0---1.0是调小;
 1.0 是默认,
 1.0---2.0 是调大;
 如要关闭,则调整为 1.0.默认是关闭;
 */
@property (readwrite, assign) CGFloat contrastFilterPercent;
/**
 调节饱和度的百分比.
 这里的百分比是两倍的关系,范围是 0--2.0; 其中 1.0 是默认值,
 0---1.0是调小;
 1.0 是默认
 1.0---2.0 是调大;
  如要关闭,则调整为 1.0.默认是关闭;
 */
@property (readwrite, assign) CGFloat saturationFilterPercent;
/**
调节锐化的百分比.
这里的百分比是两倍的关系,范围是 0--2.0; 其中 1.0 是默认值,
0---1.0是调小;
1.0 是默认,
1.0---2.0 是调大;
 如要关闭,则调整为 1.0.默认是关闭;
*/
@property (readwrite, assign) CGFloat sharpFilterPercent;
/**
调节色温的百分比.
这里的百分比是两倍的关系,范围是 0--2.0; 其中 1.0 是默认值,
0---1.0是调小;
1.0 是默认,
1.0---2.0 是调大;
 如要关闭,则调整为 1.0.默认是关闭;
*/
@property (readwrite, assign) CGFloat whiteBalanceFilterPercent;
/**
调节色调的百分比.
这里的百分比是两倍的关系,范围是 0--2.0; 其中 1.0 是默认值,
0---1.0是调小;
1.0 是默认,
1.0---2.0 是调大;
 如要关闭,则调整为 1.0.默认是关闭;
*/
@property (readwrite, assign) CGFloat hueFilterPercent;
/**
调节曝光度的百分比.
这里的百分比是两倍的关系,范围是 0--2.0; 其中 1.0 是默认值,
0---1.0是调小;
1.0 是默认,
1.0---2.0 是调大;
 如要关闭,则调整为 1.0.默认是关闭;
*/
@property (readwrite, assign) CGFloat exposurePercent;

/// 暗角设置获取;
@property (readwrite, assign) CGFloat vignetteFilterPercent;



/// 17个滤镜的设置; 
@property (readwrite, assign) CGFloat ifFilterPercent;

//-----------------------------------
/**
 是否绿幕抠图
 */
@property (nonatomic,assign) BOOL isGreenMatting;

/**
 绿幕抠图的调节级别
 范围是:
 0--1.0f;
 0是禁止抠像; 0.1抠的很弱; 0.5适中; 1.0是抠的最强(可能会把一些不是绿的也抠去;
 */

@property (nonatomic,assign) CGFloat greenMattingLevel;

//-------------------------FILTER(滤镜)----------------------------
/**
 设置美颜,
 范围是0.0---1.0; 0.0是关闭美颜; 默认是0.0;
 */
@property (readwrite,nonatomic) CGFloat beautyLevel;

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
 
 源图像--->滤镜1--->滤镜2--->滤镜3--->移动旋转缩放透明遮罩处理--->与别的图层做混合;
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
 1.0是原始音量; 大于1.0,是放大; 小于1.0是减低, 如果降低建议是0.1;
 如果是0.0则无声,
 */
@property (nonatomic, assign)CGFloat audioVolume;  



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


/**
 如果是拼接的是视频, 或叠加的是视频, 则可以获取到videoURL路径;
 */
@property (readwrite,nonatomic)NSURL *videoURL;


/**
 拼接或叠加一张图片时, 增加的图片对象;
 */
@property (readwrite,nonatomic)UIImage *uiImage;









 





 


//合成的帧率;












@property (readwrite, nonatomic) NSMutableArray *keyFrameArray;


@property(nonatomic, assign)BOOL isEndLayer;





- (void)setEndTextBuffer:(LanSongFramebuffer *)buffer bufferSize:(CGSize)size;



@end
NS_ASSUME_NONNULL_END
