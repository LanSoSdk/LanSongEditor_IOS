////
////  LSOVideoCompositionExecute.h
////
////  LanSongEditorFramework
////
////  Created by sno on 2020/3/14.
////  Copyright © 2020 sno. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
//#import "LanSongContext.h"
//
//@class LSOLayer;
//
////叠加层;
//@class LSOAudioLayer;
//
//
//
//
//NS_ASSUME_NONNULL_BEGIN
///**
// 视频合成. 异步线程执行;
// 是一个容器, 可以把视频, 图片, 文字,动画, 声音等合成为视频.
// */
//@interface LSOVideoCompositionExecute : LSOObject
//
//
///// 初始化
///// @param size 合成宽高, 其中的宽度和高度一定是2的倍数
//-(id)initWithCompositionSize:(CGSize)size durationS:(CGFloat)durationS;
//
//
///*
//
// 读当前合成(容器)的总时长.单位秒;
// (当你设置每个图层的时长后, 此属性会改变.);
// */
//@property(readonly,atomic) CGFloat compDurationS;
//
///**
// 您在init的时候, 设置的合成宽高.
// 暂时不支持在合成执行过程中, 调整合成的宽高.
// */
//@property (nonatomic,readonly) CGSize compositionSize;
//
///**
// 获取,当前播放的时间点;
// */
//@property(nonatomic, readonly) CGFloat currentTimeS;
//
///**
// 当前内部有多少个叠加层;
// 如果你获取使用此变量, 则会拷贝一份新的NSMutableArray, 请不要多次获取;
// */
//@property (strong,atomic, readonly) NSMutableArray *overlayLayerArray;
//
///**
// 当前有多少个音频层;
// 如果你获取使用此变量, 则会拷贝一份新的NSMutableArray, 请不要多次获取;
// */
//@property (strong,atomic, readonly) NSMutableArray *audioLayerArray;
//
//
///// 设置容器的帧率.[可选, 默认是25]
///// 范围是>=25; 并小于33;如果您都是json增加, 则建议设置为json的帧率;
///// @param frameRate
//-(void)setFrameRate:(CGFloat)frameRate;
//
////----------------------叠加层操作 start----------------------------------------
///**
// 增加一个视频叠加层.
// 叠加层是在拼接层的上面;
// atStartTime 在合成的指定时间开始增加;
// */
//- (LSOLayer *)addVideoLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;
///**
// 叠加一张图片图层;
// */
//- (LSOLayer *)addImageLayerWithImage:(UIImage *)image atTime:(CGFloat)startTimeS;
//
///**
// 增加一个gif图层;
// */
//- (LSOLayer *)addGifLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;
///**
// 增加mv图层;
// */
//- (LSOLayer *)addMVLayerWithColorURL:(NSURL *)colorUrl maskUrl:(NSURL *) maskUrl atTime:(CGFloat)startTimeS;
//
//
///**
// 增加UIView图层, UIView的宽高一定要等于容器的宽高;
// */
//-(LSOLayer *)addViewLayerWithUIView:(UIView *)view atTime:(CGFloat)startTimeS;
///**
// 增加连续图片数组图层
// 仅使用用有给每张图片带一个时间戳的场合,比如语音识别后的图片;
// /// @param imageDictionary 字典数组
// /// @param durationS 整个连续图片的总显示时长
// /// @param startTimeS 从容器的什么位置开始显示;
//
//
// 举例:
// NSMutableDictionary *dictory=[[NSMutableDictionary alloc] init];
// dictory = [[NSMutableDictionary alloc] init];
//    [dictory setObject:uiimage1 forKey:[NSNumber numberWithFloat:0.5f]];
//    [dictory setObject:uiimage2" forKey:[NSNumber numberWithFloat:2.5f]];
// 这样就是在0.5秒至2.5秒前一直显示 uiimage1; 2.5秒后一直显示uiimage2,只到总时间显示完毕;
// */
//- (LSOLayer *)addImageArrayLayerWithDictionary:(NSDictionary<NSNumber *, UIImage *> *)imageDictionary durationS:(CGFloat)durationS atTime:(CGFloat)startTimeS;
//
////----------------------叠加层操作 end----------------------------------------
///**
// 增加一个声音图层;
// */
//- (LSOAudioLayer *)addAudioLayerWithURL:(NSURL *)url atTime:(CGFloat)startTimeS;
///**
// 删除声音图层
// */
//- (void)removeAudioLayer:(LSOAudioLayer *)audioLayer;
///**
// 删除一个图层.
// */
//- (BOOL)removeLayer:(nullable LSOLayer *)layer;
//
//
////----------------------控制类方法-------------------------------
///**
// 当前是否在运行;
// */
//@property (readonly) BOOL isRunning;
//
///**
//是否暂停;
// */
//@property (readonly) BOOL isPausing;
///**
// 开始导出.
// */
//-(void)startExport;
///**
// 当前是否正在导出.
// */
//@property (readonly) BOOL  isExporting;
///**
// 取消
// */
//-(void)cancel;
//
///**
// 导出进度回调;
// 当在编码的时候, 等于当前视频图层的视频播放进度 时间单位是秒;;
// 工作在其他线程,
// 如要工作在主线程,请使用:
// progress: 当前正在播放总合成的时间点,单位秒;
// percent: 当前总合成的时间点对应转换为的百分比;
//
// 进度则是: progress/_duration;
// dispatch_async(dispatch_get_main_queue(), ^{
// });
// */
//@property(nonatomic, copy) void(^exportProgressBlock)(CGFloat progress,CGFloat percent);
//
///**
//编码完成回调, 完成后返回生成的视频路径;
//注意:生成的dstPath目标文件, 我们不会删除.
//工作在其他线程,
//如要工作在主线程,请使用:
//dispatch_async(dispatch_get_main_queue(), ^{
//});
//*/
//@property(nonatomic, copy) void(^exportCompletionBlock)(NSString *dstPath);
//
//
//
//@end
//
//NS_ASSUME_NONNULL_END
//
