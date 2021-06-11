//
//  DrawPadAeText.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/11/20.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOOneLineText.h"
#import "LSOVideoPen.h"
#import "LSOViewPen.h"
#import "LSOPen.h"
#import "LSOBitmapPen.h"
#import "LSOMVPen.h"
#import "LanSong.h"
#import "LSOAeView.h"
#import "LanSongView2.h"

NS_ASSUME_NONNULL_BEGIN
/**
 从DrawPadAEExecute整理而来, 只用于文字动画视频
 */
@interface DrawPadAeText : NSObject


//在运行的时候,打印运行信息
+(void)showDebugInfo:(BOOL)show;

/**
 init方法,

 Ae动画做好后,根据我们的导出文件, 得到json. 在这里输入SDK
 @param jsonPath json的完整路径
 @return
 */
-(id)initWithJsonPath:(NSString *)jsonPath;


 /**
  当前json的最大行.
  */
 @property (nonatomic,readonly)int jsonMaxLine;

/**
 这个是一个容器, drawpadSize是容器的宽高; 等于你设置的json高度.
 */
@property (nonatomic,readonly) CGSize drawpadSize;

/**
 设置编码时的宽高.
  参看我们的F2文档;可选;
 在导出前设置.
 */
@property (nonatomic,assign) int encoderBitRate;

/**
 json文件在init或switch后, 会更新json文件,从而更新这个AeView;
 根据AeView,得到当前json中的所有图片图层:imageLayerArray
 
 LSoAeView继承自UIView, 你可以增加在这个UIview上增加你自己的UI画面,增加后, 会自动随模板更新;
 用 [aeView addSubView:xxx]; 既可
 */
@property (nonatomic,readonly) LSOAeView *aeView;
/**
 在pushText后, 得到分离好的每行信息.item对象是LSOOneLineText;
 在init时,已经初始化.
 
 当前您可以不pushText,直接外部分离一句话,创建LSOOneLineText, 增加到此数组里.
 */
@property (readwrite, nonatomic, strong)  NSMutableArray *oneLineTextArray;
/**
 增加预览窗口
 */
-(void)addLanSongView2:(LanSongView2 *)view;

/**
 增加音频
 用在背景音乐比声音短的场合.
 在增加说话语音后增加
 
 @param audio 音频路径.或带有音频的视频路径
 @param volume 混合时的音量
 @param isLoop 是否循环
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addBackgroundAudio:(NSURL *)audio volume:(CGFloat)volume loop:(BOOL)isLoop;
/**
 增加音频
 在增加说话语音后增加
 
 用在背景音乐比声音长的场合
 
 @param audio 音频路径.或带有音频的视频路径
 @param start 音频的开始时间段
 @param end 音频的结束时间段 如果增加到结尾, 则可以输入-1
 @param volume 增加后的音量
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addBackgroundAudio:(NSURL *)audio start:(CGFloat)start end:(CGFloat)end volume:(CGFloat)volume;


/**
 清除所有的背景音乐;
 在start前或预览结束后调用;
 */
-(void)removeAllBackGroundAudio;


/**
 开始执行
 */
-(BOOL)startPreview;


/**
 获取预览的视频图层;
 在startPreview后调用;
 获取视频图层对象后, 可以设置相关的视频效果,比如滤镜.视频预览快慢等;
 */
-(LSOVideoPen *)getPreviewVideoPen;

/**
 开始导出.
 */
-(BOOL)startExport;
/**
 取消
 */
-(void)cancel;
/**
 外部修改后,通过这个方法来更新json中的图片信息;
  在更新的时候, 外面的文字是否已经保存到LSOOneLineText.textImage
 @param converted 已经保存,这里是YES;没有保存这里是NO, 没有保存,我们会内部会全部转换一遍;并更新文字动画.
 */
-(void)updateTextArrayWithConvert:(BOOL)converted;

/**
 放进去一段文字;
 
 内部会根据json中每一行的大小来分段.
 
 @param text 文字
 @param start 文字的开始时间
 @param endTime 文字的结束时间;
 */
-(void)pushText:(NSString *)text  startTime:(float)startTime endTime:(float)endTime;

