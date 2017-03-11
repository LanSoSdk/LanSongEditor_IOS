//
//  AVDecoder.h
//  LanSongEditorFramework
//
//  Created by sno on 17/3/8.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
   视频解码器; 当前是采用软解码的形式, 使用在小视频, 如mv等.
 
 当前不包括音频.
 */
@interface AVDecoder : NSObject


/**
 初始化

 @param videoPath 当前视频文件的完整路径
 @return 
 */
-(id)initWithPath:(NSString *)videoPath;

/**
 解码一帧
 
 @param seekUs 是否seek, 小于0不seek; >=0则seek; 单位微秒; 如果seek,则因为视频IDR编码原理,可能不会直接seek到指定位置, 需要通过返回的时间戳来判断;
 @param rgbOut 解码后的输出地方, 由外面创建,大小等于 宽度*高度*4
 @return 解码后的当前帧的时间戳.
 */
-(long)decodeOneFrame:(long)seekUs rgbOut:(int *)rgbOut;

/**
 当前文件是否走到最后. 在decodeOneFrame后创建.
 
 @return
 */
-(BOOL)isEnd;

/**
 释放解码器, 可以不调用.
 */
-(void)releaseDecoder;

@end
