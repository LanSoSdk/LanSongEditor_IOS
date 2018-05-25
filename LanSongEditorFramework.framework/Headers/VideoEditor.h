//
//  MediaEditor.h
//  LanSongEditorFramework
//
//  Created by sno on 16/12/9.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoEditor : NSObject


/**
 *  删除多媒体文件中的音频,如果多媒体有视频部分,等于提取视频的功能，这样提出的视频播放，就没有声音了
 *  适用在当想给一个多媒体文件更换声音的场合的。您可以用这个方法删除声音后，通过 executeVideoMergeAudio 重新为视频增加一个声音。
 *
 [执行较快,不需要进度显示]
 
 *  @param srcPath  输入的MP4文件
 *  @param dstPath 删除音频后的多媒体文件的输出绝对路径,路径的文件名类型是.mp4
 *
 *  @return 执行成功,返回0, 失败返回错误码
 */

+(int) executeDeleteAudio:(NSString *)srcPath dstPath:(NSString *)dstPath;

/**
 *  删除多媒体文件中的视频部分，一个多媒体文件如果是音频和视频一起的，等于提取多媒体文件中的音频，
 *
 [执行较快,不需要进度显示]
 
 *  @param srcPath 要处理的多媒体文件,里面需要有视频
 *  @param dstPath 删除视频部分后的音频保存绝对路径, 注意:如果多媒体中是音频是aac压缩,则后缀必须是aac. 如果是mp3压缩,则后缀必须是mp3,
 *
 *  @return 执行成功,返回0, 失败返回错误码
 */
+(int) executeDeleteVideo:(NSString *)srcPath dstPath:(NSString *)dstPath;

/**
 给视频增加上音频,
 仅适用于当用DrawPad对一个视频处理,生成新的视频后,增加原视频中的音频部分的场合.
 
 [执行较快,不需要进度显示]
 
 @param oldMp4 原视频,
 @param newMp4 用DrawPad处理后的新视频
 @param dstFile 增加音频后的视频文件
 @return 支持成功返回YES, 如果原视频中没有音频或没有视频,则执行失败返回NO
 */
+(BOOL)drawPadAddAudio:(NSString *)oldMp4 newMp4:(NSString*)newMp4 dstFile:(NSString *)dstFile;


+(BOOL)mergeAVDirectly:(NSString *)video audio:(NSString*)audio dstFile:(NSString *)dstFile;
/**
  建议使用videoMergeAudio
 * 音频和视频合成为多媒体文件，等于给视频增加一个音频。
 
 [执行较快,不需要进度显示]
 
 * @param videoFile 输入的视频文件,需视频文件中不存储音频部分, 如有音频则会增加两个声音.
 * @param audioFile 输入的音频文件
 * @param dstFile  合成后的输出，文件名的后缀是.mp4
 * @return 返回执行的结果.
 *
 */
+(int) executeVideoMergeAudio:(NSString *)videoFile audioFile:(NSString *)audioFile dstFile:(NSString *)dstFile;

/**
 * 给视频MP4增加上音频，audiostartS表示从从音频的哪个时间点开始增加，单位是秒
 *
 * 注意: 如果音频的时长大于视频,则以音频的时长为目标文件多媒体的时长.
 *
 [执行较快,不需要进度显示]
 
 * @param videoFile  输入的视频文件,需视频文件中不存储音频部分
 * @param audioFile  需要增加的音频文件
 * @param dstFile  处理后保存的路径 文件名的后缀需要.mp4格式
 * @param audiostartS  音频增加的时间点，单位秒，类型float，可以有小数，比如从音频的2.35秒开始增加到视频中。
 * @return 执行成功,返回0, 失败返回FFMPEG的错误码
 */
+(int) executeVideoMergeAudio:(NSString*)videoFile audioFile:(NSString *)audioFile dstFile:(NSString *)dstFile audioStartS:(float)audiostartS;

/**
 视频和音频合成, 或理解为: 给视频增加一个背景音乐
 此函数, 在合成后, 会对视频和音频进行转码操作, 可能会改变视频的分辨率,
 等同于导出预设值为: AVAssetExportPresetMediumQuality
 
 [执行较快,不需要进度显示]
 
 
 @param videoPath 输入视频的路径
 @param audioPath 输入音频的路径, 音频可以是mp3格式 或AAC格式.
 @param dstPath 合成后的输出路径, 合成后, 视频为mp4格式, 建议后缀是mp4
 */
+(void)videoMergeAudio:(NSString *)videoPath audio:(NSString *)audioPath dstPath:(NSString *)dstPath;

