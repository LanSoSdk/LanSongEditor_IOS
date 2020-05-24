//
//  Pen.h
//  LanSongEditorFramework
//
//  Created by sno on 16/12/21.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LanSongContext.h"
#import "LanSongOutput.h"
#import "LanSongFilter.h"
#import "LanSongTwoInputFilter.h"

#import "LSOSubPen.h"
#import "LSOAnimation.h"







/**
 因为图层的的单词是Layer, 而'Layer'单词被IOS的UI使用了, 为了不使您代码中的对象命名混乱,
 我们用Pen这个单词作为图层的父类, 只是单词变化了,和Android版本的一样是图层的意思, 一样每个图层均支持移动缩放旋转滤镜等特性
 */
@interface LSOPen : LanSongOutput
{
      NSObject *framebufferLock;  //数据的同步锁. 内部使用.
}
/**
 *  当前图层的类型
 */
@property(readwrite, nonatomic) PenTpye penType;

@property(readwrite, nonatomic) NSString *tag;

@property (readwrite, nonatomic) LanSongFramebuffer *frameBufferTarget;

@property (readonly, nonatomic) CMTime currentFrameTime;

/**
 内部使用.
 当然图层是否在运行.
 */
@property(nonatomic, assign,readonly)BOOL isRunning;


/**
 DrawPadCamereaPreview使用时, 相机图层录制时,前置相机是否镜像录制;
 */
@property BOOL isCamFrontMirror;

/**
    在绘制到容器上时的初始尺寸.   为固定值,不随图层的缩放变化而变化.
    如果你要获取当前画面的实时尺寸,则可以通过上面的frameBufferSize这个属性来获取. 缩放也是基于frameBufferSize进行的.
    此尺寸可以作为移动的参考.
  当前绘制原理是:ViewPen是等比例缩放到容器上, BitmapPen和ViewPen和CALayerPen, 则是1:1渲染到容器上.
 */
@property (nonatomic,readwrite) CGSize penSize;
/**
 *  容器尺寸
 */
@property(readwrite, nonatomic) CGSize drawPadSize;



/// 从容器的什么位置开始;在setDisplayTimeRange中设置
@property(nonatomic,assign) CGFloat startSFromDrawPad;


/// 从容器的什么位置结束 在setDisplayTimeRange中设置
@property(nonatomic,assign) CGFloat endSFromDrawPad;


/**
 当前图层在容器里的位置. 最里面是0, 最外面是图层最数量-1;
 */
@property int  indexInDrawPad;

/**
 当前图层是否隐藏, 
 可以用这个在新创建的图层做隐藏/显示的效果, 类似闪烁, 或创建好,暂时不显示等效果.
 */
@property(getter=isHidden) BOOL hidden;


/// 设置当前图层的显示范围
/// 如果你只想设置开始时间,则endS=CGFLOAT_MAX
/// @param startS 相对容器的开始时间, 单位秒, 可以有小数, 最小值是0;
/// @param endS 相对容器的结束时间, 单位秒, 可以有小数,最大值是: CGFLOAT_MAX;
-(void)setDisplayTimeRange:(CGFloat)startS endTimeS:(CGFloat)endS;

/**
 角度值0--360度. 默认为0.0
 顺时针旋转.
 以视频的原视频角度为旋转对象,
 基本等同于CGAffineTransformRotate
 */
@property(readwrite, nonatomic)  CGFloat rotateDegree;
/**
 *  
 设置或读取  <当前图层的中心点>在容器中的坐标;
 容器坐标的左上角是左上角为0,0. 从上到下 是Y轴, 从左到右是X轴;
 
 当一个图层增加到容器中, 则默认是:
               positionX=drawPadSize.width/2;
               positionY=drawPadSize.height/2;
 */
@property(readwrite, nonatomic)  CGFloat positionX, positionY;


/**
 设置当前位置, 枚举类型.
 当前只对图片图层有作用;
 */
@property(readwrite,nonatomic) LSOPosition position;

/**
 *  
 缩放因子, 大于1.0为放大, 小于1.0为缩小. 默认是1.0f
 如果是图片, 则默认以图片的宽高为缩放基数.来放大或缩小
 
 如果是视频,则以当前drawpad的大小为缩放基数, 来放大或缩小.
 
 注意: 此缩放, 是针对正要渲染的Pen进行缩放, 不会更改frameBufferSize和penSize.
 */
@property(readwrite, nonatomic)  CGFloat scaleWidth,scaleHeight;


/**
 设置缩放系数大小,0.5 则缩小一倍;
 同时缩放当前图层的宽度和高度, 内部代码等于设置:scaleWidth,scaleHeight
 此方法只用来写入;,
 */
@property(readwrite, nonatomic)  CGFloat scaleWH;
/**
 直接缩放到的值,
 如果要等于把图片覆盖整个容器, 则值直接等于drawpadSize即可.
 */
@property(readwrite, nonatomic)  CGFloat scaleWidthValue,scaleHeightValue;

//

/// 让当前图层全部覆盖整个容器, 无论图片的比例如果, 都完整的覆盖整个容器;
@property(readwrite, nonatomic) BOOL  fillScale;

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
 同时设置 RGBA的百分比;
 也是设置透明度的值. 默认是 1.0 为完全不透明, 0.0 是透明.
 
 */
-(void) setRGBAPercent:(CGFloat)value;
//----------------visible rect(可视区域设置)------------------------
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


//-------------------------FILTER(滤镜)----------------------------
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





/**
 增加一个子图层, 内部维护一个数组, 把每次增加的 子图层放到数组里
 @return 返回增加后的子图层对象
 */
