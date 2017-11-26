//
//  LanSongAudioRecorder.h
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LanSongAudioRecorder : NSObject




/**
 初始化
 
 @param saveUrl 保存路径, 后缀名一定是m4a, 或aac
 */
-(id)initWithSaveURL:(NSURL *)saveUrl;
/**
 初始化

 @param sampleRate 采样率
 @param chnels 通道数, 单通道=1, 双通道=2;
 @param saveUrl 保存路径
 */
-(id)initWithSampleRate:(float)sampleRate chnls:(int)chnels saveUrl:(NSURL *)saveUrl;


/**
 开始
 */
-(void)startRecord;


/**
 结束
 */
-(void)stopRecord;


/**
 是否在录制中.
 */
@property BOOL isRecording;

@end
