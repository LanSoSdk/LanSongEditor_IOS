//
//  LSOGetMVFrame.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/7/20.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LanSongContext.h"
#import "LanSongOutput.h"
#import "LanSongFilter.h"
#import "LanSongTwoInputFilter.h"



/**
 把两个mv视频合成后, 提取其中的是视频帧;
 */
@interface LSOGetMVFrame : LanSongOutput


/**
 初始化的两个视频路径;
 */
- (id)initWithURL:(NSURL *)url maks:(NSURL *) url2;


/**
 从0开始读取;
 可以多次调用
 */
-(void)start;

/**
 开始的时间, 单位秒;
 可以多次调用. 时间超过视频最大值,则从0开始;
 */
-(void)start:(CGFloat)time;

/**
 获取一帧, 阻塞执行,
 内部用到GPU队列,不可同时使用其他方法处理;
 
 如在开启后多次调用, 则依次返回视频中的每一帧;
 @return 返回当前帧的画面; 失败或走到文件尾:返回nil
 */
-(UIImage *)getOneFrame;



/*
 使用完毕后, 请释放对象;
 */
@end