-(LSOSubPen *)addSubPen;

/**
 删除指定子图层
 @param pen 指定子图层对象
 */
-(void)removeSubPen:(LSOSubPen *)pen;

/**
 删除最后一个子图层
 */
-(void)removeLastSubPen;

/**
 删除所有子图层
 */
-(void)removeAllSubPen;

/**
 获取子图层的数量;
 */
-(int)getSubPenSize;


/**
 在图层的最后几秒的地方增加一个转场动画,当前仅是DrawPadAllPreview和DrawPadAllExecute可用
 当前仅支持LSOMaskAnimation; 增加后, 覆盖之前的动画;
 如果是AeAnimation则直接在LSOVideoFramePen2对象中增加
 完全等于switchAnimationAtEnd. 只是addXXX好记,特意写一个;
 */
-(BOOL)addAnimationAtEnd:(LSOAnimation *)animation;
/**
 在图层的最后几秒的地方增加一个转场动画,当前仅是DrawPadAllPreview和DrawPadAllExecute可用
 当前仅支持LSOMaskAnimation; 增加后, 覆盖之前的动画;
 如果是AeAnimation则直接在LSOVideoFramePen2对象中增加
 完全等于switchAnimationAtEnd. 只是addXXX好记,特意写一个;
 */
-(BOOL)addAnimationAtEnd:(LSOAnimation *)animation OverlapTime:(CGFloat)timeS;

/// 在图层的最后几秒的地方增加一个转场动画,当前仅是DrawPadAllPreview和DrawPadAllExecute可用
/// 当前仅支持LSOMaskAnimation; 增加后, 覆盖之前的动画;
/// 如果是AeAnimation则直接在LSOVideoFramePen2对象中增加
/// @param animation动画类,当前仅支持LSOMaskAnimation
-(BOOL)switchAnimationAtEnd:(LSOAnimation *)animation;


/// 在图层的最后几秒的地方增加一个转场动画,当前仅是DrawPadAllPreview和DrawPadAllExecute可用
/// 当前仅支持maskAnimation;
/// 如果是AeAnimation则直接在LSOVideoFramePen2对象中增加
/// @param animation 动画类,当前仅支持LSOMaskAnimation
/// @param timeS 在DrawPadAllPreview 和DrawPadAllExecute中设置的两个视频的重叠时间,默认是0.5f;
-(BOOL)switchAnimationAtEnd:(LSOAnimation *)animation OverlapTime:(CGFloat)timeS;;

/**
 ************** 一下为 内部使用的函数. 请勿调用 ****************************************************************
 */
- (id)initWithDrawPadSize:(CGSize)size drawpadTarget:(id<LanSongInput>)target penType:(PenTpye) type;
//视频在容器中是否 以原尺寸增加;
/**
 原尺寸对齐
 
 说明如下:
 1. 如果视频宽高大于容器宽高,则视频会显示到容器外面,如果小于则显示到内部;
 2. 举例:比如视频宽高是1280*720; 如果你设置的iphone 6plus,他的self.view.frame.size是414x736;则只会显示视频居中的414x736的局域画面; 视频的高度是720;但屏幕是736;则会居中显示, 画面的上方和下方有8个像素的黑边;(736-720=16/2=8);
 
 3.如果要视频的宽度和容器的宽度对齐,则缩放是:videoPen.scaleWH=videoPen.drawPadSize.width/videoPen.penSize.width;
 4.如果要视频的高度和容器高度对齐,则缩放是:videoPen.scaleWH=videoPen.drawPadSize.height/videoPen.penSize.height;
 5.视频的移动以原视频的尺寸移动; videoPen.penSize等于视频的宽高;
 6. 视频在编码时,建议最好是540x960或 1280x720,或640x640,会把容器的画面填满到您设置的编码分辨率.
*/
@property (nonatomic,assign) BOOL videoPenOriginalAdd;
@property (nonatomic,assign) BOOL videoPenfillDraw;
@property (nonatomic,assign) BOOL mvPenOriginalAdd;


/// 当前容器处理帧的时间戳;
@property (nonatomic,assign) CGFloat currentPadPtsS;
/// 暂停当前帧;
@property(readwrite,assign) BOOL pauseFrame;
@property (nonatomic,assign) BOOL disableSetDisplayRange;

-(void)updateDrawPadPts:(CGFloat)ptsS;
-(BOOL)isDisplay;


-(BOOL)decodeOneFrame:(CGFloat)padCurrentFramePtsS;

-(void)setSeekMode:(BOOL)seekMode;
-(void)resetToStartTime;

-(void)drawDisplay2;
- (void)draw:(LanSongContext *)context;


-(void)drawSubPenEncoder:(LanSongContext *)context;
-(void)drawSubPenDisplay;
- (void)draw1Lock;
- (void)draw2Lock;
- (void)draw1Unlock;
- (void)draw2Unlock;
-(void)setDriverTarget1:(id<LanSongInput>)driver1;
-(void)setDriverTarget2:(id<LanSongInput>)driver2;
-(void)resetEncoderProgram;
-(void)loadParam:(LanSongContext*)context;
-(void)loadShader;
- (void)startProcessing:(BOOL)isAutoMode;
-(void)endProcessing;
-(BOOL) isFrameAvailable;
-(void)setFrameAvailable:(BOOL)is;
-(void)setDriveDraw:(BOOL)is;
-(void)resetCurrentFrame;
-(void)sendToLanSong2:(CMTime)time;
-(void)sendTolanSong2Finish;
-(void)updatePenTask;
-(void)onAfterDisplay;


@end
