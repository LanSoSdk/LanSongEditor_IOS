////
////  LSOVideoEditor.h
////
////  Created by sno on 16/12/9.
////  Copyright © 2016年 sno. All rights reserved.
////
//
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
//
///*
// 一些执行很快,不需要异步执行即可完成的功能.
// */
@interface LSOVideoEditor : NSObject


/**
 打印SDK里用到的ffmpeg版本.
 当前版本是4.1.3
 (我们大部分的功能不用ffmpeg实现.)
 */
+(void) printFFmpegVersion;
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

/**
 把音频文件(或包含音频的视频)转换为wav格式

 @param srcFile 元文件
 @param dstSample 要设置的目标音频的采样率. 如要忽略则设为0;
 @param chnl 通道号, 只能是1(单通道)或2 (双通道);默认双通道
 @return 执行完毕,返回wav文件路径,
 */
+(NSString *) executeConvertWav:(NSString *)srcFile dstSample:(int)dstSample dstChannel:(int)chnl;

/**
 * 把mp4文件转换位TS流，
 * 此命令和executeConvertTsToMp4结合,可以实现把多个mp4文件拼接成一个mp4文件。
 * 适用在当你需要把录制好的多段视频拼接成一个mp4的场合，或者你先把一个mp4文件裁剪成多段，然后把其中几段视频拼接在一起
 * 或者你想把两个视频增加一个转场的效果，

 [执行较快,不需要进度显示]

 * @param mp4Path　输入的mp4文件路径
 * @param dstTs　转换后保存的ts路径，后缀名需要是.ts
 * @return 执行成功,返回0, 失败返回错误码
 */
+(int) executeConvertMp4toTs:(NSString *)mp4Path dstTs:(NSString *)dstTs;

/**
 * 把多段TS流拼接在一起，然后保存成mp4格式
 * 注意:输入的各个流需要编码参数一致,
 * 适用于断点拍照,拍照多段视频; 或者想在两段视频中增加一个转场的视频

 [执行较快,不需要进度显示]

 * @param tsArray　多段ts流的数组
 * @param dstFile　　处理后保存的路径,文件后缀名需要是.mp4
 * @return 执行成功,返回0, 失败返回错误码
 */
+(int) executeConvertTsToMp4:(NSMutableArray *)tsArray dstFile:(NSString *)dstFile;

/**
 把多个视频拼接在一起.
 仅仅在分段录制的场合中.
 仅仅在分段录制的场合中.

 如果你要拼接不同来源的视频, 请用DrawPadConcatVideoExecute;

 [执行较快,不需要进度显示]

 @param mp4Array 多个分段录制的mp4文件,
 @param dstFile 拼接后的最终文件
 @return 拼接返回0:正确; 其他错误;
 */
+(int)executeConcatMP4:(NSMutableArray *)mp4Array dstFile:(NSString *)dstFile;



/**
 直接阻塞执行的ffmpeg的方法.
 举例如下:

 NSString *mp4Path=[LSOXFFmpegFileUtil genTmpMp4Path];

 NSMutableArray *cmdArray = [[NSMutableArray alloc] init];
 [cmdArray addObject:@"ffmpeg"];

 [cmdArray addObject:@"-i"];
 [cmdArray addObject:videoFile];

 [cmdArray addObject:@"-acodec"];
 [cmdArray addObject:@"copy"];

 [cmdArray addObject:@"-vn"];
 [cmdArray addObject:@"-y"];
 [cmdArray addObject:mp4Path];

  [LSOVideoEditor executeCmd:cmdArray];

 执行成功,返回YES, 失败返回NO;
 */
+(BOOL)executeCmd:(NSMutableArray *)cmdArray;


/**
 mov格式的多媒体视频, 转换为MP4格式
 @param videoFile 原视频
 @return 转换后的视频.
 */
+(NSString *)executeConvertMov2Mp4:(NSString*)videoFile;


