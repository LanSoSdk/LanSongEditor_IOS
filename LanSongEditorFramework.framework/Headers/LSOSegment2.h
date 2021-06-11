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

//好的模型;
- (void)useGoodModel;

/// 切换到快速模型;
- (void)useFastModel;

/// 分割一帧画面
/// @param image_buffer 原始的数据,
/// @param callback 分割完毕后的回调, 回调工作在UI线程;
- (void)segmentPixelBuffer:(CVPixelBufferRef)image_buffer  callback:(segmentCallback2)callback;

- (void)segmentAlphaDotPixelBuffer:(CVPixelBufferRef)image_buffer  callback:(segmentCallback2)callback;


/// 释放模型
- (void)releaseModelAndProto;



       
@end


//-----------正式接口.

@interface LSOSegment2 : NSObject

+ (void)setSegmentInput:(id<LSOSegmentInput> )input;












@end

NS_ASSUME_NONNULL_END
