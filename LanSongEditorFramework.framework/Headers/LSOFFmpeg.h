//
//  LSOFFmpeg.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/1/18.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LSOLayoutParam.h"



/**
 ffmpeg的一些命令.
 执行格式是:.
  1 .init
 2. progress/completeBlock;
 3, start;
 注意: 每次start只有等这个功能执行完毕后,从可以开始下一个; 不可以同时执行多个.
举例在本文件的最下面.
 */
@interface LSOFFmpeg : NSObject

/**
 视频时长裁剪,画面剪切, 缩放, 调整帧率
 
 @param videoPath 视频路径
 @param startS  时长开始时间,单位秒, 如果不裁剪,则赋值0;
 @param durationS 要裁剪的总长度,单位秒  不裁剪 赋值0;
 @param rect  画面剪切  不剪切的话, 等于视频原有尺寸.
 @param scaleSize 画面剪切后要缩放到的大小 不缩放的话, 等于原有大小.
 @param frameRate 调整到的帧率
 @return 开始执行返回YES;
 */
-(BOOL)startCutCropAdjustFps:(NSString *)videoPath start:(float)startS duration:(float)durationS
                    cropRect:(CGRect)rect scaleSize:(CGSize)scaleSize frameRate:(float)frameRate;

/**
 把两个视频画面拼接在一起,
 @param outW 合成后的视频宽度
 @param outH 合成后的视频高度
 @param p1 视频1的参数
 @param p2 视频2的参数
 */
-(BOOL)startLayout2Video:(int)outW height:(int)outH params1:(LSOLayoutParam *)p1 params2:(LSOLayoutParam *)p2;

/**
视频调速;
 
 如果速度设置0.5, 则慢一倍. 假如原来时长是5秒, 慢一倍后,目标视频的时长是10秒;
  如果快一倍,则时长减少为原来的一半.
 @param srcPath 输入原视频
 @param speed 范围0.5--2.0； 0.5:放慢一倍;2:加快一倍
 @return 执行成功,返回YES;
 */
-(BOOL)startAdjustVideoSpeed:(NSString *)srcPath speed:(CGFloat)speed;

/**
 调节视频速度,并叠加上图片
 
 @param videoPath 视频完整路径
 @param pngPath 图片的完整路径
 @param x 图片叠加的开始x坐标
 @param y 图片叠加开始的y坐标
 @param speed 调节的速度
 */
-(BOOL)startAdjustSpeedAndOverLay:(NSString *)videoPath pngPath:(NSString *)pngPath x:(int)x y:(int)y speed:(float)speed;
/**
 ffmpeg的命令.
 特定客户使用;
 异步执行,同一时刻只能有一个在执行;
 
 @param videoFile 输入的视频
 @param startX 开始x
 @param startY 开始坐标y
 @param w 要删除的区域宽度
 @param h 删除的区域高度
 @return 开始异步处理返回YES, 失败返回NO;
 */
-(BOOL) startDeleteLogo:(NSString*)videoFile startX:(int)startX startY:(int)startY width:(int)w height:(int)h;
/**
 ffmpeg的命令.
 特定客户使用;
 
  异步执行,同一时刻只能有一个在执行;
 
 (如果只用两个,把x3 x4=-1;y3 y4=-1; 如果用到3个,则把x4=-1; y4=-1);
 
 @param videoPath 输入的视频
 @param x1 第一个区域开始X坐标
 @param y1 第一个区域开始Y坐标
 @param w1 第一个区域宽度
 @param h1 第一个区域高度
 @param x2 (以下雷同, 如果只用两个,把x3 x4=-1;y3 y4=-1; 如果用到3个,则把x4=-1; y4=-1);
 @return 开始异步处理返回YES, 失败返回NO;
 */
-(BOOL) startDeleteLogo:(NSString *) videoPath
                     x1:(int)x1 y1:(int)y1 width1:(int)w1 height1:(int)h1
                     x2:(int)x2 y2:(int)y2 width2:(int)w2 height2:(int)h2
                     x3:(int)x3 y3:(int)y3 width3:(int)w3 height3:(int)h3
                     x4:(int)x4 y4:(int)y4 width4:(int)w4 height4:(int)h4;

//-------------------------
/**
 旋转视频角度
 @param videoPath 完整视频
 @param angle 角度
 */
-(BOOL) startRotateAngle:(NSString *)videoPath angle:(float)angle;
/**
 视频倒序,只倒序视频部分,音频不倒序;
 */
