//
//  DrawPad.h
//  LanSongEditorFramework
//
//  Created by sno on 16/12/28.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LanSong.h"
#import "VideoPen.h"
#import "BitmapPen.h"
#import "ViewPen.h"
#import "CameraPen.h"
#import "MVPen.h"
#import "CALayerPen.h"
#import "DataPen.h"



typedef NS_ENUM(NSUInteger, DrawPadUpdateMode) {
    //当所有的pen准备好时,刷新,默认采用这个刷新模式; 当有主视频图层时,自动设置为这种模式
    kPenReadyUpdate,
    
    //自动定时器刷新; 适用于照片影集等需要自动按照定时器来刷新的场合.
    kAutoTimerUpdate,
};
/**
 *  这个类是仅用作DrawPadView和 DrawPadExecute的父类使用, 不可独立创建对象,
 内部使用.
 */
@interface DrawPad : NSObject

/**
 *    DrawPad执行完成后的回调.
 
 注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....CODEC....
 });
 */
@property(nonatomic, copy) void(^onCompletionBlock)(void);

/**
 *     DrawPad执行过程中的进度对调, 返回的当前时间戳 单位是秒.
 
 注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....CODEC....
 });
 */
@property(nonatomic, copy) void(^onProgressBlock)(CGFloat);


//[LanSongContext sharedImageProcessingContext] context] 获取当前drawpad中的context;
@property(nonatomic, copy) void(^onBeforeDrawPenBlock)(CGFloat);
@property(nonatomic, copy) void(^onAfterDrawPenBlock)(CGFloat);

/**
 *  drawPad的高度和宽度.注意:这里是像素值, 不是屏幕点,如果您使用, 要根据layer.contentScale来得到屏幕点.
 */
@property CGFloat drawPadWidth;
@property CGFloat drawPadHeight;

@property CGSize  drawpadSize;

/**
 是否前台播放. 内部使用.
 */
@property BOOL isForeGround;

//当前容器 DrawPad是否在工作.
@property  BOOL isWorking;


/**
 初始化容器容器,

 @param padWidth 这个容器的宽度, 也即是视频录制后的宽度
 @param padHeight 容器的高度, 即视频录制后的高度
 @param dstPath 保存的路径
 @return
 */
- (id)initWithWidth:(CGFloat)padWidth height:(CGFloat)padHeight dstPath:(NSString *)dstPath;

- (id)initWithWidth:(CGFloat)padWidth height:(CGFloat)padHeight bitrate:(int)bitrate dstPath:(NSString *)dstPath;
/**
 *  增加主视频, 如果有主视频,则以主视频的时间为准,
    增加主视频后, 如果您后面再次设置了自动模式, 则自动模式无效.以主视频为的时间戳作为生成视频的时间戳.
 *
 *
 增加后, 视频画面如果宽度大于高度, 则会把宽度等于DrawPad的宽度, 然后调整高度.
 如果高度 大于宽度, 则会把高度等于Drawpad的高度, 等比例调整宽度.
 
 *  @param videoPath 文件的绝对路径
 *  @param filter    可以给视频增加一个LanSongFilter的滤镜
 *
 *  @return
 */
-(VideoPen *)addMainVideoPen:(NSString *)videoPath filter:(LanSongFilter *)filter;

/**
 *  增加视频图层
 *  增加后, 视频画面如果宽度大于高度, 则会把宽度等于DrawPad的宽度, 然后调整高度.
             如果高度 大于宽度, 则会把高度等于Drawpad的高度, 等比例调整宽度.
 *  @param videoPath 文件的绝对路径
 *  @param filter    滤镜, 不增加设置为nil
 *
 *  @return
 */
-(VideoPen *)addVideoPen:(NSString *)videoPath filter:(LanSongFilter *)filter;
/**
 向容器中增加一个MV图层, 以用来显示MV效果.
  增加后, 会1:1的放置到容器DrawPad中, 您可以用缩放宽高来调整画面的显示大小.
 
 @param colorPath mv视频的彩色视频
 @param maskPath  mv视频中的黑白视频
 @param filter  可以给mv效果设置一个滤镜,如果不需要,设置为null
 @return  返回MV图层对象.
 */
