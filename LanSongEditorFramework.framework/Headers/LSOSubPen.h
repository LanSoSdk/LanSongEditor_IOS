//
//  LSOSubPen.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/4/9.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LanSongOutput.h"
#import "LanSongTwoInputFilter.h"
#import "LSOObject.h"

/**
 子图层: 复制当前图层的画面; 得到独立的一个图层, 可移动旋转缩放,透明度设置等;
 举例有:抖音效果;
 暂时不支持滤镜;
 */
@interface LSOSubPen : LSOObject

//-------------------------------------------------

/**
 给图层设置一个标记;
 */
@property(readwrite, nonatomic) NSString *tag;

@property(nonatomic, assign,readonly)BOOL isRunning;


/**
 当前图层的大小
 */
@property(readwrite, nonatomic) CGSize penSize;


/**
 容器的大小
 */
@property(readwrite, nonatomic) CGSize drawPadSize;


/**
 是否隐藏当前图层;
 */
@property(getter=isHidden) BOOL hidden;
/**
 角度值0--360度. 默认为0.0
 */
@property(readwrite, nonatomic)  CGFloat rotateDegree;
/**
 *
 设置或读取  <当前图层的中心点>在容器中的坐标;
 容器坐标的左上角是左上角为0,0. 从上到下 是Y轴, 从左到右是X轴;
 */
@property(readwrite, nonatomic)  CGFloat positionX, positionY;

/**
 
 缩放因子, 大于1.0为放大, 小于1.0为缩小. 默认是1.0f
 
 */
@property(readwrite, nonatomic)  CGFloat scaleWidth,scaleHeight;


/// 设置当前位置, 枚举类型.
@property(readwrite,nonatomic) LSOPosition position;

/// 设置当前图层的显示范围
/// 如果你只想设置开始时间,则endS=CGFLOAT_MAX
/// @param startS 相对容器的开始时间, 单位秒, 可以有小数, 最小值是0;
/// @param endS 相对容器的结束时间, 单位秒, 可以有小数,最大值是: CGFLOAT_MAX;
-(void)setDisplayTimeRange:(CGFloat)startS endTimeS:(CGFloat)endS;

/**
 直接缩放到的值,
 如果要等于把图片覆盖整个容器, 则值直接等于drawpadSize即可.
 */
@property(readwrite, nonatomic)  CGFloat scaleWidthValue,scaleHeightValue;


/**
 调节当前画面中的RGBA 4个分量的百分比;
 如果你设置了redPercenet=0.8则表示把当前像素中的红色分量降低80%;
 */
@property(readwrite, nonatomic) CGFloat redPercent;
@property(readwrite, nonatomic) CGFloat greenPercent;
@property(readwrite, nonatomic) CGFloat bluePercent;
@property(readwrite, nonatomic) CGFloat alphaPercent;
/**
 同时设置 RGBA的百分比;
 */
-(void) setRGBAPercent:(CGFloat)value;

//------------mirror(镜像)--------------
//在绘制的时候, 横向图像镜像, 左边的在右边, 右边的在左边;
@property (nonatomic,assign)BOOL mirrorDrawX;
//竖向图像镜像, 上面的放下面, 下面的放上面;
@property (nonatomic,assign)BOOL mirrorDrawY;
//------------------区域显示方法;
/**
 设置当前图层画面的可见区域: 四方形

 x是从左到右. 范围是0.0--1.0; 你可以认为是百分比,和视频宽高无关;
 y是从上到下; 范围是0.0--1.0;
 @param startX 始透明的开始X坐标
 @param endX 透明的结束X坐标 最大是1.0;
 @param startY 透明的开始Y坐标
 @param endY 透明的结束Y坐标,最大是1.0;
 */
