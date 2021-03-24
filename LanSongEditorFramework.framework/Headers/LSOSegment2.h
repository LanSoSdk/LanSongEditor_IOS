//
//  LSOSegment2.h
//  LanSongEditorFramework
//
//  Created by sno on 2021/3/16.
//  Copyright © 2021 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

typedef void(^segmentCallback2)(void *rgba,int width,int height);

@protocol LSOSegmentInput <NSObject>

/// 加载模型
- (void)loadModelAndProto;


/// 分割一帧画面
/// @param image_buffer 原始的数据,
/// @param callback 分割完毕后的回调, 回调工作在UI线程;
- (void)segmentPixelBuffer:(CVPixelBufferRef)image_buffer  callback:(segmentCallback2)callback;

/// 释放模型
- (void)releaseModelAndProto;

@end


@interface LSOSegment2 : NSObject

+ (void)setSegmentInput:(id<LSOSegmentInput> )input;








@end

NS_ASSUME_NONNULL_END