/**
 * 给视频文件增加一个音频
 *
 [执行较快,不需要进度显示]
 
 * @param videoFile  输入的视频文件,需视频文件中不存储音频部分
 * @param audioFile  需要增加的音频文件
 * @param dstFile    处理后保存的路径 文件名的后缀需要.mp4格式
 * @param audiostartS  音频开始时间, 单位秒,可以有小数, 比如2.5秒
 * @param audiodurationS 音频增加的总时长.您可以只增加音频中一部分，比如增加音频的2.5秒到--180秒这段声音到视频文件中，
    则这里的参数是180
 * @return 执行成功,返回0, 失败返回错误码
 */
+(int) executeVideoMergeAudio:(NSString*)videoFile audioFile:(NSString *)audioFile dstFile:(NSString *)dstFile audioStartS:(float)audiostartS audioDurationS:(float)audioDurationS;


/**
 给视频增加一个背景音乐;[异步导出操作]
 
 进度以 "LanSongVideoEditorProgress"通知 发出,可见本文件最后通知的使用.
 
 在正在过程中, 会判断videoV是否为0, 如果为零,会删除原来的音频, 如果不为零,则把要增加的音乐和背景音乐混合, 然后导出.
 如果背景音乐时长 小于视频支持,则循环音乐;
 如果大于,则从开始截取; 截取长度等于视频长度;
 
 @param videoFile 视频文件
 @param music 背景音乐
 @param videoV 视频的音频的音量, 如果删除视频中原来的音频,则这里赋值为0;
 @param musicV  背景音乐的音量调节, 1.0为默认, 小于1.0为减小;大于则放大;
 @param dstPath 异步导出后的保存的目标路径
 */
+(void)addMusicForVideo:(NSURL *)videoFile music:(NSURL *)music videoVolume:(float)videoV musicVolue:(float)musicV dstPath:(NSString *)dstPath;

/**
 * 音频裁剪,截取音频文件中的一段.
 * 需要注意到是: 尽量保持目标文件的后缀名和源音频的后缀名一致.
 
 [执行较快,不需要进度显示]
 
 * @param srcFile   源音频,
 * @param dstFile  裁剪后的音频
 * @param startS  开始时间,单位是秒. 可以有小数
 * @param durationS  裁剪的时长.
 * @return 执行成功,返回0, 失败返回错误码
 */
+(int) executeAudioCutOut:(NSString *)srcFile dstFile:(NSString *)dstFile startS:(float)startS duration:(float)durationS;

/**
 *
 * 剪切mp4文件.(包括视频文件中的音频部分和视频部分),即把mp4文件中的一段剪切成独立的一个视频文件, 
    比如把一个30分钟的视频,裁剪其中的10秒钟等.
 
 [执行较快,不需要进度显示]
 
 * @param videoFile  原视频文件 文件格式是mp4
 * @param dstFile   裁剪后的视频路径， 路径的后缀名是.mp4
 * @param startS   开始裁剪位置，单位是秒，
 * @param durationS  需要裁剪的时长，单位秒，比如您可以从原视频的8.9秒出开始裁剪，裁剪２分钟，则这里的参数是　１２０
 * @return  执行成功,返回0, 失败返回错误码
 */
+(int) executeVideoCutOut:(NSString*)videoFile dstFile:(NSString *)dstFile start:(float)startS durationS:(float)durationS;

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
 适用在分段录制的场合中.
 
 请注意,这里的拼接是完全没有做解码. 请确保拼接的多段视频各种参数一致.

 [执行较快,不需要进度显示]
 
 @param mp4Array 多个分段录制的mp4文件,
 @param dstFile 拼接后的最终文件
 @return 拼接后的结果.
 */
+(int)executeConcatMP4:(NSMutableArray *)mp4Array dstFile:(NSString *)dstFile;
/**
 *  提取源音频部分, 增加到目标视频中.
 *  [执行较快,不需要进度显示]
 *  @param oldVideoPath  原视频
 *  @param onlyVideoPath 需要增加音频的视频
 *  @param dstPath       处理后的目标文件.
 */
+(void)extractAudioToDestination:(NSString *)oldVideoPath onlyVideoPath:(NSString *)onlyVideoPath dstPath:(NSString *)dstPath;

/**
 *  旋转视频任意高度,因为视频有可能不是正方形, 旋转过程中, 可能出现画面超出原视频的尺寸, 故需要设置视频的宽度和高度.
 *  
 进度以 "LanSongVideoEditorProgress"通知 发出,可见本文件最后通知的使用. 
 
 *  @param srcPath       视频源
 *  @param degrees     旋转角度
 *  @param videoWidth  视频宽度
 *  @param videoHeight 视频高度
 */
