//
//  MyDecoder.h
//  LanSongEditorFramework
//
//  Created by sno on 16/12/21.
//  Copyright © 2016年 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Pen.h"





/**
 * Source object for filtering movies
 * 解码传递过来的文件路径. 解码
 */
@interface VideoPen : Pen



@property (readwrite, retain) AVAsset *asset;

@property(readwrite, retain) NSURL *url;


@property(readwrite, nonatomic) BOOL playAtActualSpeed;


/**
 *  初始化
 *
 *  @param url    url路径
 *  @param size   画板的尺寸
 *  @param target 目标
 *
 *  @return
 */
- (id)initWithURL:(NSURL *)url drawpadSize:(CGSize)size drawpadTarget:(id<GPUImageInput>)target;

@end
