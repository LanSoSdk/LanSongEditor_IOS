//
//  DrawPadVideoExecute.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/6/7.
//  Copyright © 2018年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "VideoPen.h"
#import "ViewPen.h"
#import "Pen.h"
#import "LanSongView2.h"
#import "BitmapPen.h"
#import "MVPen.h"
#import "LanSong.h"
#import "VideoPen2.h"


@interface DrawPadVideoExecute : NSObject


/**
 当前输入视频的媒体信息, 可以获取视频宽高, 长度等;
 */
@property (nonatomic,readonly)MediaInfo *mediaInfo;
@property (nonatomic)   VideoPen2 *videoPen;
@property (nonatomic,assign) CGSize drawpadSize;



/**
 初始化

 @param videoPath 输入的视频文件
 @return 返回构造对象
 */
-(id)initWithURL:(NSURL *)videoPath;
-(id)initWithPath:(NSString *)videoPath;

-(id)initWithURL:(NSURL *)videoPath drawPadSize:(CGSize)size;
-(id)initWithPath:(NSString *)videoPath drawPadSize:(CGSize)size;

/**
 增加UI图层;
 @param view UI图层
 @return 返回对象
 */
-(ViewPen *)addViewPen:(UIView *)view;

-(BitmapPen *)addBitmapPen:(UIImage *)image;

-(MVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;

-(void)removePen:(Pen *)pen;
/**
 设置录制视频的宽高;
 设置后, 容器宽高不变, 会在编码的时候, 把容器的所有图层缩放到这个宽高上;
 如果录制视频的宽高比 不等于容器的宽高比,则录制后的图层会变形;
 
 在startRecord前调用;
 @param size 录制视频的宽高
 */
-(void)setRecordSize:(CGSize)size;

/**
 设置录制的码率
 在startRecord前调用;
 */
-(void)setRecordBitrate:(int)bitrate;

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
直接增加上原来的声音;
里面没有做mp3或aac检查,没有做时长检查,直接合并在一起;

@param video 生成的视频
@param audio 带声音的原视频路径/或其他音频
@param dstFile 生成的文件
@return 成功返回true, 失败返回false;
*/
+(BOOL)addAudioDirectly:(NSString *)video audio:(NSString*)audio dstFile:(NSString *)dstFile;


/**
 以下是举例;
 //DrawPadVideoExecute *testExecute;
 //-(void) testVideoExecute:(LanSongFilter *)filter
 //{
 //    NSString *defaultVideo=@"dy_xialu1";
 //    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:defaultVideo withExtension:@"mp4"];
 //        testExecute=[[DrawPadVideoExecute alloc] initWithURL:sampleURL];
 //        //增加滤镜
 //        [testExecute.videoPen switchFilter:filter];
 //
 //
 //    SubPen *pen1=[testExecute.videoPen addSubPen];
 //    pen1.scaleHeight=0.5;
 //    pen1.scaleWidth=0.5;
 //    pen1.positionX=pen1.scaleWidthValue/2;
 //    pen1.positionY=pen1.scaleHeightValue/2;
 //
 //    SubPen *pen2=[testExecute.videoPen addSubPen];
 //    pen2.scaleHeight=0.5;
 //    pen2.scaleWidth=0.5;
 //    pen2.positionX=pen1.scaleWidthValue +pen2.scaleWidthValue/2;
 //    pen2.positionY=pen2.scaleHeightValue/2;
 //
 //    SubPen *pen3=[testExecute.videoPen addSubPen];
 //    pen3.scaleHeight=0.5;
 //    pen3.scaleWidth=0.5;
 //    pen3.positionX=pen3.scaleWidthValue/2;
 //    pen3.positionY=pen1.scaleHeightValue + pen3.scaleHeightValue/2;
 //
 //
 //    SubPen *pen4=[testExecute.videoPen addSubPen];
 //    pen4.scaleHeight=0.5;
 //    pen4.scaleWidth=0.5;
 //    pen4.positionX=pen3.scaleWidthValue +pen4.scaleWidthValue/2;
 //    pen4.positionY=pen2.scaleHeightValue +pen4.scaleHeightValue/2;
 //
 //
 //        //        //增加Bitmap
 ////                UIImage *image=[UIImage imageNamed:@"mm"];
 ////                [testExecute addBitmapPen:image];
 ////
 ////
 ////        //        //增加MV图层
 ////                NSURL *colorPath = [[NSBundle mainBundle] URLForResource:@"mei" withExtension:@"mp4"];
 ////                NSURL *maskPath = [[NSBundle mainBundle] URLForResource:@"mei_b" withExtension:@"mp4"];
 ////                [testExecute addMVPen:colorPath withMask:maskPath];
 //
 //        __weak typeof(self) weakSelf = self;
 //        [testExecute setProgressBlock:^(CGFloat progess) {
 //                LSLog(@"即将处理时间(进度)是:%f,百分比是:%f",progess,progess/testExecute.mediaInfo.vDuration);
 //        }];
 //
 //        [testExecute setCompletionBlock:^(NSString *dstPath) {
 //            LSLog(@"处理完毕");
 //            dispatch_async(dispatch_get_main_queue(), ^{
 //               [LanSongUtils startVideoPlayerVC:weakSelf.navigationController dstPath:dstPath];
 //            });
 //        }];
 //        [testExecute start];
 //}
 */
@end