-(BOOL)startOnlyVideoReverse:(NSString *)videoPath;

/**
 把整个文件中的音频和视频都倒序.
 */
-(BOOL)startAVReverse:(NSString *)videoPath;
/**
 调节视频帧率

 @param videoPath 输入视频的完整路径
 @param frameRate 设置视频的帧率, 比如25/30/15等;
 */
-(BOOL)startAdjustFrameRate:(NSString *)videoPath frameRate:(float)frameRate;
/**
 * 在视频的指定位置,指定时间内叠加一张图片
 * 比如给视频的第一帧增加一张图片,时间范围是:0.0 --0.03;
 * 注意:如果你用这个给视频增加一张封面的话, 增加好后, 分享到QQ或微信或放到mac系统上, 显示的缩略图不一定是第一帧的画面.
 
 * @param srcPath 源视频的完整路径
 * @param picPath 图片的完整路径,png/ jpg
 * @param x  图片的左上角要叠加到源视频的X坐标哪里, 左上角为0,0
 * @param y
 * @param startTimeS 时间范围,开始时间,单位秒
 * @param endTimeS 时间范围, 结束时间, 单位秒.
 * @return
 */
-(BOOL)startAddPitureAtXYTime:(NSString *)videoPath picPath:(NSString *)picPath x:(int)x y:(int)y startTimeS:(float)startTimeS endTimeS:(float)endTimeS;


/**
 获取视频文件中的音频部分.
 [执行很快.直接返回]
 */
+(NSString *)executeGetAudioTrack:(NSString*)videoFile;

/**
 获取视频文件中的视频轨道
 [执行很快.直接返回]
 */
+(NSString *)executeGetVideoTrack:(NSString*)videoFile;
/**
 * 给Mp4文件中增加一些描述文字.
 [执行很快.直接返回]
 *
 * 比如您可以把一些对该视频的操作信息, 配置信息,服务器的说明信息等放到视频里面,和视频一起传输,
 * 注意:这个文字信息是携带到mp4文件中, 不会增加到每帧上.
 *
 *  这里是写入. 我们有另外的读取
 * LSNEW :
 * @param srcPath 原视频的完整路径
 * @param text 要携带的描述文字
 * @return 增加后的目标文件.
 */
+(NSString *)executeAddTextToMp4:(NSString *)videoPath text:(NSString *)text;
/**
 * 从视频中获取该视频的描述信息
 [执行很快.直接返回]
 * @param srcPath
 * @return
 */
+(NSString *)executeGetTextFromMp4:(NSString *)srcPath;

//测试使用;
-(void)startVersion;

/**
 打印所有解码器
 */
+(void) printAllDecoders;

/**
 打印所有编码器
 */
+(void) printAllEncoders;

/**
 打印所有滤镜
 */
+(void) printAllFilters;

/**
 执行ffmpeg的命令.
 格式举例:
 NSMutableArray *cmdArray = [[NSMutableArray alloc] init];
 [cmdArray addObject:@"ffmpeg"];
 [cmdArray addObject:@"-version"];
 [self startCmd:cmdArray];
 @return 开始异步处理返回YES, 失败返回NO;
 */
-(BOOL)startCmd:(NSMutableArray *)cmdArray;


/**
 进度回调,
 
 percent 百分比, 是一个整数. 
 此进度回调, 在 编码完一帧后,没有任意queue判断,直接调用这个block;
 比如在:assetWriterPixelBufferInput appendPixelBuffer执行后,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^progressBlock)(int percent);
/**
 编码完成回调, 完成后返回生成的视频路径;
 工作在其他线程, 执行成功返回视频路径, 失败返回nil;
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *dstPath);

/*
 调用举例:
 -(void)testDelogo:(NSURL *)sampleURL
 {
 LSOFFmpeg *ffmpeg=[[LSOFFmpeg alloc] init];
 NSString *videoPath2=[LanSongFileUtil urlToFileString:sampleURL];
 
 [ffmpeg setProgressBlock:^(int percent) {
 LSLog(@"percent is :%d",percent);
 }];
 [ffmpeg setCompletionBlock:^(NSString *dstPath) {
 [MediaInfo checkFile:dstPath];
 }];
 [ffmpeg startDeleteLogo:videoPath2 startX:0 startY:0 width:540 height:800];
 }
 */
@end