/**
 *  通过音乐地址，读取音乐数据，获得图片
 *  @param url 音乐地址
 *  @return音乐图片
 */
+ (UIImage *)getAudioImageWithURL:(NSURL *)url;

/**
 从视频中获取第一帧的缩略图.  同步获取
 最大拿到的图片尺寸是1920,1920, 如果小于则原图, 如果大于则等比例缩放.
 @param url 视频的url
 @return 图片对象.
 */
+(UIImage *)getVideoImageimageWithURL:(NSURL *)url;
/**
// 替换视频中的音频, 如原视频没有音频,等于直接增加音频;
// [替换后, 视频中的音频将不存在]
// 全局函数.
// 如果你要分别设置原有音频和增加的音频的音量, 用AudioPadExecute.
//
// @param video 视频完整路径
// @param audio 音频完整路径
// @return 合并后的视频.
// */
+(NSString *)videoMergeAudio:(NSString *)video audio:(NSString *)audio;
//
//
/**
 替换视频中的音频
 [替换后, 视频中的音频将不存在]
 全局函数.
 如果你要分别设置原有音频和增加的音频的音量, 用AudioPadExecute.
 @param video 视频完整路径
 @param audio 音频完整路径
 @param videoRange 截取视频的哪部分, 如果不截取,则设置为kCMTimeRangeZero
 @param audioRange 截取音频的哪部分; 建议音频和视频的长度一致; 不截取则设置为kCMTimeRangeZero
 @return 合并后的视频;
 */
+(NSString *)videoMergeAudio:(NSString *)video audio:(NSString *)audio videoRange:(CMTimeRange)videoRange audioRange:(CMTimeRange)audioRange;

/**
 从视频的指定位置获取一帧图片,
 [源代码是]:

 NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
 forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
 AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
 AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
 generator.appliesPreferredTrackTransform = YES;
 generator.maximumSize = CGSizeMake(1920,1920);
 NSError *error = nil;

 CGImageRef img = [generator copyCGImageAtTime:time actualTime:NULL error:&error];  //<----在这里获取图片,您可以多次调用这里,从而获取多张图片.

 UIImage *image = [UIImage imageWithCGImage: img];
 generator=nil;
 return image;

 @param url 视频路径
 @param time 指定时间
 @return 获取到的视频
 */
+ (UIImage *)getVideoImageimageWithURL:(NSURL *)url time:(CMTime)time ;

/**
 已废弃,请用DrawPadAllExecute;
 */
+ (void)compressImages:(UIImage *)image frameRate:(int)frameRate duration:(int)duration completion:(void(^)(NSURL *outurl))block __attribute__((deprecated));

/**
 已废弃,请用DrawPadAllExecute;
 */
+(void)createVideoWithSize:(CGSize )size frameRate:(int)frameRate duration:(int)duration completion:(void (^)(NSURL *))block __attribute__((deprecated));

/**
 把音频文件(或包含音频的视频)转换为单通道的wav格式.
 @param srcFile 元文件
 @param startS 开始时间
 @param durationS 结束时间
 @param dstSample 要设置的目标音频的采样率. 如要忽略则设为0;
 @return 执行完毕,返回wav文件路径,
 */
+(NSString *) executeAudioCutConvertMonoWav:(NSString *)srcFile startS:(float)startS duration:(float)durationS dstSample:(int)dstSample;
/**
 *  [已废弃.请不要使用]
 直接用LSOVideoOneDo.h来做
 */
+(int) executeVideoCutOut:(NSString*)videoFile dstFile:(NSString *)dstFile start:(float)startS durationS:(float)durationS __attribute__((deprecated));
/**
 * 音频裁剪,截取音频文件中的一段.
 * 需要注意到是: 尽量保持目标文件的后缀名和源音频的后缀名一致.
 * @param srcFile   源音频,
 * @param dstFile  裁剪后的音频
 * @param startS  开始时间,单位是秒. 可以有小数
 * @param durationS  裁剪的时长.
 * @return 执行成功,返回0, 失败返回错误码
 */
