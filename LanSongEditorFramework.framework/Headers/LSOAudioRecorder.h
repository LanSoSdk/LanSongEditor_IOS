//
//  LanSongAudioRecorder.h
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LSOObject.h"

@interface LSOAudioRecorder : LSOObject


/**
 开始
 */
-(void)startRecord;


/**
 结束 停止后,返回录制的音频文件;
 当前返回的是wav文件格式;
 */
-(NSURL *)stopRecord;

/**
 是否在录制中.
 */
@property BOOL isRecording;

@end
