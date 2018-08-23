//
//  MediaInfo.h
//
//  Created by lansong on 16/9/15.
//

/**
 *  
 
 使用方法:
 MediaInfo *info=[[MediaInfo alloc]initWithPath:srcAACPath];
 [info prepare];
 NSLog(@"info :%@",info);
 
 
 
 
 *
 *
 */

#import <Foundation/Foundation.h>

@interface MediaInfo : NSObject


/**
 *   初始化MediaInfo对象. 创建成功返回对象,失败返回nil
 *
 *  @param filepath 文件的完整路径
 *
 *  @return 对象本身.
 */
-(id)initWithPath:(NSString *)filepath;

-(id)initWithURL:(NSURL *)url;
/**
 *  初始化后,需要执行prepare, 才可以得到当前视频的一些信息.
 *
 *  @return 执行成功,返回YES,失败返回NO;
 */
-(BOOL)prepare;
/**
 *  是在prepare后执行的, 检查当前文件是否支持.
 * 如果单纯的检查文件是否支持,可以用类方法 isSupport, 见下面.
 *
 *  @return 支持返回YES, 不支持返回NO;
 */
-(BOOL)isSupport;
/**
 *  类方法, 单纯的判断当前传递过来的文件是否支持.
 *
 *  @param videoPath 视频文件完整路径
 *
 *  @return 支持返回YES, 不支持返回NO;
 */
+(BOOL) isSupport:(NSString*)videoPath;


/**
 检查当前文件,内部会打印出检查出的各种信息log;

 同时这些信息也会返回.
 */
+(NSString *) checkFile:(NSString*)videoPath;

@property(nonatomic, readonly) NSString *filePath;
@property(nonatomic, readonly) NSString *fileName;
@property(nonatomic, readonly) NSString *fileSuffix;

//-------------一下是prepare后得到的信息;
/**
 * 视频的显示宽度, 即正常视频宽度. 如果视频旋转了90度或270度,则这里等于实际视频的高度,请注意!!
 */
@property(nonatomic) int vWidth;
/**
 * 视频的显示高度,即正常视频高度. 如果视频旋转了90度或270度,则这里等于实际视频的宽度!!
 */
@property(nonatomic) int vHeight;
/**
 *  视频在编码时的高度, 编码是以宏块为单位,默认是16的倍数;
 *
 */
@property(nonatomic) int vCodecWidth;
@property(nonatomic) int vCodecHeight;
/**
 * mp4文件中的视频轨道的总时长, 注意,一个mp4文件可能里面的音频和视频时长不同.//单位秒.
 */
@property(nonatomic) double vDuration;
/**
 * 视频的码率,注意,一般的视频编码时采用的是动态码率VBR,故这里得到的是平均值
 *
 */
@property(nonatomic) int64_t vBitRate;
/**
 * 视频帧率,可能有浮点数,
 */
@property(nonatomic) float  vFrameRate;
/**
 * 视频文件中的视频流总帧数.
 */
@property(nonatomic) int64_t vTotalFrames;
/**
 * 该视频是否有B帧, 即双向预测帧, 如果有的话, 在裁剪时需要注意, 目前大部分的视频不存在B帧.
 */
@property(nonatomic) BOOL vHasBFrame;
/**
 * 视频旋转角度, 比如android手机拍摄的视频, 后置摄像头旋转270度, 前置摄像头旋转了90度; IOS设备拍摄的是前后摄像头都旋转90度.
 * 各类视频网站提供的视频, 是没有旋转的.
 */
@property(nonatomic) float vRotateAngle;
/**
 * 视频可以使用的解码器,用来设置到{@link VideoEditor}中的各种需要编码器的场合使用.
 */
@property(nonatomic) NSString *vCodecName;
/**
 * 视频的 像素格式.目前暂时没有用到.
 */
@property(nonatomic) NSString *vPixelFormat;

//-------音频信息
/**
 * 音频可以用的 解码器, 由此可以判定音频是mp3格式,还是aac格式,如果是mp3则这里"mp3"; 如果是aac则这里"aac";
 */
@property(nonatomic) NSString *aCodecName;
/**
 * 音频采样率
 */
@property(nonatomic) int aSampleRate;
/**
 * 音频通道数量
 */
@property(nonatomic) int aChannels;
/**
 * 视频文件中的音频流 总帧数.
 */
@property(nonatomic) int64_t aTotalFrame;
/**
 * 音频的码率,可用来检测视频文件中是否存在音频
 */
@property(nonatomic) int64_t aBitRate;
/**
 * 多媒体文件中的音频总时长
 */
@property(nonatomic) double aDuration;
/**
 * 音频的最大码率, 这里暂时没有用到.
 */
@property(nonatomic) int64_t aBitRateMax;
/**
 *  是否有视频
 *
 *  @return
 */
-(BOOL) hasVideo;

/**
 *  是否有音频
 *
 *  @return
 */
-(BOOL) hasAudio;

-(int)getWidth;

-(int)getHeight;

-(NSString *)description;


@end
