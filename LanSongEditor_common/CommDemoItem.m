//
//  CommDemoItem.m
//  LanSoEditor_common
//
//  Created by sno on 16/12/10.
//  Copyright © 2016年 lansongsdk. All rights reserved.
//

#import "CommDemoItem.h"
#import <LanSongEditorFramework/LanSongEditor.h>
#import <LansongEditorFramework/MediaInfo.h>
#import <LanSongEditorFramework/LanSongFileUtil.h>

@implementation CommDemoItem

-(id)initWithID:(int)demoId hint:(NSString *)hint
{
    self=[super init];
    if (self) {
        self.demoID=demoId;
        self.strHint=hint;
    }
    return self;
}
/**
 *  演示获取音视频文件信息
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(NSString *)demoMediaInfo:(NSString *)srcPath
{
    MediaInfo *info=[[MediaInfo alloc]initWithPath:srcPath];
    [info prepare];
    LSLog(@"info :%@",srcPath);
    
    return [info description];
}
/**
 *  演示删除音频.即提取视频部分
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+ (void)demoDeleteAudio:(NSString *)srcPath dstMp4:(NSString *)dstMp4
{
    [VideoEditor executeDeleteAudio:srcPath dstPath:dstMp4];
}
/**
 *  演示删除视频,即提取音频部分
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+ (void)demoDeleteVideo:(NSString *)srcPath dstAAC:(NSString *)dstAAC
{
    [VideoEditor executeDeleteVideo:srcPath dstPath:dstAAC];
}
/**
 *  演示音视频合并, 也可以用作增加背景音乐,替换音频.
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+ (void)demoVideoMergeAudio:(NSString *)srcVideo srcAudio:(NSString *)srcAudio dstMp4:(NSString *)dstMp4
{
    MediaInfo *info=[[MediaInfo alloc] initWithPath:srcVideo];
    if ([info prepare]) {
        if ([info hasAudio]) { //如果有音频,则先删除之前的音频
            
            NSString *tmpMp4= [LanSongFileUtil genTmpMp4Path];
            [CommDemoItem demoDeleteAudio:srcVideo dstMp4:tmpMp4];
            
            [VideoEditor executeVideoMergeAudio:tmpMp4 audioFile:srcAudio dstFile:dstMp4];
            [LanSongFileUtil deleteFile:tmpMp4];
        }else{
            [VideoEditor executeVideoMergeAudio:srcVideo audioFile:srcAudio dstFile:dstMp4];
        }
    }else{
        
    }
}
/**
 *  对音频剪切
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void) demoAudioCutOut:(NSString *)srcAudio dstPath:(NSString *)dstPath
{
    MediaInfo *info =[[MediaInfo alloc] initWithPath:srcAudio];
    if ([info prepare]) {
        [VideoEditor executeAudioCutOut:srcAudio dstFile:dstPath startS:0.0 duration:info.aDuration/2];
    }
}
/**
 *  对视频剪切
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void) demoVideoCutOut:(NSString *)srcVideo dstPath:(NSString *)dstPath
{
    MediaInfo *info =[[MediaInfo alloc] initWithPath:srcVideo];
    if ([info prepare]) {
        [VideoEditor executeVideoCutOut:srcVideo dstFile:dstPath start:0.0 durationS:info.vDuration/2];
    }
}
/**
 *  演示视频拼接
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void) demoVideoConcat:(NSString *)srcVideo dstVideo:(NSString *)dstVideo
{
    MediaInfo *info =[[MediaInfo alloc] initWithPath:srcVideo];
    if ([info prepare]) {
        
        //第一步创建视频文件字符串,用来保存演示的临时文件
        NSString *seg1=  [LanSongFileUtil genFileNameWithSuffix:info.fileSuffix];
        NSString *seg2=  [LanSongFileUtil genFileNameWithSuffix:info.fileSuffix];
        
        NSString *segTs1=[LanSongFileUtil genFileNameWithSuffix:@"ts"];
        NSString *segTs2=[LanSongFileUtil genFileNameWithSuffix:@"ts"];
        
        //为了演示方便,直接截成两个文件, 实际中你可以传入两个文件
        [VideoEditor executeVideoCutOut:srcVideo dstFile:seg1 start:0 durationS:info.vDuration/3];
        [VideoEditor executeVideoCutOut:srcVideo dstFile:seg2 start:info.vDuration*2/3 durationS:info.vDuration];
        
        //第二步:把MP4文件转换为TS流
        [VideoEditor executeConvertMp4toTs:seg1 dstTs:segTs1];
        [VideoEditor executeConvertMp4toTs:seg2 dstTs:segTs2];
        
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:2];
        
        [mutableArray addObject:segTs1];
        [mutableArray addObject:segTs2];
        
        //第三步: 把ts流再次转换为MP4文件.
        [VideoEditor executeConvertTsToMp4:mutableArray dstFile:dstVideo];
        
        //删除为了演示而生成的临时文件.
        [LanSongFileUtil deleteFile:segTs2];
        [LanSongFileUtil deleteFile:segTs1];
        [LanSongFileUtil deleteFile:seg1];
        [LanSongFileUtil deleteFile:seg2];
        
    }
}
//------------------------------------
/**
 *  旋转视频90度.
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void)demoRorateVideo90:(NSString *)srcPath dstPath:(NSString *)dstPath
{
    [VideoEditor executeRotate90WithPath:srcPath dstPath:dstPath];
}
/**
 *  旋转视频180度.
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void)demoRorateVideo180:(NSString *)srcPath dstPath:(NSString *)dstPath
{
    [VideoEditor executeRotate180WithPath:srcPath dstPath:dstPath];
}

/**
 *  把视频缩放一半
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void)demoScaleWithPath:(NSString*)srcPath dstPash:(NSString *)dstPash
{
    [VideoEditor executeScaleWithPath:srcPath scaleX:0.5f scaleY:0.5f dstPath:dstPash];
}
/**
 *  给视频增加一个CALayer
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void)demoAddLayerWithPath:(NSString*)srcVideo dstPash:(NSString *)dstPash
{
    MediaInfo *info =[[MediaInfo alloc] initWithPath:srcVideo];
    if ([info prepare]) {
        //
        CALayer *retLayer = [CALayer layer];
        
        CATextLayer *titleLayer = [CATextLayer layer];
        titleLayer.string = @"增加CALayer演示";
        titleLayer.foregroundColor = [[UIColor redColor] CGColor];
        titleLayer.shadowOpacity = 0.5;
        titleLayer.alignmentMode = kCAAlignmentCenter;
        titleLayer.backgroundColor=[[UIColor blueColor] CGColor];
        
        //宽高和视频中的尺寸一一对应,这里仅设置为一般的宽高.
        titleLayer.bounds = CGRectMake(0, 0, info.width/2, info.height/2);
        
        
        [retLayer addSublayer:titleLayer];
        
        //设置layer在视频中的中心位置. 以视频的中心为中心.
        retLayer.position =CGPointMake(info.width/2,info.height/2);  //设置位置.
        
        [VideoEditor executeAddLayerWithPath:srcVideo watermarkLayer:retLayer dstPath:dstPash];
    }else{
        LSLog(@" add calayer  error!!!:%@",info);
    }
}
/**
 *  对视频画面裁剪,这里 演示裁剪成原来的一般.
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void)demoCropFrameWithPath:(NSString*)srcPath dstPash:(NSString *)dstPash
{
    MediaInfo *info =[[MediaInfo alloc] initWithPath:srcPath];
    if ([info prepare]) {
        [VideoEditor executeCropFrameWithPath:srcPath startX:0 startY:0 cropW:info.getWidth/2 cropH:info.getHeight/2 dstPath:dstPash];
    }
}
/**
 *  对视频画面裁剪,并增加一个CALayer到视频上.
 *
 *  注意: 这里仅仅是演示, 不属于SDK的一部分,仅仅是演示.
 *
 */
