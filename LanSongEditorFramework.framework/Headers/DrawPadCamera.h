//
//  DrawPadCamera.h
//  LanSongEditorFramework
//
//  Created by sno on 2017/9/12.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "Pen.h"
#import "CameraPen.h"
#import "DrawPadView.h"

#import "ViewPen.h"
#import "VideoPen.h"
#import "CALayerPen.h"
#import "MVPen.h"
#import "BitmapPen.h"



@interface DrawPadCamera : NSObject


/**
 获取当前的摄像头图层.
 */
@property CameraPen  *cameraPen;

@property CGFloat drawPadWidth;
@property CGFloat drawPadHeight;

@property CGSize  drawpadSize;


@property   BOOL  isRecording;
@property   BOOL  isRunning;


/**
 是否录制声音. 
 输入类型.
 默认是录制声音.
 */
@property BOOL isRecordMic;

/**
 设置是否用44100, 双通道来录制. 默认为YES设置.
 */
@property(nonatomic) BOOL isUseStereo;
/**
 *     DrawPad执行过程中的进度对调, 返回的当前时间戳 单位是秒.
 
 注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....CODEC....
 });
 */
@property(nonatomic, copy) void(^onProgressBlock)(CGFloat);
/**
 构造函数
 @param size DrawPad容器的宽度和高度
 @param isFront 相机是否前置
 */
- (id)initWithPadSize:(CGSize)size isFront:(BOOL)isFront;


/**
 构造函数

 @param size 容器的宽度和高度
 @param isFront 相机是否前置
 @param sessionPreset 分辨率  LSTODO注意, 如果是前置的话, 如设置的分辨率过高,手机不支持, 将自动选择最大的尺寸;
 @return
 */
- (id)initWithPadSize:(CGSize)size isFront:(BOOL)isFront sessionPreset:(NSString *)sessionPreset;

/**
   此方法已废弃,请用setDrawPadView
 */
-(void)setDrawPadDisplay:(DrawPadView *)display;

/**
 设置要显示到的窗口, 务必宽高比 和设置的PadSize的相等.
 */
-(void)setDrawPadView:(DrawPadView *)display;

/**
 开始预览, 在开始录制前一定要开始预览.
 如果您要从录制界面, 进入到另一个要创建drawpad的界面时(比如编辑界面), 建议先stopPreview, 然后在push到下一个界面.
  如果你要从当前录制界面,进入到预览界面(里面没有drawpad的对象)则可以不stopPreview, 让相机一直在运行着.
 
 */
-(void)startPreview;

/**
 停止预览,如果已经开始录制了, 则会停止录制.
 
 */
-(void)stopPreview;


/**
 等同于 stopPreview; 
 只是为了思路上一致.
 */
-(void)stopDrawPad;

/**
 设置录制路径,并开始录制

 @param savePath 录制时要保存的路径
 */
-(void)startRecordWithPath:(NSString *)savePath;


/**
 设置录制路径和 速度, 并开始录制
 
范围是0.5---2.0; 0.5是慢1倍; 2.0是快一倍; 1.0为默认正常值;
 
 @param savePath 录制时要保存的路径
 @param speed 录制的速度. 范围是0.5---2.0; 0.5是慢1倍; 2.0是快一倍; 1.0为默认正常值;
 */
-(void)startRecordWithPath:(NSString *)savePath speedRate:(CGFloat)speed;

/**
 停止录制.  
 (录制的保存路径是在startRecord时设置的)
 */
-(void)stopRecord;

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
 删除一个图层.
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

@end
