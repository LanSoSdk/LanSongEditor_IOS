//
//  LanSongSoundTouch.h
//  testSoundTouch
//
//  Created by sno on 18/11/2017.
//  Copyright © 2017 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 没有任何的延迟, 填入什么, 就可以返回对应的.
 */
@interface LanSongSoundTouch : NSObject


/**
 初始化
 
 @param sampleRate 采样率
 @param channel 通道数
 */
-(id)initWithSampleRate:(float)sampleRate channel:(int)channel;


///**
// 在不影响声音音调的前提下改变音频播放的快、慢节奏。
// (-50 .. +100 %)
// 默认为0
// pitch，tempo，rate必须在processData之前就设定好。而不是填充好数据了才设置新的值。
//不再使用,采用0.5--2.0的形式
// */
//-(void)setTempoChange:(int)tempo;

/**
 设置声音的速度, 默认是1.0; 最小是0.5; 最大是2.0;

 @param speed 速度;
 */
-(void)setAudioSpeed:(float)speed;

/*
 在保持原有节奏（速度）的前提下改变音调；
 (-12 .. +12)
 默认是0;
 //男: -8 女:12
 */
-(void)setPitchSemiTones:(int)pitch;
/*
 同时改变节奏和音调。
 设置声音的速率, 调节后,会变调;,不建议使用.
 (-50 .. +100 %)
 默认为0;
 */
-(void)setRateChange:(int)rate;


/**
 把节奏和音调都回复都正常状态.
 不变速也不变调.
 */
-(void)resetDefultValue;
/**
 开始执行.
 内部阻塞执行, 直到数据全部提取出来为止.
 
 有个致命的问题: 送进去的数据, 一定要完整的一段才有数据返回不然没有返回
 比如: NSMutableData *soundTouchDatas = [touch processData:(char *)soundData.bytes len:(int)soundData.length];
 
 @param pcmData 采样字节
 @param pcmSize 指针大小
 @return 返回处理 后的数据.
 */
-(NSMutableData *)processData:(char *)pcmData len:(int)pcmSize;;

/**
 创建wav的头部字节数据
 
 @param fileLength 文件总共的字节数
 @param channel 通道数
 @param sampleRate 采样率
 @param bitPerSample 每个采样点所占的位, 一般是16;
 @return 返回一个指针, 记得要释放这个指针, 指针长度是44个字节,固定长度;
 */
+(void *)lanSongWaveHeader:(int) fileLength chnnl:(short) channel sampleRate:(int)sampleRate bits:(short) bitPerSample;

-(void)destory;

/*

 *
*/
@end
