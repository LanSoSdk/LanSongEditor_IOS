//
//  LanSongAudioRecorder.h
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LSOAudioRecorder : NSObject


/**
 初始化
 
 [可以不调用]
 默认是 44100, 双通道;
 
 @param sampleRate 采样率
 @param chnels 通道数, 单通道=1, 双通道=2;
 */
-(id)initWithSampleRate:(float)sampleRate chnls:(int)chnels;


/**
 开始
 */
-(void)startRecord;


/**
 结束 停止后,返回录制的音频文件;
 */
-(NSString *)stopRecord;

/**
 是否在录制中.
 */
@property BOOL isRecording;

@end