-(MVPen *)addMVPen:(NSString *)colorPath  maskPath:(NSString *)maskPath filter:(LanSongFilter *)filter;

/**
 *  增加图片图层, 增加后, 会1:1的放置到容器DrawPad中, 您可以用缩放宽高来调整图片的显示大小.
 * 
 *  @param inputImage
 *  @return
 */
-(BitmapPen *)addBitmapPen:(UIImage *)inputImage;

/**
 *  增加 UI图层
 *  增加后, 会1:1的放置到容器DrawPad中, 您可以用缩放宽高来调整画面的显示大小.
 
 *  @param view   大小,建议尽量等于容器的大小. 如果你增加文字, 可以把先创建一个透明的UIView 等比例于视频的宽高, 然后再这个UIView上增加别的控件.
 *  @param fromUI 这个view是否属于UI界面的一部分, 如果您已经把这个View 增加到UI界面上,则这里应设置为NO,从而容器在渲染的时候, 不会再次渲染到预览画面上
 *
 *  @return
 */
-(ViewPen *)addViewPen:(UIView *)view fromUI:(BOOL)fromUI;


/**
 向DrawPad中增加一个CALayer 
 增加后, 会1:1的放置到容器DrawPad中, 您可以用缩放宽高来调整画面的显示大小.
 
 注意, 因IOS的UI是采用[点]的概念, 而我们的DrawPad里是[像素], 像素和点呈现在屏幕上是有偏差的, 
 因增加到DrawPad后的CALayer,也会显示到屏幕上, 作为预览使用. 建议您不要再增加到屏幕上,

 @param inputLayer 创建好的CALayer对象. ,建议先创建一个透明的CALayer,大小等于DrawPad的大小, 然后在这个CAlayer中增加别的控件.
 @param fromUI 是否来自UI, 建议设置为NO,即增加到DrawPad上的calayer不要再增加到其他UIView中.
 @return 图层对象
 */
-(CALayerPen *)addCALayerPenWithLayer:(CALayer *)inputLayer fromUI:(BOOL)fromUI;
/**
 *  删除一个图层
 */
-(void)removePen:(Pen *)pen;


/**
交换两个图层的位置

@param first 第一个图层对象
@param second 第二个图层对象
*/
-(void)exchangePenPosition:(Pen *)first second:(Pen *)second;

/**
 设置图层的位置
 
 @param pen 图层对象
 @param index 位置, 最里层是0, 最外层是 getPenSize-1
 */
-(void)setPenPosition:(Pen *)pen index:(int)index;
/**
 获取当前图层的个数.
 */
-(int)getPenSize;
//-------------------------------------------------------

/**
 *  为前台容器增加一个预览view界面
 *
 *  @param preview
 */
-(void) setDrawPadPreView:(UIView *)preview;

/**
 *  获取容器的宽度
 */
-(CGFloat)getDrawPadWidth;

/**
 *  获取容器的高度.
 */
-(CGFloat)getDrawPadHeight;

/**
 *  设置刷新模式
 *
 *  注意:一定需要在 startDrawPad开始之前使用.
 *
 *  @param mode 模式
 *  @param fps  当是自动刷新时使用的帧率, 如是PenReady模式,则这里不起作用.
 */
-(void)setUpdateMode:(DrawPadUpdateMode)mode autoFps:(CGFloat)fps;
/**
 *  开始执行.
 */
-(BOOL)startDrawPad;
/**
 *  停止工作
 注意: 调用stopDrawPad 不会返回CompletedCallBack的回调, 
 因为不确定你是返回, 还是希望的时间到而停止的.请注意.
 */
-(void)stopDrawPad;

/**
 *  设置图层的背景颜色, 默认是黑色,
 *
 *  @param redComponent   红色, 值0.0f---1.0f
 *  @param greenComponent 绿色 值0.0f---1.0f
 *  @param blueComponent  蓝色 值0.0f---1.0f
 *  @param alphaComponent 透明度 值0.0f---1.0f
 */
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;


/**
 给当前使用的容器设置一个TAG, 以方便打印出来使用.
 */
@property (nonatomic,readwrite) NSString *TAG;
@end
