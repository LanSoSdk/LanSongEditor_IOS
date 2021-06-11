//
//  LSOSegmentOneFrame.h
//  LanSongEditorFramework
//
//  Created by sno on 2021/5/22.
//  Copyright © 2021 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOSegmentOneFrame : NSObject

/// 分割得到一帧画面
///  画面可以是图片或视频, 根据输入的url后缀判断图片或视频;
/// @param url
- (instancetype)initWithURL:(NSURL *)url;


/// 开始异步分割, 分割后返回一帧画面;
/// @param hander 返回的handler工作在UI线程;
- (void)startWithHandler:(void (^)(UIImage *image))hander;

@end

NS_ASSUME_NONNULL_END
