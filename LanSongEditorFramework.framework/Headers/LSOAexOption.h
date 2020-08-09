//
//  LSOAexOption.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/7/9.
//  Copyright © 2020 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSOAexOption : LSOObject


/**
 当替换为视频的时候,视频开始裁剪的时间点;
 裁剪时长等于LSOAexImage的时长;
 图片不起作用;
 */
@property (nonatomic,assign) CGFloat videoCutStartTimeS;

/**
 缩放类型.
 当输入的画面和 LSOAexImage不一致时, 可设置缩放类型;
 图片和视频 均适用;
 */
@property (nonatomic,readwrite)  LSOScaleType scaleType;


@end

NS_ASSUME_NONNULL_END
