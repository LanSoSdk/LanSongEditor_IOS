//
//  CommDemoItem.h
//  LanSoEditor_common
//
//  Created by sno on 16/12/10.
//  Copyright © 2016年 lansongsdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface CommDemoItem : NSObject

@property  NSString *strHint;
@property  int demoID;

-(id)initWithID:(int)id hint:(NSString *)hint;


+(NSString *)demoMediaInfo:(NSString *)srcPath;
/**
 *  演示删除音频.即提取视频部分
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+ (void)demoDeleteAudio:(NSString *)srcPath dstMp4:(NSString *)dstMp4;
/**
 *  演示删除视频,即提取音频部分
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+ (void)demoDeleteVideo:(NSString *)srcPath dstAAC:(NSString *)dstAAC;
/**
 *  演示音视频合并, 也可以用作增加背景音乐,替换音频.
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+ (void)demoVideoMergeAudio:(NSString *)srcVideo srcAudio:(NSString *)srcAudio dstMp4:(NSString *)dstMp4;
/**
 *  对音频剪切
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void) demoAudioCutOut:(NSString *)srcAudio dstPath:(NSString *)dstPath;
/**
 *  对视频剪切
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void) demoVideoCutOut:(NSString *)srcVideo dstPath:(NSString *)dstPath;
/**
 *  演示视频拼接
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void) demoVideoConcat:(NSString *)srcVideo dstVideo:(NSString *)dstVideo;

/**
 *  旋转视频90度.
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */+(void)demoRorateVideo90:(NSString *)srcPath dstPath:(NSString *)dstPath;
/**
 *  旋转视频180度.
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void)demoRorateVideo180:(NSString *)srcPath dstPath:(NSString *)dstPath;

/**
 *  把视频缩放一半
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void)demoScaleWithPath:(NSString*)srcPath dstPash:(NSString *)dstPash;
/**
 *  给视频增加一个CALayer
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void)demoAddLayerWithPath:(NSString*)srcVideo dstPash:(NSString *)dstPash;
/**
 *  对视频画面裁剪,这里 演示裁剪成原来的一般.
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void)demoCropFrameWithPath:(NSString*)srcPath dstPash:(NSString *)dstPash;
/**
 *  对视频画面裁剪,并增加一个CALayer到视频上.
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void) demoCropCALayerWithPath:(NSString*)srcPath dstPash:(NSString *)dstPash;
@end

