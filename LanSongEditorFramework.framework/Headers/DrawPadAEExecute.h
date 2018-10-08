//
//  DrawPadAEExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/7/31.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoPen.h"
#import "ViewPen.h"
#import "Pen.h"
#import "BitmapPen.h"
#import "MVPen.h"
#import "LanSong.h"
#import "LSOAnimationView.h"


/**
 Ae图层的后台快速合成容器;
 
 用来Ae的各种素材合成为目标视频;
 */
@interface DrawPadAEExecute : NSObject


/**
 当前输入视频的媒体信息, 可以获取视频宽高, 长度等;
 如果用init创建的DrawPadAEExecute则此对象为nil;
 */
@property (nonatomic,readonly)MediaInfo *videoPenInfo;

/**
 当前进度的最终长度;, 进度/duration等于百分比;
 */
@property (readonly) CGFloat duration;

/**
 通过 initWithURL/initWithPath创建的视频对象
 */
@property (nonatomic)   LanSongMovie *videoPen;
@property (nonatomic,assign) CGSize drawpadSize;



/**
 初始化
 
 @param videoPath 输入的视频文件
 @return 返回构造对象
 */
-(id)initWithURL:(NSURL *)videoPath;

/**
 初始化

 @param videoPath
 @return
 */
-(id)initWithPath:(NSString *)videoPath;


/**
 不增加背景视频的初始化方法;
 容器大小,生成视频的帧率,时长等于第一个增加的AEJson 图层或 MV图层的分辨率;
 
 @return
 */
-(id)init;

/**
 增加UI图层;
 @param view UI图层
 @return 返回对象
 */
-(ViewPen *)addViewPen:(UIView *)view;


/**
 增加 AELSOAnimationView对象;
 */
-(void)addAEView:(LSOAnimationView *)view;

/**
 增加AE的json文件;
 返回LSOAnimationView对象; 拿着对象可以做updateImage或updateVideo;
 
 几乎等于:addAEView:(LSOAnimationView *)view
 */
-(LSOAnimationView *)addAEJsonPath:(NSString *)jsonPath;

/**
 增加的图片图层,

 在容器开始运行前增加
 */
-(BitmapPen *)addBitmapPen:(UIImage *)image;


/**
 增加mv图层;

 各种透明的动画, 在我们SDK中, 认为是MV效果, 关于MV的 原理和制作步骤,请参考我们的指导文件.
 @param colorPath mv效果中的彩色视频路径
 @param maskPath mv效果中的黑白视频路径
 @return 增加后,返回mv图层对象
 */
-(MVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;

/**
 开始执行
 */
-(BOOL)start;
/**
 取消
 */
-(void)cancel;

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
 编码完成回调, 完成后返回生成的视频路径;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *dstPath);

/**
 当前是否在运行;
 */
@property (nonatomic,readonly) BOOL isRunning;


/**
 把原视频的声音替换掉;
 @param video 原视频
 @param audio 要替换的音频
 @param dstFile 替换后的输出文件
 @return 替换成功 返回0;
 */
+(BOOL)addAudioDirectly:(NSString *)video audio:(NSString*)audio dstFile:(NSString *)dstFile;
@end