-(void)setVisibleRectWithX:(CGFloat)startX endX:(CGFloat)endX startY:(CGFloat)startY endY:(CGFloat)endY;
/**
 设置当前图层画面的可见区域:圆形
 此操作不变化画面本身的宽高,只是设置一部分显示, rect范围外的图像透明;
 @param radius 圆的半径. 范围:0.0--1.0; 默认是0.2f;
 @param center 圆的中心点. 范围是0.0---1.0f;默认是中间:(0.5,0.5)
 */
-(void)setVisibleCircle:(CGFloat) radius center:(CGPoint) center;

/**
 当设置四方形的可见区域后, 可以给四方形增加边缘颜色;
 
 @param width 边缘的宽度
 @param red   RGBA分量中的Red 范围是0.0f---1.0f
 @param green 绿色
 @param blue 蓝色分量
 @param alpha 透明分量  颜色的透明度,建议是1.0;
 */
-(void)setVisibleRectBorder:(float) width red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
/**
 *当设置圆形的可见区域后, 可以给圆增加边缘颜色;
 * @param width 厚度,最大是1.0, 最小是0.0, 推荐是0.01f
 * @param r     RGBA分量中的Red 范围是0.0f---1.0f
 * @param g
 * @param b
 * @param a  颜色的透明度,建议是1.0;
 */
-(void)setVisibleCircleBorder:(float) width red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
//-----------------------------------------------------


/**
 删除所有滤镜;
 */
-(void)removeAllFilter;
/**
 *  切换滤镜, 默认是没有滤镜.
 因为IOS端的GPUImage开源库很强大, 这里兼容GPUImage库,您也可以根据自己的情况扩展GPUImage相关的效果.
 *  @param filter 滤镜对象.
 */
-(void)switchFilter:(LanSongOutput<LanSongInput> *)filter;
/**
 切换滤镜, 这里是滤镜级联(滤镜叠加)
 
 只增加两头的;
 举例1:
 3个滤镜级联:视频图层--经过 A滤镜 --->B滤镜--->C滤镜--->DrawPad编码
 则这里应该填写的是 startFilter=A滤镜;
 endFilter=C滤镜;
 B滤镜的使用代码是: [A滤镜 addTarget B滤镜];  [B滤镜 addTarget C滤镜];  C滤镜才是填入到我们endFilter中的值.
 
 举例2:
 2个滤镜级联:视频图层-->A滤镜-->B滤镜-->DrawPad编码
 则这里 startFilter=A滤镜;
 endFilter=B滤镜;
 您代码中应该有 [A addTarget B]; 这样的代码.
 比如代码如下:
 LanSongSepiaFilter *sepiaFilter=[[LanSongSepiaFilter alloc] init];
 LanSongSwirlFilter *swirlFilter=[[LanSongSwirlFilter alloc] init];
 [sepiaFilter addTarget:swirlFilter];
 
 [camDrawPad.cameraPen switchFilterWithStartFilter:sepiaFilter endFilter:swirlFilter];
 
 @param startFilter 切换的第一个滤镜
 @param endFilter  切换的最后一个滤镜.
 */
-(void)switchFilterWithStartFilter:(LanSongOutput<LanSongInput> *)startFilter endFilter:(LanSongOutput<LanSongInput> *)endFilter;
/**
 切换滤镜,
 切换到的目标滤镜需要第二个输入源的情况;
 
 @param filter 切换到的滤镜
 @param secondInput filter的第二个输入源, 一般用在各种Blend类型的滤镜中
 */
-(void)switchFilter:(LanSongTwoInputFilter *)filter secondInput:(LanSongOutput *)secondFilter;

//*****************下是内部使用******************************************************************************/
-(BOOL)isDisplay;
-(void)updateDrawPadPts:(CGFloat)ptsS;
-(void)setDriverSource:(LanSongOutput *)outSource;
-(void)removeDriverSource:(LanSongOutput *)outSource;
- (id)initWithPenSize:(CGSize)penSize DrawPadSize:(CGSize)size;
-(void)loadParam:(LanSongContext*)context;
- (void)draw;
- (void)drawDisplay;

@end