+(NSString *) executeAudioCutOut:(NSString *)srcFile startS:(float)startS duration:(float)durationS;
//--------------------一下是异步执行的ffmpeg中的功能.

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
  模糊视频中的指定区域;
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



///模糊视频中的指定区域;
/// @param videoFile 视频的路径
/// @param startX 开始x坐标
/// @param startY 开始y坐标
/// @param w 要模糊的区域宽度
/// @param h 要模糊的区域高度
/// @param startS 开始时间,单位秒
/// @param endS 结束时间,单位秒;
-(BOOL) startDeleteLogoAtTimeRange:(NSString*)videoFile startX:(int)startX startY:(int)startY width:(int)w height:(int)h startTimeS:(CGFloat)startS endTimeS:(CGFloat) endS;


/**
 模糊视频中的指定区域;

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



/// 模糊视频中的指定区域;
///  (如果只用两个,把x3 x4=-1;y3 y4=-1; 如果用到3个,则把x4=-1; y4=-1);
///
/// @param videoPath 输入的视频
/// @param x1 第一个区域开始X坐标
/// @param y1 第一个区域开始X坐标
/// @param w1 第一个区域宽度
/// @param h1 第一个区域高度
/// @param startS1 开始时间,单位秒
/// @param endS1 结束时间,单位秒;
/// @param x2 (以下雷同, 如果只用两个,把x3 x4=-1;y3 y4=-1; 如果用到3个,则把x4=-1; y4=-1);
-(BOOL) startDeleteLogoAtTimeRange:(NSString *) videoPath
x1:(int)x1 y1:(int)y1 width1:(int)w1 height1:(int)h1 startTimeS:(CGFloat)startS1 endTimeS:(CGFloat)endS1
x2:(int)x2 y2:(int)y2 width2:(int)w2 height2:(int)h2 startTimeS:(CGFloat)startS2 endTimeS:(CGFloat)endS2
x3:(int)x3 y3:(int)y3 width3:(int)w3 height3:(int)h3 startTimeS:(CGFloat)startS3 endTimeS:(CGFloat)endS3
x4:(int)x4 y4:(int)y4 width4:(int)w4 height4:(int)h4 startTimeS:(CGFloat)startS4 endTimeS:(CGFloat)endS4;
//-------------------------
/**
 旋转视频角度
 此角度是为ffmpeg的画面旋转功能,
 @param videoPath 完整视频
 @param angle 角度
 */
-(BOOL) startRotateAngle:(NSString *)videoPath angle:(float)angle;
/**
 视频倒序,只倒序视频部分,音频不倒序;
 [已废弃,请使用-(BOOL)startAVReverse:(NSString *)videoPath isReverseAudio:(BOOL)isReverse]
 */
-(BOOL)startOnlyVideoReverse:(NSString *)videoPath DEPRECATED_ATTRIBUTE;

/**
 把整个文件中的音频和视频都倒序.
 [已废弃,请使用-(BOOL)startAVReverse:(NSString *)videoPath isReverseAudio:(BOOL)isReverse]
 */
-(BOOL)startAVReverse:(NSString *)videoPath DEPRECATED_ATTRIBUTE;

/**
 视频和音频倒序

 @param videoPath 视频完整路径
 @param isReverse 是否倒序音频
 */
-(BOOL)startAVReverse:(NSString *)videoPath isReverseAudio:(BOOL)isReverse;
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
 临时测试
 */
-(BOOL)startVideoMask:(NSString *)videoPath bgPath:(NSString *)bgPath mask:(NSString *)maskPath;


