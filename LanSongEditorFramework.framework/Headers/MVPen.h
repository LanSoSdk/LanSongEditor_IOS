//
//  MyDecoder.h
//  LanSongEditorFramework
//
//  Created by sno on 17/2/21.
//  Copyright © 2017年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Pen.h"


/**
 当MV播放到最后一帧的时候, 做合作方式处理
 */
typedef NS_ENUM(NSUInteger, MVEndMode) {
    /*循环播放 ,默认是循环.*/
    kMVMode_Loop,
    /*停留在最后一帧*/
    kMVMode_LastFrame,
    /*消失*/
    kMVMode_Hide
};


/**
 * Source object for filtering movies
 * 解码传递过来的文件路径. 解码
 */
@interface MVPen : Pen

/**
 内部使用.
 */
@property(readwrite, nonatomic) BOOL playAtActualSpeed;



/**
 MV当播放到最后一帧时, 采用何种方式.
  有, 循环播放/停留在最后一帧/消失三种方法.
 默认是循环
 */
@property MVEndMode mvMode;
/**
 *  初始化
 *
 *  @param url    url路径
 *  @param size   画板的尺寸
 *  @param target 目标
 *
 *  @return
 */
- (id)initWithURL:(NSURL *)url maks:(NSURL *) url2 drawpadSize:(CGSize)size drawpadTarget:(id<GPUImageInput>)target;

@end