+(void) demoCropCALayerWithPath:(NSString*)srcPath dstPash:(NSString *)dstPash
{
    
    MediaInfo *info =[[MediaInfo alloc] initWithPath:srcPath];
    if ([info prepare]) {
        
        CALayer *retLayer = [CALayer layer];
        
        CATextLayer *titleLayer = [CATextLayer layer];
        titleLayer.string = @"裁剪后增加CALayer演示";
        titleLayer.foregroundColor = [[UIColor blueColor] CGColor];
        titleLayer.shadowOpacity = 0.5;
        titleLayer.alignmentMode = kCAAlignmentCenter;
        titleLayer.backgroundColor=[[UIColor redColor] CGColor];
        
        
        //宽高和视频中的尺寸一一对应,这里仅设置为一般的宽高.
        titleLayer.bounds = CGRectMake(0, 0, info.width/4, info.height/4);
        
        
        [retLayer addSublayer:titleLayer];
        
        //设置layer在视频中的中心位置. 以视频的中心为中心.
        retLayer.position =CGPointMake(info.width/4,info.height/4);  //设置位置.
        
        [VideoEditor executeCropCALayerWithPath:srcPath layer:retLayer startX:0 startY:0 cropW:info.width/2 cropH:info.height/2 dstPath:dstPash];
        
    }
}
@end