+ (void)executeRotateWithPath:(NSString*)srcPath degrees:(CGFloat)degrees width:(CGFloat)videoWidth height:(CGFloat)videoHeight dstPath:(NSString *)dstPath;
/**
 *  把视频旋转90度
 * 进度以 "LanSongVideoEditorProgress"通知 发出,可见本文件最后通知的使用.
 *  @param srcPath 输入视频源
 */
+ (void)executeRotate90WithPath:(NSString*)srcPath dstPath:(NSString *)dstPath;

/**
 *  把视频旋转180度
 *  进度以 "LanSongVideoEditorProgress"通知 发出,可见本文件最后通知的使用.
 *  @param srcPath 输入视频源
 */
+ (void)executeRotate180WithPath:(NSString*)srcPath dstPath:(NSString *)dstPath;


/**
 *  对视频进行缩放
 * 进度以 "LanSongVideoEditorProgress"通知 发出,可见本文件最后通知的使用.
 *  @param srcPath  输入源
 *  @param scaleX 宽度缩放值, 范围0--1
 *  @param scaleY 高度缩放值,范围0--1
 */
+ (void)executeScaleWithPath:(NSString*)srcPath scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY dstPath:(NSString *)dstPath;

/**
 *  给视频增加一个CALayer, 可以是文字, 也可以是图片
 *
  进度以 "LanSongVideoEditorProgress"通知 发出,可见本文件最后通知的使用.
 *  @param srcPath      输入源
 *  @param inputLayer CALayer的对象.
 */
+ (void)executeAddLayerWithPath:(NSString*)srcPath watermarkLayer:(CALayer *)inputLayer dstPath:(NSString *)dstPath;

/**
 *  裁剪视频
 *  进度以 "LanSongVideoEditorProgress"通知 发出,可见本文件最后通知的使用.
 *  @param srcPath  输入源
 *  @param startX     裁剪的X开始坐标
 *  @param startY     裁剪的Y开始坐标
 *  @param cropW      裁剪的视频宽度
 *  @param cropH      裁剪的视频高度.
 */
+ (void)executeCropFrameWithPath:(NSString*)srcPath startX:(CGFloat)startX startY:(CGFloat)startY cropW:(CGFloat)cropW cropH:(CGFloat)cropH dstPath:(NSString *)dstPath;

/**
 *  裁剪视频画面,并增加CALayer
 *
  进度以 "LanSongVideoEditorProgress"通知 发出,可见本文件最后通知的使用.
 *  @param srcPath      输入源
 *  @param inputlayer 需要叠加的layer
 *  @param startX     裁剪的X开始坐标
 *  @param startY     裁剪的Y开始坐标
 *  @param cropW      裁剪的视频宽度
 *  @param cropH      裁剪的视频高度.
 */
+ (void)executeCropCALayerWithPath:(NSString*)srcPath layer:(CALayer *)inputlayer startX:(CGFloat)startX startY:(CGFloat)startY cropW:(CGFloat)cropW cropH:(CGFloat)cropH dstPath:(NSString *)dstPath;
/**
 两个音频混合,混合后导出AAC编码的的音频.
 默认是以第一个音频的时长为准, 如果第二个音频很短(比如背景音乐),第二个音频是否要循环.
 
 @param first 第一个多媒体路径, 可以是音频,也可以是含有音频的视频.
 @param second 第二个多媒体路径
 @param isLoop  默认是以第一个音频的时长为准, 如果第二个音频很短(比如背景音乐),第二个音频是否要循环.
 @param firstV 第一个的在混合时的音量
 @param secondV 第二个在混合时的音量.
 @param dstPath 混合后的目标文件
 */
+(void)mixTwoAudio:(NSURL *)first second:(NSURL *)second secondLoop:(BOOL)isLoop firstVolume:(float)firstV secondVolume:(float)secondV dstPath:(NSURL *)dstPath;
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

/*
 //注册通知
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LanSongVideoEditorProgress:) name:@"LanSongVideoEditorProgress" object:nil];

 //注销通知
 [[NSNotificationCenter defaultCenter] removeObserver:self];

 
 //相应通知,并得到当前进度.
 - (void)LanSongVideoEditorProgress:(NSNotification *)notification{
 
     NSDictionary *dict = (NSDictionary *)notification.userInfo;
     NSNumber *number=[dict objectForKey:@"LanSongVideoEditorProgress"];
     if(number!=nil){
        if (demoHintHUD!=nil) {
        demoHintHUD.labelText=[NSString stringWithFormat:@"进度:%d",(int)(number.floatValue*100)];
        }
        }
 }
 */
@end
