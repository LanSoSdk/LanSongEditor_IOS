//
//  ExecuteCropWaterMark.h
//  AVSimpleEditoriOS
//
//  Created by sno on 16/12/8.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LanSongLog.h"

@interface ExecuteCropWaterMark : NSObject

- (id)init;
/**
 *  旋转视频任意高度,因为视频有可能不是正方形, 旋转过程中, 可能出现画面超出原视频的尺寸, 故需要设置视频的宽度和高度.
 *
 *  @param asset       视频源
 *  @param degrees     旋转角度
 *  @param videoWidth  视频宽度
 *  @param videoHeight 视频高度
 */
- (void)executeRotateWithPath:(NSString*)asset degrees:(CGFloat)degrees width:(CGFloat)videoWidth height:(CGFloat)videoHeight dstPath:(NSString *)dstPath;
/**
 *  把视频旋转90度
 *
 *  @param asset 输入视频源
 */
- (void)executeRotate90WithPath:(NSString*)asset dstPath:(NSString *)dstPath;

/**
 *  把视频旋转180度
 *
 *  @param asset 输入视频源
 */
- (void)executeRotate180WithPath:(NSString*)asset dstPath:(NSString *)dstPath;

/**
 *  把视频渲染270度
 *
 *  @param asset 输入视频源
 */
- (void)executeRotate270WithPath:(NSString*)asset dstPath:(NSString *)dstPath;
/**
 *  对视频进行缩放
 *
 *  @param asset  输入源
 *  @param scaleX 宽度缩放值, 范围0--1
 *  @param scaleY 高度缩放值,范围0--1
 */
- (void)executeScaleWithPath:(NSString*)asset scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY dstPath:(NSString *)dstPath;

/**
 *  给视频增加一个CALayer, 可以是文字, 也可以是图片
 *
 *  @param asset      输入源
 *  @param inputLayer CALayer的对象.
 */
- (void)executeAddLayerWithPath:(NSString*)asset watermarkLayer:(CALayer *)inputLayer dstPath:(NSString *)dstPath;

/**
 *  裁剪视频
 *
 *  @param asset  输入源
 *  @param startX     裁剪的X开始坐标
 *  @param startY     裁剪的Y开始坐标
 *  @param cropW      裁剪的视频宽度
 *  @param cropH      裁剪的视频高度.
 */
- (void)executeCropFrameWithPath:(NSString*)asset startX:(CGFloat)startX startY:(CGFloat)startY cropW:(CGFloat)cropW cropH:(CGFloat)cropH dstPath:(NSString *)dstPath;

/**
 *  裁剪视频画面,并增加CALayer
 *
 *  @param asset      输入源
 *  @param inputlayer 需要叠加的layer
 *  @param startX     裁剪的X开始坐标
 *  @param startY     裁剪的Y开始坐标
 *  @param cropW      裁剪的视频宽度
 *  @param cropH      裁剪的视频高度.
 */
- (void)executeCropCALayerWithPath:(NSString*)asset layer:(CALayer *)inputlayer startX:(CGFloat)startX startY:(CGFloat)startY cropW:(CGFloat)cropW cropH:(CGFloat)cropH dstPath:(NSString *)dstPath;
/**
 给视频增加一个背景音乐;[异步导出操作]
 如果背景音乐时长 小于视频,则循环音乐;
 如果大于,则从开始截取
 
 @param videoFile 视频文件
 @param music 背景音乐
 @param videoV 视频的音频的音量, 如果删除视频中原来的音频,则这里赋值为0;
 @param musicV  背景音乐的音量调节, 1.0为默认, 小于1.0为减小;大于则放大;
 @param dstPath 异步导出后的保存的目标路径
 */
-(void)addMusicForVideo:(NSURL *)videoFile music:(NSURL *)music videoVolume:(float)videoV musicVolue:(float)musicV dstPath:(NSString *)dstPath;

/**
 给视频 在指定位置 增加背景音乐;[异步导出操作]
 
 @param videoFile 视频路径
 @param music 背景音乐路径
 @param videoV 视频的音量
 @param musicV 背景音乐音量
 @param insetPos 背景音乐插入到视频的那个位置(单位秒);
 @param dstPath 导出文件, 后缀是mp4
 */
-(void)addMusicForVideo:(NSURL *)videoFile music:(NSURL *)music videoVolume:(float)videoV musicVolue:(float)musicV insertPos:(CGFloat )insetPos dstPath:(NSString *)dstPath;

@end