/**
 视频转Gif

 @param videoPath 视频完整的路径, 可以是mp4或MOV
 @param interval 转换gif的时候, 从视频中一秒钟提取多少帧;  ;建议设置为 5,10, 15;
 @param size 转换为gif的时候, 设置缩放的大小
 @param speed 转换为gif后的,gif播放速度,建议为0.3,0.5,1.0(不变),1.2,1.5;
 @return  开始另一个线程执行,返回YES; 设置的参数错误,返回NO;
 */
-(BOOL)startVideoConvertToGif:(NSString *)videoPath interval:(float)interval scaleSize:(CGSize)size speed:(CGFloat)speed;



/// 多个ts的视频拼接为一个
/// 注意: 多个ts视频的分辨率必须完全一直
/// @param tsArray 多个ts分辨率的视频数组;
-(BOOL)startConcatTSToMP4:(NSMutableArray *)tsArray;



/**
 取消当前正在执行的功能.
 */
-(void)cancelFFmpeg;

/**
 取消正在执行的ffmpeg;
 */
+(void)cancelFFmpeg;






/**
 如果您熟悉ffmpeg的命令, 则可以通过如下举例自行扩展ffmpeg的命令.
 格式举例 打印版本号.:

 NSMutableArray *cmdArray = [[NSMutableArray alloc] init];
 [cmdArray addObject:@"ffmpeg"];
 [cmdArray addObject:@"-version"];
 [self startCmd:cmdArray];

 再举例视频叠加并调速:
 NSString *filter=[NSString stringWithFormat:@"[0:v][1:v]overlay=%d:%d[overlay];[overlay]setpts=%f*PTS[v];[0:a]atempo=%f[a]",x,y, 1 / speed,speed];

 NSString *dstPath=[LSOXFFmpegFileUtil genTmpMp4Path];

 NSMutableArray *cmdArray = [[NSMutableArray alloc] init];
 [cmdArray addObject:@"ffmpeg"];

 [cmdArray addObject:@"-i"];
 [cmdArray addObject:videoPath];
 [cmdArray addObject:@"-i"];
 [cmdArray addObject:pngPath];

 [cmdArray addObject:@"-filter_complex"];
 [cmdArray addObject:filter];


 [cmdArray addObject:@"-map"];
 [cmdArray addObject:@"[v]"];

 [cmdArray addObject:@"-map"];
 [cmdArray addObject:@"[a]"];


 [cmdArray addObject:@"-acodec"];
 [cmdArray addObject:@"copy"];

 [cmdArray addObject:@"-vcodec"];
 [cmdArray addObject:@"h264_videotoolbox"];
 [cmdArray addObject:@"-b:v"];
 [cmdArray addObject:[NSString stringWithFormat:@"%d",1024*1024*2]];

 [cmdArray addObject:@"-y"];
 [cmdArray addObject:dstPath];  //<----注意, 您设置的目标文件,因为拿不到你的文件路径, 故只会有回调发生, 但回调中的dstPath是null,你需要记录dstPath;

 return [self startCmd:cmdArray];  //开启成功返回YES,  失败返回NO
 @return 开始异步处理返回YES, 失败返回NO;
 */
-(BOOL)startCmd:(NSMutableArray *)cmdArray;


/**
 进度回调,
 percent 百分比, 是一个整数.
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
 举例:
 -(void)testAdjustSpeed:(NSURL *)sampleURL
 {
 LSOVideoEditor *ffmpeg=[[LSOVideoEditor alloc] init];
 NSString *videoPath2=[LSOXFFmpegFileUtil urlToFileString:sampleURL];

 [ffmpeg setProgressBlock:^(int percent) {
 LSOLog(@"percent is :%d",percent);
 }];
 [ffmpeg setCompletionBlock:^(NSString *dstPath) {
 dispatch_async(dispatch_get_main_queue(), ^{
 [DemoUtils startVideoPlayerVC:self.navigationController dstPath:dstPath];
 });
 }];
 [ffmpeg startAdjustVideoSpeed:videoPath2 speed:0.5f];
 }
 */

@end
