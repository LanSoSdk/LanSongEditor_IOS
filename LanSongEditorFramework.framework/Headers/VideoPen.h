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


@property(readwrite, nonatomic) BOOL playSound;

@property (readwrite, retain) AVAsset *asset;

@property (readwrite, retain) AVPlayerItem *playerItem;
@property(readwrite, retain) NSURL *url;


@property(readwrite, nonatomic) BOOL playAtActualSpeed;

@property(readwrite, nonatomic) BOOL shouldRepeat;


@property(readonly, nonatomic) float progress;



@property (readonly, nonatomic) AVAssetReader *assetReader;
@property (readonly, nonatomic) BOOL audioEncodingIsFinished;
@property (readonly, nonatomic) BOOL videoEncodingIsFinished;

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