/**
 进度回调,
 isExport: 当前是否是导出模式;
 progress:当前执行到的时间;
 float percent:百分比
 
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^frameProgressBlock)(BOOL isExport,CGFloat progress,float percent);
/**
 编码完成回调, 完成后返回生成的视频路径;
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^completionBlock)(BOOL isExport,NSString *dstPath);

/**
 当前是否正在预览
 */
@property (nonatomic,readonly) BOOL isRunning;

/**
 是否正在导出.
 */
@property (nonatomic,readonly) BOOL isExporting;


/**
 增加背景图片
 如果你的背景是颜色, 则图片大小建议直接等于drawpadSize
 背景默认缩放到容器大小.
 @param image 图片对象
 @return 返回图层对象, 您可以根据这个来做缩放;
 */
-(LSOBitmapPen *)addBackgroundImage:(UIImage *)image;
/**
 增加logo;
 可以增加多个,默认放到容器的左上角;
 @param image logo图片
 @return 返回图层对象;
 */
-(LSOBitmapPen *)addLogoBitmap:(UIImage *)image;
/**
 增加一个图片
 可以增加多个.
 
 @param image 图片对象
 @param position 位置
 @return 返回图层对象;
 */
- (LSOBitmapPen *)addLogoBitmap:(UIImage *)image position:(LSOPosition)position;


/**
 增加一个UI图层, 

 @param view view 大小要等于DrawPadSize;
 @return UI对象;
 */
-(LSOViewPen *)addViewPen:(UIView *)view;


/**
 清除指定的图层;
 */
-(void)removePen:(LSOPen *)pen;

/**
 交换两个图层的位置
 在开始前调用;
 @param first 第一个图层对象
 @param second 第二个图层对象
 */
-(BOOL)exchangePenPosition:(LSOPen *)first second:(LSOPen *)second;

/**
 设置图层的位置
 [在开始前调用]
 
 @param pen 图层对象
 @param index 位置, 最里层是0, 最外层是 getPenSize-1
 */
-(BOOL)setPenPosition:(LSOPen *)pen index:(int)index;

/**
 设置语音识别的视频路径;
[可选]
 setBgVideoPath/setAudioPath 这者只能取其一.
 @param path 视频路径
 @param volume 视频中的声音音量, 1.0f为正常(建议), 0.5为降低一倍; 2.0是放大一倍;
 */
-(void)setBgVideoPath:(NSURL *)path volume:(CGFloat)volume;
/**
 增加语音识别的音频路径
 [可选]
 setBgVideoPath/setAudioPath 这者只能取其一.

 @param path 完整路径
 @param volume 音量 1.0f为正常(建议), 0.5为降低一倍; 2.0是放大一倍;
 */
-(void)setAudioPath:(NSURL *)path volume:(CGFloat)volume;


@end
NS_ASSUME_NONNULL_END

/*
 调用流程:
 1, initWithJsonPath:(json文件的完整路径)
 
 2, (一下两步可选任一个既可.)
   可选1: 多次pushText. 把所有的识别出来的一段连续的文字和时间段都放进来. 我们内部分割文字,转换为图片,放到oneLineTextArray中.
   可选2: 直接你们自己按照我们pushText的形式来分离文字, 然后放到oneLineTextArray数组里.
 注意:我们内部的分离文字, 流程是:先判断当前图片高度,找到最接近这个高度的字号,然后计算出字号的宽度,根据图片的宽度来判断能最大放多少个字,从而填满当前图片的宽高.
     您也可以不用填满,可以一行只放一个或几个文字.
 
 3, 设置监听,完成回调等.startPreview开始预览/startExport开始导出.
 ----基本操作完毕----
 
 4, 如果你要再次修改oneLineTextArray中的任意一行的文字/颜色/字体/文字背景等, 则循环找到这一行的OneLineText对象.直接修改.
    修改完毕后, 调用updateTextArrayWithConvert,更新json中的图片,再次预览/导出既可.
 
 5, 如果你要更新背景图片,增加logo, 增加声音,则有对应的addXXX方法, 直接增加. 增加图片后, 会得到图片图层对象,可以对这个对象设置滤镜,调整亮暗,切换图片等.
 6, 导出,则直接调用startExport.
 
 */

